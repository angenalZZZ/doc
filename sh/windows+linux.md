# Windows系统


#### 系统升级

> Windows 10 最新版激活方式，免费升级到20H2 [Download Update Tool](https://go.microsoft.com/fwlink/?LinkId=691209)
~~~bash
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX  # 专业版 or 企业版: 96YNV-9X4RP-2YYKB-RMQH4-6Q72D
slmgr /skms kms.03k.org                   # 修改kms源
slmgr /ato                                # 执行激活
slmgr /upk                                # 卸载密钥(当无法激活时) www.win7zhijia.cn/win10jc
~~~
> Windows 10 Browser [Microsoft Edge](https://www.microsoft.com/zh-cn/edge/business/download)、[Google Chrome](https://www.google.com/intl/zh-CN/chrome/?standalone=1)、[Yandex Browser](https://browser.yandex.com/)

> Windows 10 Microsoft Store
~~~bash
# PowerShell 以管理员方式运行
Get-AppxPackage *store* | Remove-AppxPackage # 删除原来的 Microsoft Store
Get-AppxPackage -AllUsers | Select Name, PackageFullName | Select-String "WindowsStore" # 查询并复制<包名>
Add-AppxPackage -Register "C:\Program Files\WindowsApps\<包全名>\AppxManifest.xml" -DisableDevelopmentMode #安装
~~~
> Windows 10 WSL & Chocolatey & LxRunOffline、[Update to WSL 2](https://docs.microsoft.com/en-au/windows/wsl/install-win10#step-2---update-to-wsl-2)
~~~bash
# PowerShell 以管理员方式运行, 打开 WSL 程序和功能
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# 安装 Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# 安装 LxRunOffline
choco install lxrunoffline
# 获取离线安装包 <system-install.tar.xz> 1.修改[wsl]*.appx后缀为.zip 2.解压得到install.tar.gz 3.安装[执行LxRunOffline]
# LxRunOffline install -n <system-name> -d <system-rootfsdir> -f <system-install.tar.xz> # 复制appx解压目录/启动程序*.exe
PS> LxRunOffline install -n Ubuntu-18.04 -d C:\ubuntu1804 -f .\install.tar.gz # 离线安装Ubuntu-18.04
# LxRunOffline su -n <system-name> -v 1000 # 以指定用户(id=1000)运行(默认为用户root=0)[先进入系统添加用户后再执行该命令]
# 设置 WSL 默认版本为 2 (独立运行<linux>需内存多)
wsl --set-default-version 2 # Update to WSL 2
wsl -l -v                   # 查看<linux>是否为 WSL 2
wsl --set-version <linux> 2 # 修改<linux>为 WSL 2
wsl --set-default <linux>   # 设置<linux>为默认
wsl -u root -d <linux>      # 以指定用户运行(默认为用户root)[先进入系统添加用户后再执行该命令]
~~~
> Windows 10 [WSL - Centos](https://github.com/RoliSoft/WSL-Distribution-Switcher)、[系统设置工具推荐dotfiles](https://github.com/nickjj/dotfiles)
~~~bash
# 部署 centos7 到 WSL (下载Docker镜像) https://github.com/RoliSoft/WSL-Distribution-Switcher
LxRunOffline install -n centos7 -d A:\centos7 -f A:\centos7\centos-7-docker.tar.xz
# 开启 CentOS
LxRunOffline run -n centos7
cat /etc/system-release && cat /usr/lib/os-release # CentOS Linux release 7.9.2009 (Core) 系统完整信息
# 更新软件源[第一步][腾讯云阿里云CVM跳过]
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak # 先备份repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo #获取阿里镜像源
sed -i 's/http:/https:/g' /etc/yum.repos.d/CentOS-Base.repo # 批量替换http为https
yum clean all & yum makecache               # 更新镜像源缓存
# 基础软件安装[第二步]
passwd root                                 # 先设置root账户的密码
useradd -M centos && usermod -L centos      # 然后创建centos普通账户
usermod -d /home/centos centos && usermod -s /bin/bash centos && usermod -aG adm centos # 修改centos的$HOME$SHELL..
groupadd -g 200 app200 && useradd -m -d /var/lib/app200 -s /bin/false -N -g 200 -u 200 -c app200 app200 # 创建用户及组app200
gpasswd -a app200 app200 && newgrp app200   # 添加用户进组app200
cat /etc/passwd |grep app200                # 查看上面创建的用户及组app200
gpasswd -d app200 app200 && userdel app200 && groupdel app200 && rm -rf /var/lib/app200 # 删除用户及组app200
chown -R <name>:<name> /<dir>               # 指定目录<dir>权限给user:<name>
yum install -y curl wget vim ntpdate        # 安装*curl/wget/vim/ntpdate(同步时区)
ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime # 统一时区为上海时区
echo 'Asia/Shanghai' > /etc/timezone        # touch /etc/timezone
ntpdate ntp1.aliyun.com                     # 统一使用(阿里云)服务器进行时间同步
yum install -y gnupg ca-certificates openssl # 安装*gnupg/ca/openssl
yum install -y epel-release                 # 安装*epel软件源
yum install -y gcc-c++ make net-tools       # 安装*gcc/make/net-tools
yum install -y glibc glibc.i686             # 安装*glibc*x86_64,i686
yum install -y GraphicsMagick               # 安装*GraphicsMagick(2D图库)

# 安装数据库 Mysql 8.0 参考 https://dev.mysql.com/doc/refman/8.0/en/linux-installation-yum-repo.html
cd /tmp # 需提前安装依赖 # yum install -y epel-release glibc glibc.i686 gcc-c++ wget net-tools
# sudo wget -O /etc/yum.repos.d/ http://repo.mysql.com/mysql-community-release-el7-7.noarch.rpm #低版本MySQL
wget http://repo.mysql.com/mysql80-community-release-el7.rpm && rpm -ivh mysql80-community-release-el7.rpm
yum install mysql-server # 安装 MySQL 配置如下 https://dev.mysql.com/doc/refman/8.0/en/server-configuration.html
> systemctl start mysqld # 启动 MySQL (如果失败时,参考如下 > D-Bus connection Operation not permitted)
mv /usr/bin/systemctl /usr/bin/systemctl.old
wget -O /usr/bin/systemctl https://github.com/gdraheim/docker-systemctl-replacement/blob/master/files/docker/systemctl.py
chmod +x /usr/bin/systemctl

# 安装 K8S/Kubernetes 容器集群化管理
# 基础软件安装 vim wget ntpdate 然后参考 https://juejin.cn/book/6897616008173846543
# 关闭防火器(K8S会创建防火器规则,导致防火器规则重复)
systemctl stop firewalld & systemctl disabled firewalld
# 关闭Swap分区
swapoff -a       # 临时关闭swap分区
vi /etc/fstab    # 永久关闭swap分区,注释**swap
# 关闭Selinux
setenforce 0     # 临时关闭selinux
vi /etc/sysconfig/selinux
SELINUX=disabled # 永久关闭selinux
# 安装 Docker 容器
groupadd -g 375 docker && newgrp docker # 先创建docker用户组
# 依赖 device-mapper-persistent-data 是linux下的一个存储驱动(一个高级存储技术) lvm 的作用则是创建逻辑磁盘分区
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install docker-ce -y
systemctl start docker   # 手动启动
systemctl enable docker  # 开机启动
docker -v                # 查看版本
start https://cr.console.aliyun.com  # 设置docker 阿里云>容器镜像服务>镜像加速器
vi /etc/docker/daemon.json # 设置镜像库,加速拉取推送images
vi ~/.docker/daemon.json # 当前用户/设置镜像库>>
{
  "registry-mirrors": [
    "https://{your-id}.mirror.aliyuncs.com" // Or: http://{your-id}.m.daocloud.io
  ],
  "insecure-registries": [], // Or: http://[私有库IP]:[私有库Port]
  "debug": false,
  "experimental": true, // Enable实验性功能features:eg. DOCKER_BUILDKIT=1
  "features": {
    "buildkit": true // # syntax = docker/dockerfile:experimental
  }
}
# 加载配置,重启docker
systemctl daemon-reload & systemctl restart docker
# 安装 K8S/Kubernetes 组件
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
# 安装组件，然后启动 kubelet
# kubelet 核心组件。它会运行在集群的所有节点上，并负责创建启动服务容器
# kubectl 命令行工具。它用来管理，删除，创建资源
# kubeadm 用来初始化集群，管理子节点加入的工具
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet
# 安装 Master 节点
hostnamectl set-hostname master # 修改主机名
vi /etc/hosts # 通过 ip addr 命令，获取本机IP，将其添加到 /etc/hosts
# xxx.xxx.xxx.xxx master
# 配置 Kubernetes 初始化文件
kubeadm config print init-defaults > init-kubeadm.conf # 取得默认配置文件
vim init-kubeadm.conf  # 修改配置文件>>
# imageRepository: k8s.gcr.io # 更换k8s镜像仓库
imageRepository: registry.cn-hangzhou.aliyuncs.com/google_containers
# localAPIEndpointc/advertiseAddress改为master的IP, port默认不修改
localAPIEndpoint:
  advertiseAddress: 192.168.56.101  # master的IP
  bindPort: 6443
# 配置子网络 pod 网络为 flannel 网段
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
  podSubnet: 10.244.0.0/16	# 添加子网络
# 修改完配置文件后, 执行命令拉取默认组件镜像
kubeadm config images pull --config init-kubeadm.conf
# 在镜像拉取后, 初始化 Kubernetes
kubeadm init --config init-kubeadm.conf
# 在 Master 节点, 执行初始化命令
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# 在 node 节点, 执行初始化命令, 加入到 Master 集群
kubeadm join 172.16.81.164:6443 --token abcdef.0123456789abcdef \
 --discovery-token-ca-cert-hash sha256:******
# 安装 Flannel 组件，创建一个虚拟网络，让不同节点的服务有全局唯一的IP地址 (先下载配置文件)
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
docker pull quay.io/coreos/flannel:v0.13.0-rc2 # 拉取 flannel 镜像
kubectl apply -f kube-flannel.yml  # 使用 kubectl apply 命令加载服务
kubectl get nodes  # 查看启动情况
# 安装 Node 节点
hostnamectl set-hostname node1 # 修改主机名
scp $HOME/.kube/config root@nodeIP:~/ # 拷贝 Master 节点配置文件
mkdir -p $HOME/.kube
sudo mv $HOME/config $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# 把 Node 节点, 加入 Master 节点
kubeadm join 172.16.81.164:6443 --token abcdef.0123456789abcdef \
 --discovery-token-ca-cert-hash sha256:******
# kubeadm token create --print-join-command # 在 master 机器上, 重新生成加入命令
# 安装 Flannel 组件，同上。


# 安装 Jenkins 实现自动化构建
yum install -y java
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins
gpasswd -a jenkins docker && newgrp docker # 添加用户jenkins进入组docker
service jenkins start
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=50000/tcp --permanent
systemctl reload firewalld
# 访问网页 http://localhost:8080/
cat /var/lib/jenkins/secrets/initialAdminPassword # 获取初始密码
# 替换安装源后，再安装推荐的插件
sed -i 's/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' /var/lib/jenkins/updates/default.json
sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' /var/lib/jenkins/updates/default.json

~~~
> Windows 10 [WSL - Ubuntu](https://www.microsoft.com/zh-cn/p/ubuntu-1804-lts/9n9tngvndl3q?activetab=pivot:overviewtab)、[Ubuntu开发环境及常用安装](https://github.com/angenalZZZ/doc/blob/master/cmd_bash_shell.md#linux开发环境及常用安装)
~~~bash
# PowerShell 以管理员方式运行, 安装WSL Ubuntu
Get-AppxPackage -AllUsers | Select Name, PackageFullName | Select-String "Ubuntu" # 查询并复制<包名>
Get-AppxPackage CanonicalGroupLimited.UbuntuonWindows | Remove-AppxPackage # 卸载
# curl.exe -L -o ubuntu-1804.appx https://aka.ms/wslubuntu1804 # 下载
curl.exe -L -o ubuntu-2004.appx https://aka.ms/wslubuntu2004 # 下载
Add-AppxPackage .\ubuntu-2004.appx # 离线安装WSL Ubuntu 20.04 至指定路径
$ cat /etc/os-release  # 查看系统详细信息
$ sudo apt-get update && sudo apt-get dist-upgrade # 更新apt软件管理工具
$ sudo apt-get clean && sudo apt-get update --fix-missing
# 设置root账户密码[第一步]
$ sudo passwd root                          # 改root密码
useradd -M ubuntu && usermod -L ubuntu      # 创建ubuntu
usermod -d /home/ubuntu ubuntu && usermod -s /bin/bash ubuntu && usermod -aG adm ubuntu #目录$HOME+命令$SHELL+添加用户组
useradd -m -d /home/admin -G adm,sudo,dip,plugdev -s /bin/bash admin && groups admin # 创建admin+查看用户组groups
useradd -D -s /bin/zsh # 修改默认命令$SHELL [ -D = cat /etc/default/useradd ]
chown -R <name>:<name> /<dir>  # 指定目录<dir>权限为user创建: chown -R admin:admin /home/admin
su - root # 切换回root (su输入指定用户的密码;sudo输入当前用户密码)
man newusers    # 批量更新和创建新用户
userdel -r test # 删除用户
cat /etc/passwd # 查看所有用户 ; 统计用户数 cat /etc/passwd | wc -l
cat /etc/passwd |grep `id -un` # 查看当前登录用户
cat /etc/shadow # 用户列表
cat /etc/group  # 用户组列表
groups          # 用户所在组 > groups ubuntu
groupadd        # 添加用户组 > groupadd ubuntu
groupdel        # 删除用户组 > groupdel ubuntu
passwd admin    # 修改密码
login           # 用户登录
whoami && w && id # 当前用户信息及id
id            # 返回 uid=0(root) gid=0(root) groups=0(root)  ; root登录:  su root ; su - ;目录不变
id -u         # 返回 uid 添加用户(-d=$home) (-G=附加用户组) 例如(用户名=admin)
echo -e "$USER\n$HOME\n$SHELL\n$PATH\n$LOGNAME\n$MAIL" # 当前用户环境 [-e允许反斜杠转义字符]
# 修改用户多选组-G=groups   # 查用户组${id -g 用户名} $ groups yangzhou
id -gn && id -Gn         # 返回用户组: sudo grep $USER /etc/group /etc/gshadow
usermod -G yangzhou,adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare,docker,mysql,mongodb,libvirt,rabbitmq yangzhou
usermod -aG adm,cdrom,sudo,dip,plugdev,mongodb,ubuntu ubuntu
usermod -aG rabbitmq yangzhou # 添加组给用户,提供组操作权限.
# 查询用户更多信息
sudo grep $USER /etc/passwd /etc/shadow /etc/group /etc/gshadow
su - root      # 切换用户至root (并切换到用户主目录/root；超级用户提示符结尾 # 普通用户$ 主目录/home/*)
su - admin     # 切换用户至admin
exit           # 退出登录

# 更新软件源[第二步][腾讯云阿里云CVM跳过]
$ sudo vi /etc/apt/sources.list    # ubuntu`18.04``bionic` 腾讯云源 (esc-vi按 :wq! 保存)
deb http://mirrors.tencentyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.tencentyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.tencentyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.tencentyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.tencentyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.tencentyun.com/ubuntu/ bionic-updates main restricted universe multiverse
#deb http://mirrors.tencentyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
#deb-src http://mirrors.tencentyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
#deb http://mirrors.tencentyun.com/ubuntu/ bionic-backports main restricted universe multiverse
#deb-src http://mirrors.tencentyun.com/ubuntu/ bionic-backports main restricted universe multiverse
$ sudo vi /etc/apt/sources.list    # ubuntu`20.04``focal` 阿里云源 (esc-vi按 :wq! 保存)
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
#deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
#deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
sudo apt-get update && sudo apt-get upgrade # 更新软件源-操作完毕!

# 安装开发环境
sudo apt install -y gnupg libfreetype6-dev language-pack-zh-hans # 安装freetype/中文语言包
sudo apt install -y apt-transport-https ca-certificates x509-util # 安装ca/https/X.509
sudo apt install -y acmetool lecm # 安装 Let's Encrypt Certificate 自动化证书获取工具/管理工具
sudo apt install -y --no-install-recommends git curl wget libssl-dev # 安装git/curl/wget/ssl-toolkit
sudo apt install -y --no-install-recommends openssl ssl-cert tcl-tls # 安装openssl/tls
sudo apt install -y --no-install-recommends openssh-server openvpn # 安装SSH/openvpn
sudo apt install -y build-essential graphicsmagick  # 安装gcc/g++/gdb/make工具链/graphics库
sudo apt install clang cmake zlib1g-dev libboost-dev libboost-thread-dev  # 安装clang/cmake/boost工具链
sudo apt install cmake cmake-data cmake-doc cmake-curses-gui cmake-qt-gui # 安装ccmake/qt-gui桌面开发
sudo apt install autoconf automake pkg-config libtool gnome-core  # 安装automake/glib/gnome桌面开发
sudo apt-get install libgtk-3-dev libcairo2-dev libglib2.0-dev --fix-missing   # 安装桌面开发gtk3工具链
sudo apt-get install libwebkit2gtk-4.0-dev javascriptcoregtk-3.0 --fix-missing # 安装桌面开发webkit2gtk

# 安装K8s集成到WSL(需修改<linux>为 WSL 2) Ubuntu20.04 参考 https://blog.csdn.net/weixin_43168190/article/details/107179715

# 安装 Java 语言
sudo add-apt-repository universe                   # 安装java运行时(当报错提示无法下载时需启用universe)
sudo apt-get update && sudo apt-get upgrade        # 安装java运行时之前
sudo apt-get install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen # 最小化安装jre-8(推荐)
sudo apt-get clean && apt-get update --fix-missing
sudo apt install -y --fix-missing default-jre      # 安装jre > java -version  (安装java选项1)
sudo apt install -y --fix-missing default-jdk      # 安装jdk > java -version  (安装java选项2)
sudo apt install -y --fix-missing openjdk-8-jdk    # 安装OpenJDK              (安装java选项3)
sudo ln -s /usr/bin/java /usr/local/bin/java       # 创建快捷方式
sudo add-apt-repository ppa:webupd8team/java && sudo apt-get update
sudo apt-get install oracle-java8-installer   # 在线安装, 离线下载 download.oracle.com/otn/java/jdk
sudo apt-get install oracle-java8-set-default # 使用默认版本jdk1.8
sudo update-alternatives –config java         # 多版本JDK之间切换

# 安装 .NET Core 语言
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install dotnet-runtime-3.1 aspnetcore-runtime-3.1  # 仅安装 .NET Core Runtime
sudo apt-get install dotnet-sdk-3.1                # 安装 .NET Core SDK  > dotnet -h

# 安装 R 语言(用于统计计算) > /usr/bin/R --help # 大写R
sudo apt-get -y install r-recommended --fix-broken 

# 安装 erlang 语言
sudo apt install -f libncurses5-dev freeglut3-dev fop m4 tk unixodbc unixodbc-dev xsltproc socat 
wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.1-1~ubuntu~xenial_amd64.deb
sudo dpkg -i esl-erlang_22.1-1~ubuntu~xenial_amd64.deb # 安装 erlang 语言(支持CSP消息模型的并发编程语言)

# 安装 Python 语言 (python3为默认终端)
sudo apt install python-minimal build-essential # 安装Python及gcc/g++/gdb/make工具链
sudo apt-get install python-dev python-pip      # 安装python2和pip or(仅运行环境) install python2-minimal
sudo apt-get install python3-dev python3-pip    # 安装适用于python3的pip
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150
sudo update-alternatives --config python  # 手动配置/切换版本: python --version ; pip --version
sudo ln -sf /usr/bin/python2.7 /usr/bin/python # 将Python2(恢复)默认
python3 --version && pip3 --version  # 检查版本
pip3 install -U pip  # 更新python3的pip版本
pip3 install ipython

# 安装 Apache & PHP 环境
sudo add-apt-repository ppa:ondrej/php && sudo apt-get update # 安装php (PPA源)
sudo apt install -y php7.2-fpm php7.2-mysql php7.2-curl php7.2-gd php7.2-mbstring php7.2-xml php7.2-xmlrpc php7.2-zip php7.2-opcache
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.2/fpm/php.ini # 设置php 替换 ;cgi.fix_pathinfo=1 为 cgi.fix_pathinfo=0
sudo systemctl restart php7.2-fpm  # 重启php
sudo systemctl status php7.2-fpm   # 检查php状态
sudo apt-get -y install apache2    # 安装apache2
sudo apt-get -y install libapache2-mod-php7.2  # 让apache识别php
#-config>>  /etc/apache2/apache2.conf, ports.conf, sites-enabled/000-default.conf 等配置文件处理
sudo systemctl [status|restart] apache2  # 然后检查|重启apache2
sudo /etc/init.d/apache2 [status|restart] 

# 安装 Nginx
sudo apt install nginx        # 安装Nginx
sudo systemctl status nginx   # 检查状态
sudo ufw allow 'Nginx Full'   # 配置防火墙
sudo ufw status               # 验证更改
sudo systemctl restart nginx  # 重启Nginx服务
sudo systemctl disable nginx  # 禁止开机启动
sudo systemctl reload nginx   # 修改配置后，需要重新加载Nginx服务
ls /etc/nginx/sites-available # 设置Nginx服务器模块(类似Apache虚拟主机) www.linuxidc.com/Linux/2018-05/152258.htm
sudo apt install certbot      # 使用Let's Encrypt保护Nginx  www.linuxidc.com/Linux/2018-05/152259.htm
runuser -l yangzhou -s /bin/sh -m -c "/usr/local/nginx/sbin/nginx" # 启动(可用 su+目标用户的密码; sudo+自己的密码)
sudo rm /etc/nginx/sites-enabled/default # 删除默认网站,新创建一个如下:
> vi /etc/nginx/sites-available/mysite.conf
server {
    listen 80;
    server_name example.com;
    location / {
        proxy_pass http://localhost:3000/;
    }
}
sudo ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/
sudo nginx -t        # 测试配置是否有误
sudo nginx -s reload # 重新加载nginx配置
sudo apt-get install -y software-properties-common # 配置 SSL 证书
sudo add-apt-repository ppa:certbot/certbot # 安装 Certbot 
sudo apt-get update
sudo apt-get install -y python-certbot-nginx # 位置选择 亚洲（也就是 6. Asia） 时区选择 69. Shanghai
sudo certbot --nginx # 填写和你注册域名时相同的邮箱
sudo certbot renew --dry-run # 开启证书自动续约(有效期是3个月)

# 安装 OpenResty
sudo systemctl disable nginx && sudo systemctl stop nginx # 安装OpenResty > cd /tmp
sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates software-properties-common
wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -  # 导入GPG密钥
sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" # 添加官方APT仓库
sudo apt-get update  # 更新APT索引
sudo apt-get -y install openresty # 安装OpenResty 参考 openresty.org/cn/linux-packages.html
sudo apt-get -y install --no-install-recommends openresty # 最小化安装,不装推荐的openresty-opm,openresty-restydoc
#-config>>  /usr/local/openresty/nginx/conf/nginx.conf
sudo systemctl restart openresty  # 重启; 开始HelloWorld  openresty.org/cn/getting-started.html

# 安装 Nodejs 语言
sudo apt install nodejs           # 安装Nodejs(此安装方式版本太低; 推荐wget安装方式-如下)
#wget -O node-linux-x64.tar.gz https://npm.taobao.org/mirrors/node/v12.16.3/node-v12.16.3-linux-x64.tar.gz
wget -O node-linux-x64.tar.gz https://npm.taobao.org/mirrors/node/v12.18.4/node-v12.18.4-linux-x64.tar.gz
sudo tar -zxf node-linux-x64.tar.gz -C /usr/local/ # 解压目录
sudo mv /usr/local/node-v12.18.4-linux-x64 /usr/local/node # 重命名目录
sudo chown -R `id -un`:`id -gn` /usr/local/node            # 设置目录权限
sudo ln -sf /usr/local/node/bin/node /usr/local/bin/node   # 设置软链接,如下
sudo ln -sf /usr/local/node/bin/npm /usr/local/bin/npm
sudo ln -sf /usr/local/node/bin/npx /usr/local/bin/npx
export PATH=/usr/local/node/bin:$PATH # 配置环境变量/etc/profile.d/01-locale-profile.sh(推荐替代软链接)
npm config ls -l
npm i -g inherits n
sudo chown -R `id -un`:`id -gn` /usr/local/n
n 12.18.4 # 安装指定node版本v12.18.4
npm i -g yarn # 工具yarn 及 node-gyp, node-sass...
npm i -g node-gyp node-pre-gyp node-sass --registry=https://registry.npm.taobao.org
yarn global add cnpm --registry=https://registry.npm.taobao.org # 工具cnpm 配置nodejs完成

# 安装 chrome driver
su - root
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install unzip
DL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
curl -sL "$DL" > /tmp/chrome.deb
apt install --no-install-recommends --no-install-suggests -y /tmp/chrome.deb
CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage'
sed -i '${s/$/'" $CHROMIUM_FLAGS"'/}' /opt/google/chrome/google-chrome
BASE_URL=https://chromedriver.storage.googleapis.com
VERSION=$(curl -sL "$BASE_URL/LATEST_RELEASE")
curl -sL "$BASE_URL/$VERSION/chromedriver_linux64.zip" -o /tmp/driver.zip
unzip /tmp/driver.zip
chmod 755 chromedriver
mv chromedriver /usr/local/bin

# 安装 chromium and puppeteer  https://crbug.com/795759
sudo apt-get install -yq libgconf-2-4 
# Install latest chrome dev package and fonts to support major 
# charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer installs, work.
sudo apt-get update \
  && apt-get install -y wget gnupg \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get -y install xvfb gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
    libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
    libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
    libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
    libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget \
  && rm -rf /var/lib/apt/lists/* 
# install default dependencies for puppeteer
PUPPETEER_DOWNLOAD_HOST=https://npm.taobao.org/mirrors
npm config set puppeteer_download_host=https://npm.taobao.org/mirrors
npm install puppeteer-chromium-resolver crawlab-sdk -g --unsafe-perm=true --registry=https://registry.npm.taobao.org


# 微服务 - 消息中间件 - 跨语言LGPLed - 通信方案
#0、gRPC通讯协议: grpc.io/docs/ 谷歌开源 HTTP/2 传输更快 http2.golang.org
#1、Thrift通讯协议: thrift.apache.org  一个远程过程调用（RPC）框架，由Facebook为大规模跨语言服务而开发。
#  1.安装环境：Thrift是一种接口描述语言和二进制通讯协议，它被用来定义和创建跨语言的服务。
$ sudo apt-get -y install automake bison flex g++ git libboost-all-dev libevent-dev libssl-dev libtool make pkg-config
#  2.从源代码构建：http://thrift.apache.org/docs/BuildingFromSource
#  2.1下载源码 http://thrift.apache.org/download  #!src: git clone https://github.com/apache/thrift.git
$ ./bootstrap.sh && ./configure --without-go --without-java --without-nodejs --without-nodets --without-swift
$ make && make install
#2、NATS高性能通讯、消息中间件: docs.nats.io 远程过程调用（RPC）通讯框架
> nssm install nats-server %GOPATH%\bin\nats\nats-server.exe --auth=HGJ766GR767FKJU0  #安装Windows服务
> sc create nats-server binPath= "%GOPATH%\bin\nats\nats-server.exe -a=0.0.0.0 -p=4222 --auth=HGJ766GR767FKJU0"
> sc start nats-server  # 启动服务
> nats-server.exe --signal reload|reopen|stop # reload加载配置|reopen重新打开日志文件以进行日志轮换|stop停止服务器
> nats-top [-s server] [-m monitor] [-n num_conns=1024] [-d delay_secs=1] [-sort by=subs|msgs_to|bytes_to|msgs_from|bytes_from]
#3、ZeroMQ 跨语言LGPLed方案: zeromq.org 特点:Universal、Smart、High-speed、Multi-Transport、Community、The Guide
$ sudo apt-get install libzmq3-dev # 安装ZeroMQ3
$ pkg-config --modversion libzmq   # 检查模块版本
#4、Nanomsg 跨语言通信 nanomsg.org 具备IPC,TCP,WS通信方式 Req/Rep,Pub/Sub,Pair,Bus,Push/Pull,Surveyor/Respondent
> go get -v -u go.nanomsg.org/mangos && cd %GOPATH%/src/go.nanomsg.org/mangos # 下载源码 
> go test -bench=. go.nanomsg.org/mangos/v3/test  # 单机性能-压力检测- IPC: ^5千万/Qps + 传输^1GB/s 
$ git clone --depth=1 https://github.com/nanomsg/nanomsg.git # 准备安装Linux 
$ mkdir build && cd build && cmake .. && cmake --build . && sudo cmake --build . --target install && sudo ldconfig # on Linux
# 1.open CMake-gui 2.set src-dir,build-dir 3.set CMAKE_INSTALL_PREFIX=D:/Program/nanomsg # Select: MinGW Makefiles
# 3.1set NN_STATIC_LIB=ON, NN_TOOLS=ON, others OFF, then click Configure, Generate.  # on windows build for static lib
# 3.2set NN_STATIC_LIB=OFF, NN_TOOLS=ON, others OFF, then click Configure, Generate. # on windows build for ddl
> cd build-dir && cmake --build . --target install # to build after 3.1 and 3.2 #or if CMAKE_AR=MSVC [--config Release]
# set PKG_CONFIG_PATH=D:\Program\mingw64\lib\pkgconfig && set NN_STATIC_LIB=D:\Program\nanomsg\lib # set windows-env/nanomsg.pc
# cp lib/pkgconfig/*.pc %PKG_CONFIG_PATH% && cp lib/*.a /mingw64/lib && cp *.h /mingw64/include/nanomsg # set gcc lib env
$ git clone --depth=1 https://github.com/nanomsg/nng.git # Nanomsg下一代通信"Scalablilty Protocols"
$ mkdir build && cd build && cmake -G Ninja .. && ninja && ninja install # on Linux or windows, use Ninja build
> nngcat --rep --bind=ipc://host1 --insecure --silent --compat --count=0 --format=raw --data=<reponse> # 响应输出
> nngcat --req --connect=ipc://host1 --raw --data=<request-payload> # 请求输入
#5、D-Bus 应用程序间通信的消息总线系统, 用于进程之间的通信。
$ sudo apt-get install dbus  # 安装D-Bus,然后启动dbus-launch
# dbus-daemon --session --print-address --nofork --print-pid # 启动普通进程
# dbus-daemon --session --print-address --fork --print-pid   # 启动后台进程
# dbus-daemon --session --print-address --fork --print-pid --address=unix:abstract=/tmp/dbus-FixedAddress # 指定监听地址
# dbus-daemon --system --print-address --fork --print-pid    # 启动守护进程


# 安装ffmpeg视频编码/解码libraries: avcodec,avformat,avutil,avfilter,avdevice,swresample,swscale
sudo apt-get -y install autoconf automake build-essential  # 先安装gcc/g++/gdb/make工具链
sudo apt-get -y install libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev \
  libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev \
  libavdevice-dev libavfilter-dev libswscale-dev libavcodec-dev libavformat-dev libswresample-dev libavutil-dev
sudo apt-get install yasm


# 安装Mongodb 4.0 on Ubuntu
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] http://mirrors.aliyun.com/mongodb/apt/ubuntu bionic/mongodb-org/4.0 multiverse" \
#echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" \
  | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get -y update
sudo apt-get -y install mongodb-org
sudo service mongod start
ps aux | grep mongod
# 安装Mongodb 4.4 on Ubuntu
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add - # Add MongoDB GPG signing key
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" \
  | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list  # Add MongoDB repository
sudo apt-get -y update
sudo apt-get -y install mongodb-org
sudo sed -i "s/^#  engine:/  engine: mmapv1/"  /etc/mongod.conf 
sudo sed -i "s/^#replication:/replication:\n  replSetName: rs01/" /etc/mongod.conf
sudo systemctl enable mongod && sudo systemctl start mongod # 开机启动 MongoDB service
usermod -aG adm,bin,ftp ubuntu # 给用户ubuntu添加角色
su - ubuntu && id -gn && id -Gn # 切换用户ubuntu检查角色
mongo --eval "printjson(rs.initiate())" # Test MongoDB service status(不要用root)


##聊天平台[Rocket.Chat] https://docs.rocket.chat/ 
# [Manual-Install All OS] docs.rocket.chat/installation/manual-installation
# [Ubuntu 18.04, 19.04, 20.04] docs.rocket.chat/installation/manual-installation/ubuntu
# [Rocket.Chat on Ubuntu Doc] computingforgeeks.com/install-rocket-chat-on-ubuntu-with-letsencrypt
sudo apt-get -y update # Update your Ubuntu
# Install gcc/make/graphicsmagick, Node.js[参考上面的`安装 Nodejs 语言`]
sudo apt-get install -y build-essential graphicsmagick 
curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz # Download Rocket.Chat
tar -xzf /tmp/rocket.chat.tgz -C /tmp
cd /tmp/bundle/programs/server && npm install # 参考 npm配置与nodejs推荐安装.md
sudo mv /tmp/bundle /opt/Rocket.Chat
sudo useradd -M rocketchat && sudo usermod -L rocketchat # Create Rocketchat system user
sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat
 ## Start Create Rocket.Chat service
cat << EOF |sudo tee /etc/systemd/system/rocketchat.service
[Unit]
Description=The Rocket.Chat server
After=network.target remote-fs.target nss-lookup.target nginx.target mongod.target
[Service]
ExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=rocketchat
User=rocketchat
Environment=MONGO_URL=mongodb://localhost:27017/rocketchat?replicaSet=rs01 MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01 ROOT_URL=http://localhost:3000/ PORT=3000
[Install]
WantedBy=multi-user.target
EOF
 ## End Create Rocket.Chat service, and Configure the storage engine and replication for MongoDB

sudo systemctl enable rocketchat && sudo systemctl start rocketchat # Start Rocket.Chat service
sudo systemctl status rocketchat # Check if the service is running

 ## Configure Nginx Reverse Proxy
sudo apt install nginx
sudo nano /etc/nginx/conf.d/rocketchat.conf

upstream rocket_backend {
  server 127.0.0.1:3000;
}

server {
    listen 80;
    server_name chat.hirebestengineers.com;
    access_log /var/log/nginx/rocketchat-access.log;
    error_log /var/log/nginx/rocketchat-error.log;

    location / {
        proxy_pass http://rocket_backend/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}

sudo nginx -t  # Check if Nginx configuration is ok
sudo systemctl restart nginx
sudo systemctl enable nginx

 ## Setup Let’s Encrypt SSL
sudo apt install certbot python3-certbot-nginx
certbot --nginx  # Then run certbot to acquire SSL certificate

upstream rocket_backend {
  server 127.0.0.1:3000;
}

server {
    server_name chat.hirebestengineers.com;
    access_log /var/log/nginx/rocketchat-access.log;
    error_log /var/log/nginx/rocketchat-error.log;

    location / {
        proxy_pass http://rocket_backend/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/chat.hirebestengineers.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/chat.hirebestengineers.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

server {
    if ($host = chat.hirebestengineers.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name chat.hirebestengineers.com;
    return 404; # managed by Certbot
}

sudo nginx -t  # Check if Nginx configuration is ok
sudo systemctl restart nginx # Restart Nginx service

##聊天平台[Rocket.Chat] on CentOS-7: docs.rocket.chat/installation/manual-installation/centos
cat /etc/system-release && cat /usr/lib/os-release # CentOS Linux release 7.9.2009 (Core) 系统完整信息
passwd root                                 # 设置root账户的密码
useradd -M rocketchat && usermod -L rocketchat # 添加账户rocketchat (切换当前用户 su - rocketchat)
mkdir -p /home/rocketchat && cd /home/rocketchat && chmod rocketchat:rocketchat /home/rocketchat
yum install -y gnupg ca-certificates curl wget openssl # 安装ca/wget/openssl
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak # 先备份repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo #获取阿里镜像源
sed -i 's/http:/https:/g' /etc/yum.repos.d/CentOS-Base.repo # 批量替换http为https
yum clean all & yum makecache               # 更新镜像源缓存
yum install -y epel-release                 # 安装epel软件源
yum install -y gcc-c++ make net-tools       # 安装gcc/make/net-tools
yum install -y glibc glibc.i686             # 安装glibc*x86_64,i686
yum install -y GraphicsMagick
wget -O node-linux-x64.tar.gz https://npm.taobao.org/mirrors/node/v12.18.4/node-v12.18.4-linux-x64.tar.gz
sudo tar -zxf node-linux-x64.tar.gz -C /usr/local/         # 解压目录
sudo mv /usr/local/node-v12.18.4-linux-x64 /usr/local/node # 重命名安装目录
sudo chown -R `id -un`:`id -gn` /usr/local/node            # 设置目录权限
export PATH=/usr/local/node/bin:$PATH # 环境配置(推荐)[参考下面的`环境变量`]
npm config ls -l
npm i -g inherits n
sudo chown -R `id -un`:`id -gn` /usr/local/n
n 12.18.4 # 安装指定node版本v12.18.4
npm i -g yarn # 工具yarn 及 node-gyp, node-sass...
npm i -g node-gyp node-pre-gyp node-sass --registry=https://registry.npm.taobao.org
yarn global add cnpm --registry=https://registry.npm.taobao.org # 工具cnpm 配置nodejs完成;开始安装mongodb
cat << EOF | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
EOF
cd /tmp
yum install -y mongodb-org # 安装mongodb
wget -O /tmp/rocket.chat.tgz https://releases.rocket.chat/latest/download # 下载最新版Rocket.Chat
tar -xzf /tmp/rocket.chat.tgz -C /tmp # 下面开始构建
cd /tmp/bundle/programs/server
npm install --proxy=http://localhost:10810 --unsafe-perm=true --allow-root # 构建Rocket.Chat(需科学上网)
mv /tmp/bundle /opt/Rocket.Chat  # 构建成功后,移动为安装目录
chown -R rocketchat:rocketchat /opt/Rocket.Chat  # 授权后,备份安装目录 rocket.chat.installed.tgz
cat << EOF |sudo tee -a /lib/systemd/system/rocketchat.service
[Unit]
Description=The Rocket.Chat server
After=network.target remote-fs.target nss-lookup.target nginx.service mongod.service
[Service]
ExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=rocketchat
User=rocketchat
Environment=MONGO_URL=mongodb://localhost:27017/rocketchat?replicaSet=rs01 MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01 ROOT_URL=http://localhost:3000/ PORT=3000
[Install]
WantedBy=multi-user.target
EOF
> vi /etc/mongod.conf # 启动 MongoDB 前
sed -i "s/^#  engine:/  engine: mmapv1/" /etc/mongod.conf
sed -i "s/^#replication:/replication:\n  replSetName: rs01/" /etc/mongod.conf
mkdir -p /var/run/mongodb && chown mongod:mongod /var/run/mongodb && chmod 0755 /var/run/mongodb
chown -R mongod:mongod /var/lib/mongo /var/log/mongodb
systemctl status mongod && systemctl enable mongod && systemctl start mongod
mongo --eval "printjson(rs.initiate())"
systemctl status rocketchat && systemctl enable rocketchat && systemctl start rocketchat
# ZLIB version problem ! not found 系统兼容问题
> vi /usr/lib/systemd/system/rocketchat.service # 添加运行时环境变量LD_PRELOAD
Environment=LD_PRELOAD=/opt/Rocket.Chat/programs/server/npm/node_modules/sharp/vendor/lib/libz.so
# 防火墙 https://docs.rocket.chat/installation/manual-installation/optional-configurations
# 反向代理 https://docs.rocket.chat/installation/manual-installation/configuring-ssl-reverse-proxy
# 访问 ROOT_URL http://localhost:3000/


# MySQL 安装 参考 https://dev.mysql.com/doc/refman/8.0/en/linux-installation.html
sudo apt-get install mysql-server
sudo apt-get isntall mysql-client
sudo apt-get install libmysqlclient-dev
sudo pip3 install PyMySQL          # 使用python操作MySQL

# MySQL 配置
mysql -u root                      # 重置密码前，首先无密码登录
# sudo chown -R `id -un`:`id -gn` /usr/lib/mysql # 设置目录权限(当上面mysql登录执行失败时)
mysql>                             # 连接进入mysql命令行界面
set password =password('密码');
flush privileges;                  # 刷新系统权限表, 或重启mysql服务 service MySQL restart
mysql -uroot -p                    # 输入密码(-p)
mysql> use mysql;
mysql> update user set password =password('密码') where user='root';
mysql> GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY 'root'; #授权外网通过root登录
show variables like '%char%';
set names utf8; # set names utf8mb4 # 设置编码
# 远程连接-开放端口3306（centos-7）
# firewall-cmd --zone=public --add-port=3306/tcp --permanent
# firewall-cmd --reload
# 远程连接-出现警告时
# vi /etc/my.cnf << EOF -参考- http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html
[client]
port = 3306
socket = /var/lib/mysql/mysql.sock
default-character-set = utf8mb4
host = localhost
user = root
password = root
... ...
init-connect = 'SET NAMES utf8mb4'
character-set-server = utf8mb4
# EOF


# 环境变量: https://github.com/angenalZZZ/doc/blob/master/sh/01-locale-profile.sh
##进行软链结: ln -s /git/doc/sh/01-locale-profile.sh /etc/profile.d/01-locale-profile.sh
> vi /etc/profile.d/01-locale-profile.sh
# path 系统目录;SHELL搜索目录;
# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# local time
export TZ='Asia/Shanghai'
##开发环境设置
# go
export GO111MODULE=auto
export GOSUMDB=sum.golang.google.cn
export GOPROXY=https://goproxy.io
export GOPATH=/a/go
export GOROOT=/usr/local/go
export GOTOOLS=$GOROOT/pkg/tool
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
# java 开发环境;java,javaw,javaws,jdb,jps,jrunscript,keytool等
export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre
# export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
# export JAVA_HOME=/usr/local/java/jdk1.8.0_221  # 安装指定版本时
export JAVA_BIN=$JAVA_HOME/bin
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export JAVA_VERSION=8u212   # 指定版本
export SCALA_VERSION=2.12   # 指定版本
export GLIBC_VERSION=2.29-r0
# nodejs
export PATH=/usr/local/node/bin:$PATH
# docker
export DOCKER_HOST=tcp://127.0.0.1:2375
# eval $(docker-machine env default)
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://127.0.0.1:2376"
export DOCKER_CERT_PATH="/home/yangzhou/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# ffmpeg 视频编码/解码/开发环境
export FFMPEG_ROOT=$HOME/ffmpeg
export CGO_LDFLAGS="-L$FFMPEG_ROOT/lib/ -lavcodec -lavformat -lavutil -lswscale -lswresample -lavdevice -lavfilter"
export CGO_CFLAGS="-I$FFMPEG_ROOT/include"
export LD_LIBRARY_PATH=$HOME/ffmpeg/lib
##使以上配置立即生效
> source /etc/profile

# 点播/直播/视频转码
# go get -u github.com/giorgisio/goav  # 提供开发 go sdk
# https://github.com/shimberger/gohls  # 提供点播 gohls -h ?目录中自动转码> HTTP Live Streaming (HLS)
# https://github.com/MattMcManis/Axiom # 提供视频转码/格式转换 c# gui windows

# 快捷命令: https://github.com/angenalZZZ/doc/blob/master/sh/02-bash_aliases.sh
alias lht='ls -lht'  # 文件列表-按时间倒序
alias lhs='ls -lhS'  # 文件列表-按大小倒序
alias start-pg='sudo service postgresql start'
alias run-pg='sudo -u postgres psql'

~~~
> Windows 后台服务管理工具
  - `sc create <服务名> start= auto binPath= "可执行命令行"`
  - `nssm`>[`download`](https://nssm.cc/download)>[`commands`](https://nssm.cc/commands)
~~~cmd
:: installation
nssm install <servicename>
nssm install <servicename> <program>
nssm install <servicename> <program> [<arguments>]
:: installation options
nssm set <servicename> AppDirectory <path>
nssm set <servicename> Description <description>
nssm set <servicename> DependOnService "Remote Procedure Call (RPC)" LanmanWorkstation
nssm set <servicename> Start SERVICE_AUTO_START|SERVICE_DELAYED_START|SERVICE_DEMAND_START|SERVICE_DISABLED
:: installation options - system environment variable
nssm get <servicename> AppEnvironmentExtra
nssm set <servicename> AppEnvironmentExtra CLASSPATH=C:\Classes TEMP=C:\Temp
:: installation options - specifying the user which will run the service
nssm get <servicename> ObjectName
nssm set <servicename> ObjectName <username> <password>
:: management services
nssm start|stop|restart|pause|continue|status <servicename>
:: uninstall
nssm remove <servicename>

# ipfs init # https://docs.ipfs.io/how-to/command-line-quick-start/
# ipfs config Addresses.API /ip4/127.0.0.1/tcp/5001
# ipfs config Addresses.Gateway /ip4/127.0.0.1/tcp/5401
> sc create ipfs start= auto binPath= "A:\go\bin\ipfs.exe daemon" # 安装Windows服务
> nssm install Crawlab bash.exe -c GIN_MODE=release /mnt/a/go/bin/crawlab/backend/crawlab # 安装Windows服务
> nssm install MinIO C:/minio/minio.exe server ./data # 安装Windows服务[以管理员身份运行] # nssm get MinIO AppEnvironmentExtra
> nssm set MinIO AppDirectory C:/minio                # 设置/工作目录AppDirectory /环境变量AppEnvironmentExtra
> nssm set MinIO AppEnvironmentExtra MINIO_ACCESS_KEY=admin MINIO_SECRET_KEY=123456789 MINIO_DOMAIN=a.com
> nssm start MinIO & start http://127.0.0.1:9000/     # 启动Windows服务&打开浏览器
~~~
> Windows 10 系统问题排查
~~~bash
sfc /SCANNOW                                    # 检查系统组件是否有问题？
DISM.exe /Online /Cleanup-image /Scanhealth     # 扫描系统组件问题
DISM.exe /Online /Cleanup-image /Checkhealth    # 检查系统组件问题
DISM.exe /Online /Cleanup-image /Restorehealth  # 恢复系统组件
~~~
> Windows 10 网络问题排查
~~~bash
#.开始菜单->设置->更新和案例->疑难解答->其他疑难解答->Internet连接->运行疑难解答
#.或者重置->当前的WinHTTP代理服务器设置->以管理员身份运行CMD
netsh winhttp reset proxy
netsh winhttp import proxy source=ie
~~~


#### 注册表

> 系统服务管理

- Windows Update 禁用::服务名 wuauserv & WaaSMedicSvc & UsoSvc
~~~cmd
REG add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v Start /t REG_DWORD /d 4 /f
REG add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f
REG add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v Start /t REG_DWORD /d 4 /f
~~~


#### 系统开发环境MSYS2+Mingw64+Qt5+...

> [MSYS2 install](https://www.msys2.org/wiki/MSYS2-installation/)
~~~bash
# 先修改软件仓库为国内镜像源(/etc/pacman.d/)参考 https://mirrors.tuna.tsinghua.edu.cn/help/msys2
## Update MSYS2 repository >> D:\Program\msys64\etc\pacman.d\
## Primary >> mirrorlist.mingw32
Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/i686/
Server = https://mirrors.sjtug.sjtu.edu.cn/msys2/mingw/i686/
Server = http://mirrors.ustc.edu.cn/msys2/mingw/i686/
Server = http://mirror.bit.edu.cn/msys2/mingw/i686/
## Primary >> mirrorlist.mingw64
Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/x86_64/
Server = https://mirrors.sjtug.sjtu.edu.cn/msys2/mingw/x86_64/
Server = http://mirrors.ustc.edu.cn/msys2/mingw/x86_64/
Server = http://mirror.bit.edu.cn/msys2/mingw/x86_64/
## Primary >> mirrorlist.msys
Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch/
Server = https://mirrors.sjtug.sjtu.edu.cn/msys2/msys/$arch/
Server = http://mirrors.ustc.edu.cn/msys2/msys/$arch/
Server = http://mirror.bit.edu.cn/msys2/msys/$arch/
# 更新系统重启
> pacman -Syu
# 更新软件仓库
pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime
# 安装开发环境 gcc,make,pkgconfig
pacman -S base-devel git mercurial cvs curl wget p7zip python # perl ruby go # 基础环境(推荐)
# Win32软件Shell（\Start Menu\Programs\MSYS2 64bit\MSYS2 MinGW 32-bit）
pacman -S mingw-w64-i686-gcc                               # 安装32位gcc编译环境
pacman -S mingw-w64-i686-toolchain                         # 安装32位Mingw（D:\Program\msys64\mingw32）
pacman -S mingw-w64-i686-gtk3 mingw-w64-i686-gtk2          # 安装GTK相关库（同时安装两个版本GTK3+GTK2）
## gcc -o main.exe /c/src/main.c `pkg-config --libs --cflags gtk+-2.0` # 编译指令（`C盘`路径为`/c`）
# Win64软件Shell（\Start Menu\Programs\MSYS2 64bit\MSYS2 MinGW 64-bit）
pacman -S mingw-w64-x86_64-toolchain                       # 安装64位Mingw（D:\Program\msys64\mingw64）
pacman -S mingw-w64-x86_64-toolchain mingw-w64-x86_64-v8   # 安装64位Mingw(all)+V8 https://github.com/rogchap/v8go
pacman -Sl|grep lua                                        # 搜索并安装lua...
# 桌面开发环境 Qt 
# Win软件Shell(不需要编译时)（\Start Menu\Programs\MSYS2 64bit\MSYS2 MSYS）
pacman -S mingw-w64-x86_64-qt5 mingw-w64-x86_64-qt-creator # 安装64位Qt5 (推荐)
pacman -S mingw-w64-i686-qt5 mingw-w64-i686-qt-creator     # 安装32位Qt5
~~~


----
