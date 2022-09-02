#!/bin/bash
# Kubernetes部署环境要求：
#（1）一台或多台机器，操作系统CentOS 7.x-86_x64
#（2）硬件配置：内存2GB或2G+，CPU 2核或CPU 2核+；
#（3）集群内各个机器之间能相互通信；
#（4）集群内各个机器可以访问外网，需要拉取镜像；
#（5）禁止swap分区；

# 安装步骤
#1. 安装docker
#1.1 如果没有安装docker，则安装docker。会附带安装一个docker-compose
#
#2. 安装k8s
#2.1 初始化环境
#2.2 添加安装源
#2.3 安装kubelet、kubectl、kubeadmin
#2.4 安装master
#2.5 安装网络插件

set -e

# 安装日志
install_log=/var/log/install_k8s.log
tm=$(date +'%Y%m%d %T')

# 日志颜色
COLOR_G="\x1b[0;32m"  # green
RESET="\x1b[0m"

function info(){
    echo -e "${COLOR_G}[$tm] [Info] ${1}${RESET}"
}

function run_cmd(){
  sh -c "$1 | $(tee -a "$install_log")"
}

function run_function(){
  $1 | tee -a "$install_log"
}

function install_docker(){
  info "1.使用脚本安装docker..."
  yum install -y yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  #yum install -y docker-ce
  #yum install -y docker-ce-19.03.9-3.el7
  yum install -y docker-ce-20.10.17-3.el7

  info "2.启动 Docker CE..."
  sudo systemctl enable docker
  sudo systemctl start docker

  info "3.添加镜像加速器..."
  if [ ! -f "/etc/docker/daemon.json" ];then
    touch /etc/docker/daemon.json
  fi
  cat <<EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://4txtc8r4.mirror.aliyuncs.com"]
}
EOF

  info "4.重新启动服务..."
  sudo gpasswd -a ${USER} docker && newgrp - docker # 将当前用户加入到docker组(获取执行docker的权限)
  sudo systemctl daemon-reload
  sudo systemctl restart docker

  info "5.测试 Docker 是否安装正确..."
  docker -v

  info "6.检测..."
  docker info

  read -p "是否安装docker-compose？默认为 no. Enter [yes/no]：" is_compose
  if [[ "$is_compose" == 'yes' ]];then
    info "7.安装docker-compose"
    sudo curl -L "https://get.daocloud.io/docker/compose/releases/download/v2.10.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod a+x /usr/local/bin/docker-compose
    if [ -f "/usr/bin/docker-compose" ];then
      sudo rm -f /usr/bin/docker-compose
    fi
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose # 创建快捷方式

    # 8.验证是否安装成功
    info "8.验证docker-compose是否安装成功..."
    docker-compose -v
  fi
}

function install_k8s() {
    info "初始化k8s部署环境..."
    init_env

    info "添加k8s安装源..."
    add_aliyun_repo

    info "安装kubelet kubeadmin kubectl..."
    install_kubelet_kubeadmin_kubectl

    info "安装kubernetes master..."
    yum install -y net-tools
    if [[ ! "$(ps aux | grep 'kubernetes' | grep -v 'grep')" ]];then
      kubeadmin_init
    else
      info "kubernetes master已经安装..."
    fi

    info "安装网络插件flannel..."
    install_flannel

    info "去污点..."
    kubectl taint nodes --all node-role.kubernetes.io/master-
    cat <<-EOF >>/etc/ssh/ssh_config
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
EOF
}

# 初始化部署环境
function init_env() {
  info "关闭防火墙"
  systemctl stop firewalld
  systemctl disable firewalld

  info "关闭selinux"
  sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/g' /etc/selinux/config
  source /etc/selinux/config

  info "关闭swap（k8s禁止虚拟内存以提高性能）"
  swapoff -a
  sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab

  info "设置网桥参数"
  cat <<-EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
  sysctl --system  #生效
  sysctl -w net.ipv4.ip_forward=1

  info "时间同步"
  yum install -y ntpdate
  ntpdate time.windows.com
}

# 添加aliyun安装源
function add_aliyun_repo() {
  cat > /etc/yum.repos.d/kubernetes.repo <<- EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
}

function install_kubelet_kubeadmin_kubectl() {
  #yum install -y kubelet kubeadm kubectl
  #yum install -y kubelet-1.19.4 kubeadm-1.19.4 kubectl-1.19.4
  yum install -y kubelet-1.20.2 kubeadm-1.20.2 kubectl-1.20.2
  systemctl enable kubelet.service

  info "确认kubelet kubeadmin kubectl是否安装成功"
  yum list installed | grep kubelet
  yum list installed | grep kubeadm
  yum list installed | grep kubectl
  kubelet --version
}

function kubeadmin_init() {
  sleep 1
  read -p "请输入master ip地址：" ip
  kubeadm init --apiserver-advertise-address="${ip}" --image-repository=registry.aliyuncs.com/google_containers --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16
  mkdir -p "$HOME"/.kube
  sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
  sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
}

function install_flannel() {
  if [ ! -f "./kube-flannel.yml" ];then
    yum -y install wget
    wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  fi
  kubectl apply -f kube-flannel.yml
}

# 安装docker
read -p "是否安装docker？默认为：no. Enter [yes/no]：" is_docker
if [[ "$is_docker" == 'yes' ]];then
  run_function "install_docker"
fi

# 安装k8s
read -p "是否安装k8s？默认为：no. Enter [yes/no]：" is_k8s
if [[ "$is_k8s" == 'yes' ]];then
  run_function "install_k8s"
fi