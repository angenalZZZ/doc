# 容器化集群 K8S/Kubernetes

#### 安装虚拟机VM
> VM [VirtualBox 6 - Windows hosts](https://www.virtualbox.org/wiki/Downloads)、[CentOS-7-x86_64-DVD.iso](http://isoredirect.centos.org/centos/7/isos/x86_64/)
~~~bash
# 从 VM 安装 Centos7 并设置为`4CPU`+`4G内存`+`桥接网卡`

# 设置静态IP(*网卡设备名称*可在安装时设置或自动分配)
vi /etc/sysconfig/network-scripts/ifcfg-*
BOOTPROTO=static      # dhcp 换成 static (修改)
ONBOOT=yes            # 开机启动 no 换成 yes (修改)
IPADDR=192.168.1.201  # 设置静态IP地址与主机前三位一致(新增)
GATEWAY=192.168.1.1   # 默认网关与主机一致
NETMASK=255.255.255.0 # 子网掩码与主机一致 或者: PREFIX=24
DNS1=8.8.8.8          # DNS1与主机一致(谷歌)
DNS2=223.5.5.5        # DNS2与主机一致(阿里)
DNS3=114.114.114.114  # DNS3与主机一致(国内)
# 重启网络
systemctl restart network
# service network restart
# 查看IP地址
ip addr | grep inet # Centos7命令
# 预设置hosts
vi /etc/hosts
# Kubernetes DNS
192.168.1.201 k8s01
192.168.1.202 k8s02
192.168.1.203 k8s03
# Github DNS
140.82.113.3 github.com
185.199.108.153 assets-cdn.github.com
199.232.69.194 github.global.ssl.fastly.net

# 从 VM 复制为 3 台以上的虚机, 然后设置 IP & hostname
hostnamectl set-hostname k8s01 # 192.168.1.201
hostnamectl set-hostname k8s02 # 192.168.1.202
hostnamectl set-hostname k8s03 # 192.168.1.203
~~~

#### 安装Docker
> 容器化 Docker v19.* 兼容 K8S 版本 v1.19.*
~~~bash
# 关闭防火器(K8S会创建防火器规则,导致防火器规则重复)
systemctl disable firewalld && systemctl stop firewalld
# 安装依赖 device-mapper-persistent-data 是linux下的一个存储驱动(一个高级存储技术) lvm 的作用则是创建逻辑磁盘分区
yum install -y yum-utils device-mapper-persistent-data lvm2
# 配置yum资源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 安装Docker
yum install -y docker-ce-19.03.9-3.el7
# 查安装结果
yum list docker-ce --showduplicates | sort -r
docker -v
# 降级Docker版本
yum downgrade -y --setopt=obsoletes=0 docker-ce-19.03.9-3.el7 docker-ce-cli-19.03.9-3.el7 containerd.io
docker version # 查看版本
# 如果出现镜像文件或者容器丢失情况, 需要更改镜像存储位置.
# sed -i "s#-H fd:#-g /opt/data/docker -H fd:#g" /lib/systemd/system/docker.service
# systemctl daemon-reload && systemctl restart docker
# 设置为开机启动
systemctl enable docker && systemctl start docker
docker info
# 添加阿里yum资源
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
# 设置镜像库,加速拉取推送images
vi /etc/docker/daemon.json # 或设置当前用户 ~/.docker/daemon.json
{
  "registry-mirrors": [
    "https://1nj0zren.mirror.aliyuncs.com", "http://f1361db2.m.daocloud.io",
    "https://docker.mirrors.ustc.edu.cn",
    "https://registry.docker-cn.com"
  ],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
  #"insecure-registries": [], # Or: http://[私有库IP]:[私有库Port]
  #"debug": false,
  #"experimental": true, # Enable实验性功能features:eg. #DOCKER_BUILDKIT=1
  #"features": {
  #  "buildkit": true # syntax = docker/dockerfile:experimental
  #}
}
# 重新加载配置 & 重启docker
systemctl daemon-reload && systemctl restart docker
~~~

#### 安装K8S/Kubernetes
> K8S 版本 v1.19.0
~~~bash
# 安装组件
yum install -y kubelet-1.19.0 kubeadm-1.19.0 kubectl-1.19.0 --disableexcludes=kubernetes
# 管理开机启动
systemctl enable kubelet && systemctl start kubelet
# 开启IPv6 (K8S已支持)
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
# 查看开启情况
sysctl --system
~~~
> K8S master 节点
~~~bash
# 生成初始化文件 kubeadm-init.yaml
kubeadm config print init-defaults > kubeadm-init.yaml
# 修改初始化文件 kubeadm-init.yaml
advertiseAddress: 1.2.3.4 # 改为master虚机IP: 192.168.*.*
imageRepository: k8s.gcr.io # 改为 registry.cn-hangzhou.aliyuncs.com/google_containers
kubernetesVersion: v1.19.0 # 检查版本是否一致并修改
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
  podSubnet: 10.244.0.0/16  # 新增pod子网络
# 摘取镜像, 需提前配置镜像源 /etc/docker/daemon.json
kubeadm config images pull --config kubeadm-init.yaml
# 检查镜像版本TAG
docker images
# 初始化前, 关闭Swap分区及Selinux
swapoff -a       # 临时关闭swap分区
vi /etc/fstab    # 永久关闭swap分区,注释**swap
swapoff -a && sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
setenforce 0     # 临时关闭selinux
vi /etc/sysconfig/selinux
SELINUX=disabled # 永久关闭selinux
setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
getenforce  # 获取Shell执行权 Permissive
# 初始化:执行:
kubeadm init --config kubeadm-init.yaml
# kubeadm init --config kubeadm-init.yaml --ignore-preflight-errors=Swap
# 初始化成功后, 为当前用户配置K8S环境(在输出信息中可查看到)
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
# 查看虚机K8S节点信息
kubectl get node
# 节点状态NoReady为待加入网络
wget https://docs.projectcalico.org/manifests/calico.yaml
# 修改网络配置 calico.yaml
- name: CLUSTER_TYPE   # <<修改位置
  value: "k8s,bgp"
# IP automatic detection. # 此处新增键值对
- name: IP_AUTODETECTION_METHOD
  value: "interface=en.*"
# Auto-detect the BGP IP address.
- name: IP
  value: "autodetect"
# Enable IPIP
- name: CALICO_IPV4POOL_IPIP
  value: "Never"  # 修改键值 Always 为 Never
# 构建网络 calico.yaml
kubectl apply -f calico.yaml
# 查看虚机K8S节点信息 Ready 状态
kubectl get node
# 初始化:执行后, 其它节点加入集群(在输出信息中可查看到), 提前关闭Swap分区及Selinux
kubeadm token list
kubeadm token create --print-join-command # 在master节点查看其它节点加入集群的命令
kubeadm join 192.168.1.201:6433 --token a.* --discovery-token-ca-cert-hash sha256:*
# 在worker节点查看运行的容器 kube-proxy,calico-node
docker ps
# 在master节点查看K8S详细信息
kubectl get node -o wide
~~~
