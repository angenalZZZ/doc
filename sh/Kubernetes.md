# 容器化集群 K8S/Kubernetes

## 云平台搭建
* [腾讯云 TKE](https://cloud.tencent.com/product/tke)
* [阿里云 ACK](https://www.aliyun.com/product/kubernetes)
* `裸机搭建`

#### 安装虚拟机VM
> VM [VirtualBox 6 - Windows hosts](https://www.virtualbox.org/wiki/Downloads)、[CentOS-7-x86_64-DVD.iso](http://isoredirect.centos.org/centos/7/isos/x86_64/)
~~~bash
# 从 VM 安装 Centos7 并设置为`4CPU`+`8G内存`+`桥接网卡`，至少要求为`2CPU`+`4G内存`以上；
# 根据主机情况设置`4CPU`+`8G内存`+`仅主机(Host-Only)网络VirtualBox Host-Only Ethernet Adapter`+`存储SATA/AHCI/固态驱动器.vdi\40G`
# `系统语言英文+添加中文支持`+`修改时区为亚洲上海`+`修改root密码+新建centos管理账号`
# 分别安装虚机：k8s01(master)、k8s02(worker)、k8s03(worker)

# 设置静态IP(*网卡设备名称*可在安装时设置或自动分配)
vi /etc/sysconfig/network-scripts/ifcfg-enp**
BOOTPROTO=static      # dhcp 换成 static (修改)
IPADDR=192.168.1.201  # 新增静态IP与主机(前三位)网段一致     # > ipconfig > IPv4地址: 172.16.10.201/255
GATEWAY=192.168.1.1   # 默认网关与主机一致                  # > ipconfig > 默认网关: 172.16.10.1
PREFIX=24             # 子网掩码与主机一致 即: NETMASK=255.255.255.0 #或 > 子网掩码: 255.255.254.0
DNS1=8.8.8.8          # DNS2与主机一致(谷歌)
DNS2=223.5.5.5        # DNS1与主机一致(阿里) [可选]
DNS3=114.114.114.114  # DNS3与主机一致(国内/移动/联通/电信)
ONBOOT=yes            # 修改开机启动 no 换成 yes
# 重启网络
systemctl restart network  #或 > service network restart
# 查看IP地址
ip addr | grep inet # Centos命令
# 预设置hosts
vi /etc/hosts
# Kubernetes(共享VM虚机DNS)
192.168.1.201 k8s01
192.168.1.202 k8s02
192.168.1.203 k8s03
# Github DNS (可选)
140.82.113.3 github.com
185.199.108.153 assets-cdn.github.com
199.232.69.194 github.global.ssl.fastly.net

# 从 VM 复制为 3 台以上的虚机, 然后设置为共享VM虚机hostname
hostnamectl set-hostname k8s01 # 192.168.1.201
hostnamectl set-hostname k8s02 # 192.168.1.202
hostnamectl set-hostname k8s03 # 192.168.1.203

# 设置免密登录 (可选)
ssh-keygen  # 192.168.1.201 master 节点生成后, 复制.ssh到其它VM虚机
cat .ssh/id_rsa.pub >> .ssh/authorized_keys # 另存公钥
chmod 600 .ssh/authorized_keys # 其它VM虚机非root用户时需读写权限
scp -r .ssh root@k8s02:/root   # 复制.ssh到其它虚机root用户
scp -r .ssh root@k8s03:/root   # 同上
~~~

#### 安装Docker
> 推荐安装1.10.0以上版本的Docker客户端，参考文档[docker-ce](https://yq.aliyun.com/articles/110806)，登录[阿里容器镜像服务](https://cr.console.aliyun.com/cn-hangzhou/instances)<br>
> 容器化 Docker v19.* 兼容 K8S 版本 v1.19.* (或安装最新版Docker+K8S)
~~~bash
# 关闭防火器(K8S会创建防火器规则,导致防火器规则重复) [应用部署K8S时应该开启防火器]
systemctl disable firewalld && systemctl stop firewalld
# 关闭Swap分区及SELinux
# swapoff -a       # 临时关闭swap分区
# vi /etc/fstab    # 永久关闭swap分区,注释**swap
swapoff -a && sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# setenforce 0     # 临时关闭selinux
# vi /etc/sysconfig/selinux
# SELINUX=disabled # 永久关闭selinux
setenforce 0 && sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
# getenforce  # 查看关闭selinux情况Disabled (获取Shell执行权Permissive)
# 安装依赖 device-mapper-persistent-data 是linux下的一个存储驱动(一个高级存储技术) lvm 的作用则是创建逻辑磁盘分区
yum install -y yum-utils device-mapper-persistent-data lvm2
# 添加安装源
# ll /etc/yum.repos.d|grep docker # 查看以前的配置> head /etc/yum.repos.d/docker-ce.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
# 安装Docker
#yum install -y docker-ce # 最新版Docker
#yum install -y docker-ce-19.03.9-3.el7 # 或指定版本19
yum install -y docker-ce-20.10.17-3.el7 # 或指定版本20
# 查安装结果
yum list installed|grep docker # yum list docker-ce | sort -r
# 降级Docker版本(如果要指定版本)
yum downgrade -y --setopt=obsoletes=0 docker-ce-19.03.9-3.el7 docker-ce-cli-19.03.9-3.el7 containerd.io
docker -v # 查看版本
# 如果出现镜像文件或者容器丢失情况, 需要更改镜像存储位置.
# sed -i "s#-H fd:#-g /opt/data/docker -H fd:#g" /lib/systemd/system/docker.service
# systemctl daemon-reload && systemctl restart docker
# 设置为开机启动
systemctl enable docker && systemctl start docker
# 配置镜像加速器, 通过修改系统配置文件/etc/docker/daemon.json 可设置多个镜像, 加速拉取推送images
#  @"exec-opts": 设置兼容cgroup驱动systemd  @"insecure-registries": 设置http://[私有库IP]:[私有库Port]
#  @"features": { "buildkit": true # syntax = docker/dockerfile:experimental }
vi /etc/docker/daemon.json # 或设置当前用户 ~/.docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://4txtc8r4.mirror.aliyuncs.com"]
}
# {
#   "exec-opts": ["native.cgroupdriver=systemd"],
#   "registry-mirrors": [
#      "https://4txtc8r4.mirror.aliyuncs.com","http://8fe1b42e.m.daocloud.io",
#      "https://docker.mirrors.ustc.edu.cn","https://registry.docker-cn.com"
#   ],
#   "log-driver": "json-file",
#   "log-opts": { "max-size": "100m" },
#   "debug": false,
#   "experimental": true,
#   "storage-driver": "overlay2",
#   "insecure-registries": [],
#   "features": {}
# }
# 重新加载配置
systemctl daemon-reload
# 将当前用户加入到docker组(获取执行docker的权限)
gpasswd -a ${USER} docker && newgrp - docker
gpasswd -a centos docker && newgrp - docker
# 重启docker
systemctl restart docker
# 卸载docker
yum list installed|grep docker
yum remove docker-ce.x86_64 docker-ce-cli.x86_64 containerd.io.x86_64
rm -rf /var/lib/docker /etc/docker ~/.docker

## 安装docker-compose
curl -L https://get.daocloud.io/docker/compose/releases/download/v2.10.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose # 创建快捷方式
~~~

#### 安装Kubernetes
> K8S 版本 v1.19.0 (或安装最新版K8S)
~~~bash
# 安装组件
#yum install -y kubelet kubeadm kubectl  # 最新版K8S
#yum install -y kubelet-1.19.0 kubeadm-1.19.0 kubectl-1.19.0 --disableexcludes=kubernetes [--nogpgcheck] # 或指定版本
yum install -y kubelet-1.20.2 kubeadm-1.20.2 kubectl-1.20.2
#yum install -y kubelet-1.25.0-0 kubeadm-1.25.0-0 kubectl-1.25.0-0
# 关闭防火器(K8S会创建防火器规则,导致防火器规则重复) [应用部署K8S时应该开启防火器]
systemctl disable firewalld && systemctl stop firewalld
# 管理开机启动
systemctl enable kubelet
# 为安装K8S网络前，开启IPv6 [系统默认已开启] (将桥接的IPv4流量传递到K8S的iptables)
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
# 查看开启情况
sysctl --system #生效开启的IPv6
# 为安装K8S网络前，同步时间问题
yum install -y ntpdate
ntpdate time.windows.com
#ntpdate cn.pool.ntp.org
~~~
> K8S 节点初始化 (至少2个以上)
~~~bash
# master 节点初始化1:
kubeadm init --apiserver-advertise-address=192.168.1.201 --image-repository=registry.aliyuncs.com/google_containers --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16
# master 节点初始化失败时, 可通过指定的文件来初始化 kubeadm-init.yaml
kubeadm config print init-defaults > kubeadm-init.yaml
# 修改初始化文件 kubeadm-init.yaml
advertiseAddress: 1.2.3.4 # 改为master虚机IP: 192.168.1.201
imageRepository: k8s.gcr.io # 改为 registry.cn-hangzhou.aliyuncs.com/google_containers
kubernetesVersion: v1.20.2  # 检查版本是否一致并修改
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
  podSubnet: 10.244.0.0/16  # 新增pod子网络flannel
# 摘取镜像, 需提前配置镜像源 /etc/docker/daemon.json
kubeadm config images pull --config kubeadm-init.yaml
# master 节点初始化2:
kubeadm init --config kubeadm-init.yaml
# kubeadm init --config kubeadm-init.yaml --ignore-preflight-errors=Swap
# kubeadm init --apiserver-advertise-address=192.168.1.201 \ # 指定master的IP
# --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers \
# --kubernetes-version=v1.19.0 \    # 指定K8S安装的版本号
# --service-cidr=10.96.0.0/12 \     # 设置flannel网络Svc网段,有默认值时可不指定(可选项)
# --pod-network-cidr=10.244.0.0/16  # 设置flannel网络Pod网段
# 初始化成功后, 为当前用户配置K8S环境(在输出信息中可查看到)
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
# 查看虚机K8S节点信息
kubectl get nodes
# 节点状态NotReady表示未安装网络，接下来开始安装网络calico (需提前开启IPv6)
# 安装集群的flannel网络: 可提前下载文件kube-flannel.yaml
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yaml
# scp -r /etc/cni root@192.168.1.202:/etc
# scp -r /etc/cni root@192.168.1.203:/etc
# scp -r /run/flannel root@192.168.1.202:/run
# scp -r /run/flannel root@192.168.1.203:/run
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
kubectl get nodes
# 初始化:执行后, 其它节点加入集群(在输出信息中可查看到), 提前关闭Swap分区及Selinux
kubeadm token list
kubeadm token create --print-join-command # 在master节点查看其它节点加入集群的命令

# worker 节点初始化 (把工作节点加入集群)
kubeadm join 192.168.1.201:6433 --token a.* --discovery-token-ca-cert-hash sha256:*
# 在worker节点查看运行的容器 kube-proxy,calico-node
docker ps
# 在master节点查看K8S所有节点的详细信息
kubectl get nodes -o wide
# 安装失败后，可重置安装
kubectl reset
kubectl delete node node-123
# 查看安装好的Pods，默认仅查看default命名空间下的Pod
kubectl get pods --all-namespaces -o wide
~~~

#### 应用部署在Kubernetes
~~~bash
# 先开启防火器(K8S初始化成功后,用于部署K8S应用时生成相应的网络访问规则)
systemctl status firewalld  # 检查防火器状态
systemctl enable firewalld && systemctl start firewalld

~~~

