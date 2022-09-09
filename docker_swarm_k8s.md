# [Docker](https://docs.docker.com)


 * [`K8S/Kubernetes`](#Kubernetes)/[`Minikube`](#Minikube) + [安装参考文档](https://github.com/angenalZZZ/follow-me-install-kubernetes-cluster)、[一条命令离线安装](https://github.com/fanux/sealos)、[k8s学习网](https://www.v2k8s.com/) | [`Consul`](#Consul) + [`Etcd`](#Etcd)
 * [`免费的容器镜像服务`](#免费的容器镜像服务)、[`免费的开发服务器`](#免费的开发服务器)、[`安全相关思维导图`](https://github.com/phith0n/Mind-Map)
 * [`Docker+K8S学习笔记`](https://github.com/angenalZZZ/learn-docker-and-k8s)、[`GitLab+Docker+K8S集成系统`](https://github.com/angenalZZZ/gitlab-docker-k8s)


#### 安装、[配置](#配置)、[构建镜像](#构建镜像)、[容器命令](#容器命令)、[容器编排](#容器编排)、[Kubernetes](#kubernetes)
> [docker](https://docs.docker.com/install)、[docker-hub](https://hub.docker.com/repositories)、[docker-desktop](https://hub.docker.com/?overlay=onboarding) Build构建>Compose编排>Swarm集群>>K8s稳定强大<br>
  `环境 & 版本` : [`Linux x64, Kernel^3.10 cgroups & namespaces`](https://docs.docker.com/install), [`docker-ce`社区版](https://hub.docker.com/?overlay=onboarding) + `docker-ee`企业版 <br>
  `加速器`..   : [`阿里云`](https://cr.console.aliyun.com/#/accelerator)[..](https://4txtc8r4.mirror.aliyuncs.com)、[`DaoCloud道客`](https://dashboard.daocloud.io/packages/explore)[..](http://8fe1b42e.m.daocloud.io)、[`网易`](https://hub-mirror.c.163.com)、 [`自动mirror.py`](https://github.com/silenceshell/docker_mirror) <br>

> `Dockerfile` : `docker build Image(tag=name+version)` > `push Registry` <br>
  `Registry & Disk` : `Repository` > `Image-Url` | `Image save .tar to-Disk`, `Container export .tar(snapshot)` <br>
  `Docker`     : `pull Image from-Registry` | `load Image .tar from-Disk` <br>
  `Data`        : `docker container run Image` - `--volumes-from Data-Container` - `-v from-Disk:Data-Dir` <br>
  `Cert`         : `C:/ProgramData/DockerDesktop/pki/` - `C:/Users/Administrator/.kube/config`  ...  

~~~shell
# 安装Docker，先切换用户~ su - root #
$ curl -sSL https://get.daocloud.io/docker | sh  # 安装,镜像 daocloud
$ curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://{your-id}.m.daocloud.io
$ curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh - # 安装,镜像 阿里云
# vi /usr/lib/systemd/system/docker.service << ... daemon --registry-mirror=https://{your-id}.mirror.aliyuncs.com
$ systemctl enable docker && systemctl daemon-reload && systemctl restart docker # 安装后,enable开机启动
# tee /etc/docker/daemon.json <<-'EOF' \ {"registry-mirrors":["https://4txtc8r4.mirror.aliyuncs.com"]} # 手动配置 
$ systemctl status docker             # 检查Docker运行状态
$ sudo apt -y install ntpdate && sudo ntpdate cn.pool.ntp.org # 同步时间
$ apt-get remove docker docker-engine # 卸载Docker最后清理 # rm -rf /var/lib/docker/
# 安装 Docker Compose (容器编排)
$ sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` \
    -o /usr/local/bin/docker-compose  # 设置文件为可执行 sudo chmod +x docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose # 创建快捷方式
# 安装 Docker Machine 基于virtualBox  # www.virtualbox.org/wiki/Linux_Downloads
$ sudo dpkg -i virtualbox-6.1_6.1.2-135662_Ubuntu_bionic_amd64.deb --fix-missing # 安装 virtualbox v6.1
$ sudo curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-$(uname -s)-$(uname -m) \
    > /usr/local/bin/docker-machine  # 安装 docker-machine
$ docker-machine version             # 安装完毕,查看版本
# 设置 Docker 执行, 不使用sudo执行docker命令，先切换当前用户 su -u xxx (root~exit)
sudo gpasswd -a ${USER} docker && newgrp - docker # 将当前用户加入并更新docker组
sudo service docker restart          # 重启Docker服务 # sudo systemctl restart docker
# 本机启动 Docker Daemon (容器服务端) 
$ curl -Lo ~/.docker/machine/cache/boot2docker.iso \ # 下载最新版本的boot2docker镜像 for docker-machine create
    https://github.com/boot2docker/boot2docker/releases/download/v19.03.5/boot2docker.iso
$ docker-machine create -d kvm2 default  # 推荐安装 默认主机server
$ docker-machine create -d virtualbox default  # 1.下载安装默认主机server    # 2.设置客户端docker默认server环境
$ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_CERT_PATH="/home/yangzhou/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
export DOCKER_HOST="tcp://192.168.99.100:2376"
# Run this command to configure your shell:
# eval $(docker-machine env default)
$ docker-machine start default
$ docker info  # 客户端cli查看docker完整信息; 当出现权限问题时 # sudo chown `id -un`:`id -un` ~/.docker
# 监听> tcp & TLS 允许cli远程访问:2376 暴露指定端口
$ sudo /usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 --containerd=/run/containerd/containerd.sock --registry-mirror={镜像}
# 在虚拟机上安装运行docker # 先创建虚拟机manager,worker... 宿主机通过ssh访问虚拟机免密设置 generic指虚拟机已创建+vboxnet
$ docker-machine create -d generic --generic-ip-address=192.168.56.101 --generic-ssh-key ~/.ssh/id_rsa manager
$ docker-machine create -d generic --generic-ip-address=192.168.56.102 --generic-ssh-key ~/.ssh/id_rsa worker1
$ docker-machine create -d generic --generic-ip-address=192.168.56.103 --generic-ssh-key ~/.ssh/id_rsa worker2
$ docker-machine ls           # 查看虚拟机上的servers
$ docker-machine env manager  # 在manager虚拟机上执行docker指令> docker ps
# 界面管理工具 DockerUI 基于Docker API 提供命令大部分功能 > docker pull uifd/ui-for-docker
$ docker run -itd --name docker-ui -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock docker.io/uifd/ui-for-docker
# 界面管理工具 Portainer 占用资源少，支持集群，权限分配等管理功能
$ docker run -d -p 9000:9000 portainer/portainer # 1.简单部署，管理Swarm群集；2.如下,在Docker群集中部署Portainer服务
$ docker service create --name portainer --publish 9000:9000 --constraint 'node.role == manager' \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  portainer/portainer -H unix:///var/run/docker.sock
~~~

#### 配置

> **Docker Config** 
~~~shell
# < Windows Subsystem for Linux | WSL >---#(连接到 Docker for Windows10)
$ sudo apt install docker.io              # 安装Docker客户端 | docker.io get client connection.
$ export DOCKER_HOST=tcp://127.0.0.1:2375 # 设置环境Linux vi ~/.bashrc [或者~/.profile](文件结尾添加)
> $env:DOCKER_HOST="tcp://localhost:2375" # 设置环境Windows PowerShell [连接Docker-Server端TCP地址]
> set DOCKER_HOST=tcp://localhost:2375    # 设置环境Windows Command Line

$ docker [OPTIONS] COMMAND
# 选项Options:
#1. --config 默认=$HOME/.docker
#2. --context -c 默认为$DOCKER_HOST=`docker context use` 当前用户上下文指向的容器服务端(不同用户登录后,可能需要切换)
#3. --debug -D 是否启用调试?
#4. --host -H 容器服务端主机socket(s)列表
#5. --tls --tlsverify --tlscacert * --tslcert * --tlskey * 启用服务端tls安全登录认证与客户端tls安全连接tlsverify
#6. --log-level -l 日志级别,默认=info(debug|info|warn|error|fatal)
#7. --version -v 打印版本信息
$ docker [COMMAND] --help                 # 执行Docker命令:重定向Docker\Server响应输出/如同R语言sink()
# Docker环境:修改Linux内核参数 blog.csdn.net/guanheng68/article/details/81710406
$ grep vm.max_map_count /etc/sysctl.conf  # 检查vm设置, 默认虚拟内存大小不够;
$ sysctl -w vm.max_map_count=262144       # 执行Docker操作无效时才修改, 或者 vi /etc/sysctl.conf
$ sysctl -p                               # 生效/etc/sysctl.conf 修改
~~~

> ~/.docker/config.json
~~~js
{
  "credsStore":"desktop",
  "experimental":"disabled", // Enable the experimental WSL 2 based engine (requires Win 10 build 19018+)
  "stackOrchestrator":"swarm" // Enable swarm mode
}
~~~

> ~/.docker/daemon.json
~~~js
{
  "registry-mirrors": [
    "https://{your-id}.mirror.aliyuncs.com" // Or: http://{your-id}.m.daocloud.io
  ],
  "insecure-registries": [],
  "debug": false,
  "experimental": true, // Enable实验性功能features:eg. DOCKER_BUILDKIT=1
  "features": {
    "buildkit": true // # syntax = docker/dockerfile:experimental
  }
}
~~~

> **docker-search-tags.sh** 搜索/标签/版本
 - https://dashboard.daocloud.io/packages/explore
~~~
  # Usage: $ ./docker-search-tags.sh ubuntu
  for Repo in $* ; do
    curl -s -S "https://registry.hub.docker.com/v2/repositories/library/$Repo/tags/" | \
      sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
      grep '"name"' | \
      awk -F\" '{print $4;}' | \
      sort -fu | \
      sed -e "s/^/${Repo}:/"
  done
~~~

#### 构建镜像

> **Dockerfile** [文档](https://docs.docker.com/get-started) <br>
    docker build -t {USER_NAME} / {APP_NAME} : {VERSION-SYSTEM} .  # -t标记名称+版本 <br>
    docker build --progress=plain -t myname/demo -f Dockerfile .  # -f指定文档 --progress输出细节

~~~dockerfile
# node基础镜像
FROM node:10.15.0

# 备注镜像相关信息，通过 docker inspect 查看
LABEL maintainer="test <test@gmail.com>"
LABEL description="this is a test image"
LABEL version="1.0"

# 设置当前用户为root，因为后面安装需要使用root用户执行
USER root
# 设置当前工作目录，若不存在会自动创建，其他指令会以此为相对路径
WORKDIR /work/app

# ADD <src> <dest>
# 添加资源到工作目录，若是压缩文件会自动解压，可指定远程地址下载url
ADD 'https://github.com/nodejscn/node-api-cn/blob/master/README.md' ./doc/

# COPY <src> <dest>
# 复制资源到工作目录，不会解压，无法从远程地址下载
COPY ./ ./

# RUN 构建镜像时执行的命令(安装运行时环境、软件等)
RUN npm install
# RUN前提:FROM基础镜像的:系统环境变量:PATH中的可执行程序npm

# 安装 .NET Core https://docs.microsoft.com/zh-cn/dotnet/core/install/runtime?pivots=os-linux
# RUN wget -O dotnet-runtime.tar.gz https://download.*/aspnetcore-runtime-3.1.2-linux-x64.tar.gz
# RUN mkdir -p $HOME/dotnet && tar zxf dotnet-runtime.tar.gz -C $HOME/dotnet
# RUN usermod -aG root dotnet  # 添加root用户至dotnet(附加用户组)
# USER dotnet                  # 设置当前用户为dotnet(用于执行以后的命令)
# ENV DOTNET_ROOT=$HOME/dotnet  # 添加dotnet环境变量
# ENV PATH=$PATH:$HOME/dotnet   # 修改环境变量PATH
# dotnet tool install -g [工具] # 在线安装dotnet工具

# ARG 构建镜像时可传递的参数，配合 ENV 使用 docker build --build-arg NODE_ENV=dev
# 设定必填的参数
ARG NODE_ENV
# 设定可选的带默认值的参数
ARG TZ='Asia/Shanghai'

# ENV 容器运行时的环境变量，配合 ARG 使用 $NODE_ENV '${TZ}'
# 修改:FROM基础镜像的:系统环境变量
ENV PATH="${PATH}:/dotnet:/var/.dotnet/tools"
# 添加环境变量
ENV NODE_ENV=$NODE_ENV
# 设置时区
ENV TZ '${TZ}'

# EXPOSE 容器端口(可指定多个)，启动时指定与宿主机端口的映射 docker run -p 9999:8888
# 暴露的两个端口都可与宿主机端口进行映射
EXPOSE 8080 8888

# CMD 容器启动后执行的命令，会被 docker run 命令覆盖
CMD ["npm", "start"]
# other, web-proxy, eg. CMD ["nginx", "-g", "daemon off;"]

# ENTRYPOINT 容器启动后执行的命令，不会被 docker run 命令覆盖，未指定应用时一般不会使用；
# 任何 docker run 命令设置的指令参数 或 CMD 指令，都将作为参数追加至 ENTRYPOINT 命令之后
# ENTRYPOINT ["dotnet", "aspnetapp.dll"]
~~~

> **.dockerignore** 配置文件/屏蔽读取
~~~dockerignore
# 临时文件
*/temp*
*/*/temp*
temp?
!README*.md
# 编译文件
obj\
~~~
> *go语言*
~~~dockerfile
# golang基础镜像
FROM golang:1.14-alpine

LABEL maintainer="test <test@gmail.com>"
LABEL description="this is a test image"
LABEL version="1.0"

RUN apk add bash ca-certificates git gcc g++ libc-dev
WORKDIR /app

# Force the go compiler to use modules
ENV GO111MODULE=on
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY main.go .
COPY foo/foo.go foo/
COPY bar/bar.go bar/

ENV GOOS=linux
ENV GOARCH=amd64
RUN go build -o /app -v -tags netgo -ldflags '-w -extldflags "-static"' .

CMD ["/app"]
~~~
> *开启实验性功能 BuildKit 快速编译：第一行syntax务必要填写；第二，可以在任何RUN时，使用--mount进行缓存*
~~~dockerfile
# syntax = docker/dockerfile:experimental
# ... ...
RUN --mount=type=cache,target=/var/cache/apk apk add bash ca-certificates ... ...
# ... ...
RUN --mount=type=cache,target=/go/pkg/mod go mod download
# ... ...
RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build go build -o \
  /app -v -tags netgo -ldflags '-w -extldflags "-static"' .

CMD ["/app"]
~~~
> *go语言/构建最小镜像*
~~~dockerfile
# build stage # 注意设定 GOOS, GOARCH 和 CGO_ENABLED
FROM golang:alpine AS build-env
ADD . /src
RUN cd /src && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-s -w -extldflags "-static"' -o app .

# final stage
# FROM alpine # 最小image请选择centurylink 构建后约~ 1.81MB
FROM centurylink/ca-certs
COPY --from=build-env /src/app /
ENTRYPOINT ["/app"]

# final another stage  https://blog.wu-boy.com/2018/06/drone-kubernetes-with-golang/
# FROM alpine # 其中 plugins/base:multiarch 用的是 docker scratch 最小 image 搭配 SSL
FROM plugins/base:multiarch
ADD /src/app /
ENTRYPOINT ["/app"]
~~~

#### 容器命令

> **Docker Command** [samples](https://docs.docker.com/samples)、[labs/tutorials](https://github.com/angenal/labs)、[小结](https://github.com/AlexWoo/doc/blob/master/devops/docker小结.md)
~~~shell
  # 运行
  docker-machine ip          # 获得当前Docker宿主机的IP地址
  docker-machine ssh default # 登录到Boot2docker虚拟机之上(Linux-无需如此)
  docker run --name test-image-docker -it -p 9999:8888 test-image # 已加载镜像 test-image 时, 用 docker images 查询
  # 网络
  docker network ls                                 # 查看网络列表
  docker network create -d bridge [network-name]    # 创建自定义网络[-d bridge 网络驱动=桥接模式]
  docker network create -o "com.docker.network.bridge.name"="***-net" --subnet 172.18.0.0/16 ***-net #指定子网172.18/255
  docker network connect [network-name] [container] # 1.入网,加入自定义网络(参数2,3,4可一起写)
  docker network connect --alias db [network-name] [container] # 2.入网,提供别名访问
  docker network connect --link other_container:alias_name [network-name] [container] # 3.入网,连接其它容器指定别名
  docker network connect --ip 10.10.36.122 [network-name] [container] # 4.入网,连接其它容器指定ip
  docker network disconnect [network-name] [container] # 退出网络 指定[container]
  docker network create -d host host        # 创建自定义网络host(默认已添加); -d [host:与主机共享一个IP地址/内网地址]
  docker network create -d bridge workgroup # 创建自定义网络workgroup; -d [bridge(默认):分配给容器一个IP地址]
  docker network connect workgroup redis5 && docker network connect workgroup centos.netcore # 加入自定义网络workgroup
  docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" [container] # 查询IP地址
  docker inspect -f "Name:{{.Name}}, Hostname:{{.Config.Hostname}}, IP:{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" [container]
  docker inspect -f "{{.Config.Hostname}} {{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" $(docker ps -aq)
  docker run --name myweb --network=workgroup --link -d -P redis5:redis5 nginx # 容器之间安全互联 myweb连接redis5:redis5别名
  docker run --name myweb --network bridge --ip 172.18.0.2 --network=***-net ... ...  # 指定子网172.18/255+bridge

  # 构建镜像            # 参数-f最后指定Docker工作路径(默认.当前目录下存在Dockerfile)
  docker build --no-cache --build-arg NODE_ENV=dev -m 1G -t test:1.0 . # 参数-t --tag [镜像id|name+version]; 参数-m内存限制

  # 登录^镜像^管理
  docker login -u 用户名 -p 密码 [仓库地址] # 登录Docker镜像仓库,如果未指定,默认官方仓库hub.docker.com
  docker images        # 查看镜像 [options] -a列出本地所有镜像 -f显示满足条件的镜像 -q只显示镜像ID
  docker images |grep "redis" # 查看过滤的镜像
  docker image inspect # 获取镜像的元数据
  docker search ubuntu # 搜索镜像
  docker pull ubuntu   # 下载镜像
  docker tag [镜像id|name][:tag] [Docker-Hub-镜像仓库host-user]/[镜像name][:tag] # 标记本地镜像,将其归入仓库
  docker push [镜像id|name] # 推送镜像 [Docker-Hub]
  docker rmi [镜像id|name]  # 删除1个镜像
  docker rmi $(docker images -q) # 删除所有镜像
  docker save -o d:\docker\images\ubuntu_latest.tar ubuntu:latest # 保存镜像
  docker save ubuntu:latest > d:\docker\images\ubuntu_latest.tar  # 保存镜像
  docker load -i /opt/images/ubuntu_latest.tar # 加载镜像 (使用Xftp将镜像tar上传至Docker虚拟机或共享盘)
  docker load < /opt/images/ubuntu_latest.tar  # 加载镜像 (文件流的方式)
  docker import /opt/images/ubuntu_latest.tar [镜像name] # 从镜像归档文件创建指定命名的镜像
  docker commit [容器id|name] [镜像id|name][:tag] # 从容器创建一个新的镜像-另存为镜像(save container to image)
  docker logout        # 退出^镜像^管理
  
  # 管理容器
  docker stats         # 查看容器占用资源, 例如：容器名、cpu、内存、io等
  docker ps -a         # 查看容器 docker container ls -a -q # -q列出容器ID
  docker ps -a -f name=ubuntu -n 1 # -a显示所有容器 -f过滤容器名 -n列出最近创建的n个容器
  
  docker export ubuntu > "d:\docker\snapshot\ubuntu_19_04.tar"           # 导出快照 (export snapshot)
  docker container export -o "d:\docker\snapshot\ubuntu_19_04.tar" ubuntu # 导出快照 (export snapshot)
  docker cp d:\docker\app\xxx\publish centos.netcore:/home/app/xxx/publish # 复制目录 (copy dir to container)
  docker cp centos.netcore:/home/app/entrypoint.sh d:\docker\app\centos\home\app\entrypoint.sh # 复制文件
  #-config>>  ~/.bash_aliases
alias dockerstartall='docker container start $(docker ps -aq)'     # 启动所有容器
alias dockerstopall='docker container stop $(docker ps -aq)'       # 停止所有容器
alias dockerrestartall='docker container restart $(docker ps -aq)' # 重启所有容器
alias dockerkillall='docker kill $(docker ps -q)'                  # 杀死所有运行的容器
alias dockercleanc='docker container prune'                        # 删除所有停止的容器(同下)
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -aq)'
alias dockercleaniall='docker rm $(docker ps -a -q)'               # 删除所有容器(下面是删未标记的镜像)
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -qf dangling=true)'
alias dockerclean='dockercleanc || true && dockercleani'           # 清除停止的容器及删未标记的镜像

  docker inspect [container]       # 查看容器详情(container包括ID或名称)
  docker diff [container]          # 检查容器里文件结构的更改 (相对原始镜像里的文件结构)
  docker rename web [container]    # 容器重新命名
  docker rm [container]            # 删除1个容器( +自管理卷模式 --volume [匿名volume-name] )
  docker rm $(docker ps -a -q)     # 删除所有容器
  docker port [container]          # 查看端口映射
  docker system prune              # 删除未使用数据
  docker volume prune              # 删除未使用volume
  docker volume rm [name]          # 删除指定的volume
  docker volume ls                 # 查看当前所有volume
  docker volume inspect [name]     # 查看volume详细信息
  docker volume create --name [name] # 创建 volume-name 默认路径 /var/lib/docker/volumes/[name]/_data/
  
  docker run [OPTIONS] [镜像id|name][:tag] # 创建一个新的容器并运行
  # 选项Options:
  #1. --name 为容器指定名称
  #2. --volume -v 绑定一个卷(目录不存在,会自动创建) 1.[匿名volume-name] 2.[volume-name]:容器目录/文件 3.宿主目录/文件:容器目录/文件
  #3. --restart=no|always|on-failure 重启策略
  #4. -m 内存限制大小 ( eg: -m 512m )
  #5. -d 后台运行容器，并返回容器ID
  #6. -p 指定端口映射，格式：主机(宿主)端口:容器端口
  docker update --restart=always [container] # 修改配置: 设置为开机启动 (可在 docker run 时添加)
  docker logs [OPTIONS] [container] # 查看容器日志
  # 选项Options:
  #1. -t 显示时间戳
  #2. -f 跟踪日志输出
  #3. --since 显示某个开始时间以来的所有日志
  #4. --tail 仅列出最新N条日志
  # docker logs --since="2020-02-02" --tail=10 nginx
  # docker 启动后默认日志路径：/var/lib/docker/containers/容器ID/*.log
  
  docker start|restart [container] # 开启或重启指定容器
  docker pause|unpause [container] # 暂停或恢复指定容器
  docker stop $(docker ps -q -f status=running) # 停掉所有正在运行的容器
  docker stop 8b49 & docker rm -f mysite    # 停止+删除 :容器[ID前缀4位 或 FullName]
  docker stop web & docker commit web webimg & docker run -p 8080:80 -td webimg # commit新镜像webimg&run端口映射
  
  docker top [options] [container] # 查看容器中运行的进程，支持ps命令参数(不会被exec代替,因为容器中不一定有top命令)
  docker exec -it redis5 /bin/sh -c "ps aux & /bin/sh"  # 在容器中执行命令: 查看进程详情后,进入工作目录执行sh

  docker run -it --log-opt max-size=20m --log-opt max-file=5 alpine ash #限制容器生成的日志文件大小、文件数量
  docker run -it --rm -e AUTHOR="Test" alpine /bin/sh #查找镜像alpine+运行容器alpine+终端交互it+停止自动删除+执行命令
  docker run --name mysite -d -p 8080:80 -p 8081:443 dockersamples/static-site #查找镜像&运行容器mysite&服务&端口映射

  # 内存KV数据库redis
  docker run --name redis5 --network=workgroup --network-alias=redis5 --restart=always -d -m 512m -p 6379:6379 
    -v d:\docker\app\redis5\redis.conf:/etc/redis/redis.conf -v d:\docker\app\redis5\data:/data 
    redis:5.0.14 redis-server /etc/redis/redis.conf # 执行Sh /usr/local/bin/docker-entrypoint.sh
  docker run --name redis6 --restart=always -d -m 512m -p 16379:6379 -p 8001:8001 
    -e REDIS_ARGS="--requirepass 123456" -e REDISTIMESERIES_ARGS="RETENTION_POLICY=20" 
    -v /media/ShareFolder/docker/app/redis6/data:/data 
    -v /media/ShareFolder/docker/app/redis6/local-redis-stack.conf:/redis-stack.conf 
    redis/redis-stack
  # docker exec -it redis-stack redis-cli -p 6379 -a "123456" # 执行redis客户端命令
  docker run -p 6379:6379 -itd redislabs/redistimeseries  # 时序Db https://github.com/RedisLabsModules
  docker run --name ssdb --network=workgroup --network-alias=ssdb -d -m 512m -p 8888:8888 
    -v d:\docker\app\ssdb\ssdb.conf:/ssdb/ssdb.conf leobuskin/ssdb-docker # 替代Redis http://ssdb.io/zh_cn
  
  # 微软开源.netcore 参考 https://docs.docker.com/compose/aspnet-mssql-compose
  # Startup.sh1: docker run -v ${PWD}:/app --workdir /app microsoft/aspnetcore-build:lts dotnet new mvc --auth Individual
  docker run --name dotnet --network=workgroup -it -m 512m -p 8080:80 -v "d:\docker\app\microsoft.net\app:/app" 
    microsoft/dotnet     # 最新版dotnet
    microsoft/dotnet:sdk # 最新版dotnet-sdk 用于开发
    microsoft/dotnet:aspnetcore-runtime #最新版dotnet-runtime 用于生产
  # 步骤Step:
  #1. dotnet publish -f netcoreapp3.1 -o ..\publish\ # 生成app可执行dll,存放容器中/publish/
  #2. create ..\publish\app\Dockerfile /*
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
COPY . /publish
WORKDIR /publish
# EXPOSE 443
EXPOSE 80
ENTRYPOINT ["dotnet", "App.Host.dll"] */
  #3. docker build -t app:1.0 .  # 构建镜像V1.0
  #4. docker run --name app -d -p 8080:80 --restart=always app:1.0 # 运行容器, 执行命令入口 ENTRYPOINT

  # 开源系统 Linux 分支 centos
  docker run --name centos -it --network=workgroup -m 512m -p 8000:80 -v "d:\docker\app\centos\home:/home" -w /home 
    centos /bin/bash # 其它: --workdir /home/ConsoleApp2NewLife centos /bin/sh -c "/bin/bash ./entrypoint.sh"
    $ rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm & yum install -y dotnet-runtime-2.1
    $ dotnet /home/ConsoleApp2NewLife/ConsoleApp2NewLife.dll # 访问tcp://127.0.0.1:8000

  # 开源数据库mysql
  docker run --name mysql --restart=always -itd -m 1024m -p 3306:3306 --network=workgroup --network-alias=mysql --env MYSQL_ROOT_PASSWORD=HGJ766GR767FKJU0 
    mysql:5.7 # mariadb、mongo、mysql/mysql-server、microsoft/mssql-server-linux, (--network-alias)其它容器连此容器
  # 微软数据库mssql
  docker run --name mssql --restart=always -itd -m 1024m -p 1433:1433 --network=workgroup --network-alias=mssql -v "d:\docker\app\mssql\data:/var/opt/mssql/data" 
    -v "d:\docker\app\mssql\log:/var/opt/mssql/log" -e SA_PASSWORD=HGJ766GR767FKJU0 -e ACCEPT_EULA=Y 
    mcr.microsoft.com/mssql/server

  # 外部访问控制：(--link)其它容器连db, 外部内网访问控制：(--net=host -bind=192.168.1.2)不安全连接(与主机共享一个IP)+内网私有访问bind-ip
  
  # 开源数据库mysql中间件, 开源分布式中间件dble, 上海.爱可生开源社区 opensource.actionsky.com
  docker network create -o "com.docker.network.bridge.name"="dble-net" --subnet 172.166.0.0/16 dble-net
  docker run --name dble-backend-mysql1 --network bridge --ip 172.166.0.2 -e MYSQL_ROOT_PASSWORD=123456 -p 33061:3306 
    --network=dble-net -d -v "d:\docker\app\dble\mysql1:/var/lib/mysql" mysql:5.7 --server-id=1
  docker run --name dble-backend-mysql2 --network bridge --ip 172.166.0.3 -e MYSQL_ROOT_PASSWORD=123456 -p 33062:3306 
    --network=dble-net -d -v "d:\docker\app\dble\mysql2:/var/lib/mysql" mysql:5.7 --server-id=2
  docker run --name dble-server -itd --ip 172.166.0.5 -p 8066:8066 -p 9066:9066 --network=dble-net actiontech/dble
  docker cp dble-server:/opt/dble d:\docker\app\dble #复制后配置/opt/dble/conf/schema.xml <dataHost.name,writeHost.url>
  docker update -v "d:\docker\app\dble\dble:/opt/dble" dble-server #更新容器配置
  docker restart dble-server  #重启dble容器服务
  #连接dble sql服务端⼝ 非java开发的mysql客户端可能无法使用;建议用dbeaver下载:pan.baidu.com/s/1RTib8RyX92O0LQSi0wz3EQ 提取码:avm5
  mysql -P8066 -u root -p123456 -h 127.0.0.1
  #连接dble 控制管理端⼝
  mysql -P9066 -u man1 -p123456 -h 127.0.0.1
  #连接后端mysql1
  mysql -P33061 -u root -p123456 -h 127.0.0.1
  #连接后端mysql2
  mysql -P33062 -u root -p123456 -h 127.0.0.1
  
  # 数据库 Oracle 11g
  docker pull registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
  docker run --name oracle --restart=always -d -m 1024m -p 1521:1521 
    -v /media/ShareFolder/docker/app/oracle/oradata:/home/oracle/app/oracle/oradata 
    registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
  # docker-compose up -d -f A:\database\oracle\docker-compose.yml
  # 参考 https://www.cnblogs.com/mike666/p/13999397.html https://blog.csdn.net/qq_27858615/article/details/124834097
  sqlplus /nolog  # 登录数据库;或用其它客户端,如Navicat需安装Client: instantclient-basic-windows.x64-11.2.0.4.0.zip
  conn /as sysdba # 切换为管理用户
  ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED; # 修改密码规则策略为密码永不过期
  alter system set processes=2000 scope=spfile;   # 修改数据库最大连接数
  alter user system identified by system;         # 修改system账号密码为 system
  alter user sys identified by system;            # 修改sys账号密码为 system
  create user admin identified by admin1;         # 创建管理员账号admin密码为 admin1
  grant connect,resource,dba to admin;            # 将dba管理权限授权给账号 admin
  select * from dba_users where username='admin'; # 查看用户信息
  
  # 数据库 PostgreSql + 时序数据timescaledb + 云计算
  docker run --name timescaledb -d -p 5432:5432 -e POSTGRES_PASSWORD=123456 timescale/timescaledb:latest-pg11
  
  # 搜索引擎 ElasticSearch 中文参考 www.elastic.co/guide/cn/elasticsearch/guide/current/index.html
  docker pull elasticsearch:6.8.0
  docker run --name es -d --restart=always -p 9200:9200 -p 9300:9300 \
    -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms128m -Xmx128m" elasticsearch:6.8.0
  docker exec -it es /bin/bash > vi /usr/share/elasticsearch/config/elasticsearch.yml # 跨域配置
  docker run --name es_admin -d -p 9100:9100 mobz/elasticsearch-head #参考 github.com/mobz/elasticsearch-head
  
  # 开源时序数据库 influxdb  portal.influxdata.com
  docker run --name influxdb -d -p 9999:9999 quay.io/influxdb/influxdb:2.0.0-alpha
  # 开源时序数据库 opentsdb  opentsdb.net/docs/build/html/resources.html
  docker run --name opentsdb -d -p 4242:4242 
    -v d:\docker\app\opentsdb\tmp:/tmp -v d:\docker\app\opentsdb\data\hbase:/data/hbase 
    -v d:\docker\app\opentsdb\opentsdb-plugins:/opentsdb-plugins petergrace/opentsdb-docker
  # 开源分布式时序数据库M3DB(注意配置单节点时?可能吃掉整个磁盘资源!) m3db.github.io/m3/how_to/single_node github.com/m3db/m3
  docker run --name m3db -d -p 7201:7201 -p 7203:7203 -p 9003:9003 quay.io/m3/m3dbnode
  
  # 消息平台 nsq | nsq.io/deployment/docker.html
  docker run --name nsqlookupd --network=workgroup --network-alias=nsqlookupd -p 4160:4160 -p 4161:4161 
    nsqio/nsq /nsqlookupd -tcp-address 0.0.0.0:4160 -http-address 0.0.0.0:4161 # First Run before nsqd & nsqadmin 
  docker run --name nsqd --network=workgroup --network-alias=nsqd -p 4150:4150 -p 4151:4151 -v d:\docker\app\nsq\data:/data 
    nsqio/nsq /nsqd --data-path=/data --lookupd-tcp-address=nsqlookupd:4160 
    -tcp-address 0.0.0.0:4150 -http-address 0.0.0.0:4151 -mem-queue-size 10000 # --broadcast-address=<dockerIP>
  docker run --name nsqadmin -d --network=workgroup -p 4171:4171 nsqio/nsq /nsqadmin 
    --lookupd-http-address=nsqlookupd:4161 -http-address 0.0.0.0:4171 -statsd-interval 1m0s
  # 消息平台 kafka | wurstmeister.github.io/kafka-docker
  docker run --name kafka wurstmeister/kafka
  # 消息平台 rabbitmq | github.com/judasn/Linux-Tutorial/blob/master/markdown-file/RabbitMQ-Install-And-Settings.md
  docker run --name rabbitmq3 -d --network=workgroup --network-alias=rabbitmq 
    -p 5671:5671 -p 5672:5672 -p 4369:4369 -p 25672:25672 -p 15671:15671 -p 15672:15672 -p 61613:61613 
    -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=HGJ766GR767FKJU0 
    rabbitmq:3-management # 消息库rabbitmq http://localhost:15672 访问控制台
    # 消息服务rabbitmq插件: docker exec -it rabbitmq3 bash ; cd plugins ; rabbitmq-plugins enable rabbitmq_web_stomp
  
  # 工作流(Cadence)可扩展|长时间运行|业务应用系统  cadenceworkflow.io
  docker pull ubercadence/server
  # 事件|代理|自动化系统
  docker run --name beehive -d --network=workgroup -p 8181:8181 -v d:\docker\app\beehive\conf:/conf gabrielalacchi/beehive
  # 高性能的图形数据库(NoSQL)
  docker run --name neo4j --network=workgroup --network-alias=neo4j -m 512m -p 7474:7474 -p 7687:7687 
    -v "d:\docker\app\neo4j\data:/data" -v "d:\docker\app\neo4j\logs:/logs" neo4j:3.0
  # 大数据+分布式位图索引+实时计算(高IO)
  docker run --name pilosa --network=workgroup --network-alias=pilosa -d -p 10101:10101 -v d:\docker\app\pilosa\data:/data 
    pilosa/pilosa server --data-dir /data --bind :10101 --handler.allowed-origins http://localhost:10102
  # airflow: 一个基于celery任务DAG管理工具 kuanshijiao.com/2017/03/07/airflow1
  docker run --name airflow --network=workgroup --network-alias=airflow -d -p 8480:8080 -e LOAD_EX=y puckel/docker-airflow
  # mattermost: 一个安全的消息服务平台,自带后台管理
  docker run --name mattermost-preview -d -p 8065:8065 --add-host dockerhost:127.0.0.1 mattermost/mattermost-preview
  
  # 云存储解决方案 minio 参考 docs.min.io/cn  *19.2k (强力推荐)
  > nssm install MinIO A:/go/bin/minio/minio.exe server ./data # 安装Windows服务[以管理员身份运行]
  > nssm set MinIO AppDirectory A:/go/bin/minio            # 设置启动/工作目录
  > nssm set MinIO AppEnvironmentExtra MINIO_ACCESS_KEY=admin MINIO_SECRET_KEY=123456789 # nssm get MinIO AppEnvironmentExtra
  > nssm start MinIO & start http://127.0.0.1:9000/        # 启动Windows服务&打开浏览器
  > c:\minio\minio.exe server c:\minio\data            # 本地网盘svr：http://127.0.0.1:9000/ : Access-Key & Secret-Key
  > hidec /w minio.exe server d:\docker\app\minio\data # 隐藏控制台 & 后台运行 & 配置↑ data\.minio.sys\config\config.json
  > mc config host add minio http://127.0.0.1:9000 <ACCESS-KEY> <SECRET-KEY> # 客户端 dl.minio.io/client/mc/release
  > mc ls -r minio # 获取所有云存储对象列表
  > mc find minio/img --maxdepth 3 --name "*.png" --path "*" --larger 1KB --smaller 2MB --older-than 0d2h30m --json
  docker run --name minio-service -p 9000:9000 -v d:\docker\app\minio\data:/data -v d:\docker\app\minio\config:/root/.minio 
    -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" 
    minio/minio server /data # 对象存储服务，例如图片、视频、日志文件、备份数据和容器/虚拟机镜像等 https://docs.min.io/cn
    # 设置安全密钥: using Docker secrets
    # echo "AKIAIOSFODNN7EXAMPLE" | docker secret create access_key -
    # echo "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" | docker secret create secret_key -
  # 分布式文件存储系统 seaweedfs 参考 github.com/chrislusf/seaweedfs  *8.8k (强力推荐)
  $ mkdir -p $HOME/.seaweedfs/data && cd $HOME/.seaweedfs #创建目录
  $ weed scaffold -config=filer|master|notification|replication|security -output=. #配置文件
  ##启动1个节点n1\文件数据中心Cluster\拓扑Topology
  $ weed master -ip `hostname -i` -mdir="$HOME/.seaweedfs/data" -peers=127.0.0.1:9333 & 
  ##启动统计服务Stats  http://localhost:9333
  $ weed server -ip `hostname -i` -dir="$HOME/.seaweedfs/data" -master.peers=127.0.0.1:9333 & 
  ##添加存储服务Disk   http://127.0.0.1:8380
  $ weed volume -ip `hostname -i` -dir="$HOME/.seaweedfs/data" -port=8380 -max=15 -mserver=127.0.0.1:9333 & 
  ##添加文件服务File.Upload  http://127.0.0.1:8388    http://127.0.0.1:8888 [默认port=8888]
  $ weed filer -port=8388 -master=127.0.0.1:9333 & 
  ##添加云S3服务File.Upload  http://127.0.0.1:8333    https://aws.amazon.com/cn/s3 [官方文档]
  $ weed s3 -port=8333 -domainName=$S3_DOMAIN -cert.file=$S3_CERT -key.file=$S3_KEY -filer=127.0.0.1:8388 & 
  #-config>>  $HOME/.seaweedfs/crontab #任务配置-文件处理
*/2 * * * * * echo "volume.fix.replication" | weed shell -master=127.0.0.1:9333
*/2 * * * * * echo "volume.balance -c ALL -force" | weed shell -master=127.0.0.1:9333
  $ systemctl status crond #检查系统任务的服务状态, 或使用容器任务的管理工具: github.com/aptible/supercronic
  $ exec crontab -iu root $HOME/.seaweedfs/crontab & #执行任务-使用以上配置文件-依赖master-n1,volume-v1..每2分钟轮训
  > git clone https://github.com/chrislusf/seaweedfs.git #下载Src: go get github.com/chrislusf/seaweedfs/weed
  > cd $GOPATH/src/github.com/chrislusf/seaweedfs/docker #配置Dockerfile,*compose.yml..
  docker-compose -f seaweedfs-compose.yml -p seaweedfs up #生产:master,volume,filer,cronjob,s3..开发:dev-compose.yml
  # 分布式文件存储系统 godfs 参考 github.com/hetianyi/godfs  *1k (推荐)
  docker pull hehety/godfs
  docker run -d --name godfs-tracker -p 1022:1022 --restart always -v /godfs/data:/godfs/data --privileged -e log_level="info" 
    hehety/godfs tracker  #1.start tracker
  docker run -d --name godfs-storage -p 1024:1024 -p 80:9024 -v /godfs/data:/godfs/data --privileged 
    -e trackers=192.168.1.172:1022 -e advertise_addr=192.168.1.187 -e port=1024  -e instance_id="01" 
    hehety/godfs storage  #2.start storage
  docker run -d --name godfs-dashboard -p 8080:9080 --restart always hehety/godfs-dashboard #3.godfs monitoring
  
  # 基于 Jenkins 快速搭建持续集成环境
  git clone https://github.com/AliyunContainerService/docker-jenkins 
  cd docker-jenkins/jenkins && docker build -t denverdino/jenkins .
  docker run --name jenkins -d -p 8080:8080 -p 50000:50000 -v d:\docker\app\jenkins_home:/var/jenkins_home denverdino/jenkins
  # docker run --name jenkins -d -p 8080:8080 -p 50000:50000 -v d:\docker\app\jenkins_home:/var/jenkins_home jenkins

  # 搭建 OpenVPN 服务器 安全通信-基于-EasyRSA PKI CA
  git clone https://github.com/kylemanna/docker-openvpn
  git clone https://github.com/hwdsl2/docker-ipsec-vpn-server
~~~


#### 容器编排
> **docker-compose.yml** [安装Compose](https://docs.docker.com/compose/install/) [文档v3](https://docs.docker.com/compose/overview) | [老版本v2](https://www.jianshu.com/p/2217cfed29d7) | [votingapp例子](https://github.com/angenal/labs/blob/master/beginner/chapters/votingapp.md)<br>
> 　管理容器的生命周期，从应用创建、部署、扩容、更新、调度均可在一个平台上完成。<br>
> 　[`启动`](https://docs.docker-cn.com/compose/reference/up/)：`docker-compose up -d` | [`停止`](https://docs.docker-cn.com/compose/reference/down/)：`docker-compose down` | [`更多`](https://docs.docker-cn.com/compose/reference)：`pause`,`unpause`,`start`,`stop`,`restart`
~~~bash
docker-compose -h  #批量操作容器：同时启动，关闭，删除，构建等，但无法管理其他主机上的容器。
docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
build              #构建或重新构建容器服务
bundle             #从compose文件生成一个Docker包
config             #验证并查看compose文件
create             #创建容器服务
down               #停止并删除容器、网络、映像和卷
events             #从容器接收实时事件
exec               #在正在运行的容器中执行命令
help               #帮助命令
images             #镜像列表
kill               #杀死容器
logs               #查看容器的日志
pause              #暂停容器服务
port               #输出端口号
ps                 #容器列表
pull               #下载容器服务镜像
push               #上传容器服务镜像
restart            #容器服务重新开始
rm                 #删除停止的容器
run                #运行一次性命令
scale              #设置服务的容器数量
start              #开始容器服务
stop               #停止容器服务
top                #显示正在运行的进程
unpause            #暂停容器服务
up                 #创建并启动容器
version            #显示Docker-Compose版本信息
~~~
~~~dockercompose
version: '3' # docker compose 文件版本(版本不同,语法命令有所不同;最好是3.0以上版本)
services:    # docker services 容器编排;容器列表
  web:       # docker container service
    # build: # 构建镜像
    #   context: . # 构建镜像的上下文(本地构建的工作目录)
    #   dockerfile: Dockerfile # 指定构建文件(工作目录下)
    #   args: # 构建镜像时传递的参数/用于运行时环境变量
    #   - NODE_ENV=dev
    container_name: web-container # 容器名称
    image: docker-web-image       # 使用已有的镜像(用 docker images 查询)
    ports: # 端口映射(宿主机端口:容器端口)
      - "9999:8888"
    networks: # 网络设置(加入自定义网络)
      - front-tier
      - back-tier
    # links: # 外链容器(不安全)
    # - redis
    volumes: # 外挂数据(映射宿主机目录:容器工作目录)
      - "./data/:/work/app/data/"
    depends_on: # 启动时依赖的容器(容器启动顺序: 推荐第三方工具 wait-for-it dockerize 等)
      - redis
    restart: always # 重启设置
    env_file: # 环境变量配置文件 key=value
      - ./docker-web.env
    environment: # 设置容器运行时环境变量，会覆盖env_file相同变量
      - NODE_ENV: dev
    command: npm run dev # 容器启动后执行的命令

  redis:
    # container_name: redis-container
    image: redis:latest
    restart: always
    networks:
      - back-tier
    # command: redis-server --requirepass "password" # set redis password 设置 Redis 密码
    volumes:
      - "d:/docker/app/redis/data:/data"
    # ports:
    #   - "6379:6379"
    # splash:  # use Splash to run spiders on dynamic pages
    #   image: scrapinghub/splash
    #   container_name: splash
    #   ports:
    #     - "8050:8050"

networks: # 网络配置(创建/自定义)
  front-tier:
    driver: bridge # 网络驱动
    external: true # 网络自定义
  back-tier:
    driver: bridge

volumes: # 数据挂载配置
extensions: # 扩展配置
~~~
 * [快速搭建【反向代理、负载均衡】HTTPS服务器，在设计、部署和运行应用程序时-简化网络复杂性](https://docs.traefik.io/getting-started/quick-start/) 、[中文文档](https://docs.traefik.cn)
~~~dockercompose
version: '3'

services:
  reverse-proxy:
    # The official Traefik docker image
    image: traefik:v2.1
    # Enables the web UI and tells Traefik to listen to docker
    command: --api.insecure=true --providers.docker
    ports:
      # The HTTP port
      - "80:80"
      # The Web UI (enabled by --api.insecure=true)
      - "8080:8080"
    volumes:
      # So that Traefik can listen to the Docker events
      - /var/run/docker.sock:/var/run/docker.sock

  whoami:
    # A container that exposes an API to show its IP address
    image: containous/whoami
    labels:
      - "traefik.http.routers.whoami.rule=Host(`whoami.docker.localhost`)"

# > docker-compose up -d reverse-proxy       # web-main
# > docker-compose up -d whoami              # backend-1
# > docker-compose up -d --scale whoami=2    # backend-2
# > curl -H Host:whoami.docker.localhost http://127.0.0.1
~~~

# [**Kubernetes**](https://kubernetes.io)

> [`k8s`是一个流行的容器管理编排平台，集中式管理数个服务的容器集群](https://www.kubernetes.org.cn)、[`k8s`从上手到实践](https://juejin.cn/book/6844733753063915533)(搭建一个生产可用的集群)<br>
  　参数文档[Project-based-k8s](https://github.com/groovemonkey/project-based-kubernetes)  [Aliyun-Istio](https://github.com/AliyunContainerService/k8s-for-docker-desktop)  [kubeadm-ha](https://github.com/cookeem/kubeadm-ha)、安装[docker-desktop](https://www.docker.com/products/docker-desktop)已集成compose和k8s<br>
  　`Pod`：最小单元、一组容器的集合、同一个Pod内的容器共享网络命名空间、短暂的未存储的(重新发布后会丢失)；<br>
  　`Controllers`： `ReplicaSet`确保预期的Pod副本数量(一般由以下部署产生)，<br>
  　  　`Deployment`无状态的(`website`、`database`...)应用部署( pod应用 x 副本数量 )，<br>
  　  　 　 `ReplicationController & ReplicaSet & Deployment > HPA (HorizontalPodAutoScale)` <br>
  　  　`StatefulSet`有状态的(网络Id+存储`zk`,`mq`...)应用部署( pod应用 x 副本数量 )，<br>
  　  　`DaemonSet`确保所有节点运行同一个Pod的(监控`monitor`,计划`schedule`system...)服务部署，<br>
  　  　`Job`一次性任务部署，`CronJob`定时任务部署，其它服务部署... ；<br>
  　`Service`：防止Pod失联、定义一组Pod的访问策略`对外提供访问服务`；<br>
  　`Label`：`标签`附加到某个资源上，用于关联对象、查询和筛选对象；<br>
  　`Namespace`：`命名空间`，将对象逻辑上隔离。<br>
  　`搭建^6台`：负载均衡`虚拟IP`高可用`集群` (4核8G;IP1+IP2>>`VIP*`) load-balancer-master,load-balancer-backup <br>
  　  　前后端*`高IO型`的`Web`应用程序 (8核16G;IP3+IP4) k8s-master1,k8s-master2 <br>
  　  　长时间*`可水平扩展`的`分布式计算型`任务 (16核64G;IP5+IP6) k8s-node1,k8s-node2 <br>

![](https://github.com/angenalZZZ/doc/blob/master/screenshots/BorgDesign.png)
![](https://github.com/angenalZZZ/doc/blob/master/screenshots/K8sDesign.png)

> [安装](https://kubernetes.io/zh/docs/setup/)

* [离线安装](https://github.com/fanux/sealos)
   * 本地开发环境
```
# 下载并安装sealos, sealos是个golang的二进制工具，直接下载拷贝到bin目录即可
$ wget -c https://sealyun.oss-cn-beijing.aliyuncs.com/latest/sealos && \
    chmod +x sealos && mv sealos /usr/bin 

# 下载离线资源包
$ wget -c https://sealyun.oss-cn-beijing.aliyuncs.com/05a3db657821277f5f3b92d834bbaf98-v1.22.0/kube1.22.0.tar.gz

# 安装一个三个master的集群
$ sealos init --passwd '123456' \
	--master 192.168.0.2  --master 192.168.0.3  --master 192.168.0.4  \
	--node 192.168.0.5 \
	--pkg-url /root/kube1.22.0.tar.gz \
	--version v1.22.0
```
* 在线安装步骤:  1-8 (除了4) 在所有节点执行
 * 1.关闭防火墙，配置免密登录
```bash
systemctl stop firewalld # 防止端口不开放，k8s集群无法启动(k8s运行之后再开放firewalld)
```
   * 2.关闭selinux
```bash
setenforce 0
```
   * 3.关闭swap
```bash
swapoff -a    # 临时关闭
blkid | lsblk # 查看blk设备,注释swap的每一行(查找带有swap字样的信息)
vim /etc/fstab # 查找fs挂载点,注释swap的每一行(开启swap内存分区,会导致k8s无法启动)
free          # 查看swap是否关闭 Swap: 0  0  0
```
   * 4.添加主机名与IP对应的关系（这一步可以只在master执行），这一步我为后面传输网络做准备
```
vim /etc/hosts
192.168.235.145       k8s-master
192.168.235.146       k8s-node1

ssh-keygen
cat .ssh/id_rsa.pub >> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys

# 可以在master生成，然后拷贝到node节点
scp -r .ssh root@192.168.44.5:/root

# 查看这些端口是否被占用(如果被占用,请手动释放)
netstat -ntlp |grep -E '6443|23[79,80]|1025[0,1,2]' # 使用netstat: apt install net-tools
```
   * 5.将桥接的IPV4流量传递到iptables
```text
vi /etc/sysctl.d/k8s.conf

net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
```
   * 6.安装Docker及同步时间
```bash
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O/etc/yum.repos.d/docker-ce.repo

yum -y install docker-ce

systemctl start docker
systemctl enable docker

# 同步时间（这一步必须做，否则后面安装flannel可能会有证书错误）
yum install ntpdate -y
ntpdate cn.pool.ntp.org
```
   * 7.添加阿里云YUM软件源
```text
vi /etc/yum.repos.d/kubernetes.repo

[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
```
   * 8.安装kubeadm，kubelet和kubectl
```bash
yum makecache fast

yum install -y kubectl-1.18.3 kubeadm-1.18.3 kubelet-1.18.3 --nogpgcheck
```
   * 9. 部署Kubernetes Master  初始化master（在master执行）
```bash
# 第一次初始化比较慢，需要拉取镜像
kubeadm init --apiserver-advertise-address=192.168.235.145   # 换成自己master的IP
--image-repository registry.aliyuncs.com/google_containers 
--kubernetes-version v1.18.0
--service-cidr=10.1.0.0/16 
--pod-network-cidr=10.244.0.0/16  # 使用flannel网络必须设置成这个cidr

接下来，将初始化结果中的命令复制出来执行：
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

生成
kubeadm join 192.168.235.145:6443 --token w5rify.gulw6l1yb63zsqsa --discovery-token-ca-cert-hash sha256:4e7f3a03392a7f9277d9f0ea2210f77d6e67ce0367e824ed891f6fefc7dae3c8
```
   * 验证状态，发现前两个是pending，get pods 发现是not ready
```bash
kubectl get pods --all-namespaces
NAMESPACE     NAME                             READY   STATUS   RESTARTS   AGE
kube-system   coredns-9d85f5447-fhdmx         0/1     Pending   0         100d
kube-system   coredns-9d85f5447-x5wfq         0/1     Pending   0         100d
kube-system   etcd-local1                     1/1     Running   0         100d
kube-system   kube-apiserver-local1           1/1     Running   0         100d
kube-system   kube-controller-manager-local1   1/1     Running   0         100d
kube-system   kube-proxy-2trv9                 1/1     Running   0         100d
kube-system   kube-scheduler-local1           1/1     Running   0         100d
```
   * 需要安装flannel
```bash
# 安装flannel（在master执行）
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# 安装完flannel，将配置拷到node节点，否则添加节点之后状态不对
scp -r /etc/cni root@192.168.44.5:/etc

# 这一步也要拷贝，否则节点看着正常，但是pod由于网络原因无法创建
scp -r /run/flannel/ root@192.168.44.5:/run
```
   * 再次初始化(不用做也可以)
```
# 执行第9步的命令
kubeadm init ...

# 参数
--kubernetes-version 指定Kubernetes版本
--apiserver-advertise-address 指定apiserver的监听地址
--pod-network-cidr 10.244.0.0/16 指定使用flanneld网络
--apiserver-bind-port api-server 6443的端口
--ignore-preflight-errors all 跳过之前已安装部分（出问题时，问题解决后加上继续运行）
```
   * 查看集群状态，master正常
```bash
#[root@local1 ~]# kubectl get cs
NAME                 STATUS    MESSAGE             ERROR
scheduler            Healthy   ok                  
controller-manager   Healthy   ok                  
etcd-0               Healthy   {"health":"true"}

#[root@local1 ~]# kubectl get nodes
NAME     STATUS     ROLES    AGE     VERSION
local1   Ready      master   2m16s   v1.17.3

#[root@local1 ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                             READY   STATUS    RESTARTS   AGE
kube-system   coredns-9d85f5447-9s4mc          1/1     Running   0          16m
kube-system   coredns-9d85f5447-gt2nf          1/1     Running   0          16m
kube-system   etcd-local1                      1/1     Running   0          16m
kube-system   kube-apiserver-local1            1/1     Running   0          16m
kube-system   kube-controller-manager-local1   1/1     Running   0          16m
kube-system   kube-proxy-sdbl9                 1/1     Running   0          15m
kube-system   kube-proxy-v4vxg                 1/1     Running   0          16m
kube-system   kube-scheduler-local1            1/1     Running   0  
```
   * 10、node工作节点加载 (node节点执行1-8，如果第五步不执行，会添加失败; 在node节点执行上面初始化时生成的join命令)
```bash
kubeadm join 192.168.235.145:6443 --token w5rify.gulw6l1yb63zsqsa --discovery-token-ca-cert-hash sha256:4e7f3a03392a7f9277d9f0ea2210f77d6e67ce0367e824ed891f6fefc7dae3c8

# 输出 
# This node has joined the cluster:
# Certificate signing request was sent to apiserver and a response was received.
# The Kubelet was informed of the new secure connection details.

# Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
   * 在master查看
```text
[root@local1 ~]# kubectl get nodes
NAME     STATUS     ROLES    AGE     VERSION
local1   Ready      master   4m58s   v1.18.3
local2   Ready      <none>   3m36s   v1.18.3
```
   * 在node节点查看
```text
[root@local3 ~]# kubectl get nodes
Unable to connect to the server: x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")

# 如果报错，需要将master的admin.conf拷贝过来
# master执行
scp /etc/kubernetes/admin.conf root@local3:/etc/kubernetes/

# 然后在node执行下面三步
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

再次在node查看
[root@local3 ~]# kubectl get nodes
NAME     STATUS   ROLES    AGE     VERSION
local1   Ready    master   6m36s   v1.18.0
local2   Ready    <none>   31s     v1.18.0
local3   Ready    <none>   5m43s   v1.18.0
```
   * 11、如果节点出错，可以移除节点
```bash
kubeadm reset   # 重置节点

kubectl delete node node-1 # 删除节点，删除后 数据就从etcd中清除了(可运行kubectl的任一节点中执行)
```
   * 12、如果加入节点时，token过期，可以重新生成
```text
查看token
kubeadm token list

默认生成的token有效期是一天，生成永不过期的token
[root@k8s-master ~]# kubeadm token create --ttl 0
W0501 09:14:13.887115   38074 validation.go:28] Cannot validate kube-proxy config - no validator is available
W0501 09:14:13.887344   38074 validation.go:28] Cannot validate kubelet config - no validator is available

创建token
[root@k8s-master ~]# openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
# token
4dc852fb46813f5b1840f06578ba01283c1a12748419ba8f25ce2788419ab1c2   

在worker节点执行join
kubeadm join 192.168.0.104:6443 --token vahjcu.rhm7864v6l400188 --discovery-token-ca-cert-hash sha256:4dc852fb46813f5b1840f06578ba01283c1a12748419ba8f25ce2788419ab1c2
```

* 使用yaml文档部署应用
   * nginx副本集部署deployment
```
apiVersion: apps/v1 #k8s版本号
kind: Deployment #部署类型（资源类型）
metadata: #元数据(用于定义资源信息)
  name: nginx-deployment-tony5 #资源名称
  labels: #资源标签(版本号)
    app: nginx 
spec: #资源相关信息规范
  replicas: 3 #副本数
  selector: #选择哪一个版本
    matchLabels:
      app: nginx
  template: #模板
    metadata: #资源的元数据/属性
      labels: #设置资源的标签
        app: nginx
    spec: #资源规范字段(规范容器配置)
      containers: #指定容器
      - name: nginx #容器名称
        image: nginx #容器使用的镜像
        ports: #端口号
        - containerPort: 80 #容器对应的端口号
```
   * nginx暴露service
```
apiVersion: v1 # 指定api版本，此值必须在kubectl api-versions中
kind: Service # 指定创建资源的角色/类型
metadata: # 资源的元数据/属性
  name: service-tony # 资源的名字，在同一个namespace中必须唯一
  namespace: default # 部署在哪个namespace中
  labels: # 设定资源的标签
    app: demo
spec: # 资源规范字段
  type: NodePort # ClusterIP 类型
  ports:
    - port: 8080 # service 端口
      targetPort: 80 # 容器暴露的端口
      protocol: TCP # 协议
      name: http # 端口名称
  selector: # 选择器(选择什么资源进行发布给外界进行访问：pod deployment 等等资源)
    app: nginx
```

> 使用K8s
~~~shell
# 启用k8s失败时; windows设置:可参考[Aliyun-Istio]; 先更新 www.docker.com/products/docker-desktop
# > $env:DOCKER_HOST="tcp://0.0.0.0:2375"   # 设置Windows环境变量 PowerShell [cli连接Docker-Server端TCP地址]
# > $env:KUBECONFIG="C:\Users\Administrator\.kube\config" 启动docker后, 签出k8s相对应的git版本,如下:
# > git clone https://github.com/AliyunContainerService/k8s-for-docker-desktop.git && git checkout v1.15.5
# > .\load_images.ps1 #<< registry.cn-hangzhou.aliyuncs.com/google_containers/... 下载k8s镜像资源,如下:
# >> k8s.gcr.io/kube-proxy,kube-scheduler,kube-controller-manager,kube-apiserver,coredns,etcd,pause
# > rm -rf C:/ProgramData/DockerDesktop/pki/ C:/Users/Administrator/.kube/config 删除临时文件;重启后会自动再生成conf
# >> Docker\Resources\Network >DNS: 8.8.8.8 ;Restart Docker Desktop ;Enable Kubernetes v1.15.5 设置&重启docker.

# 安装 kubectl client
$ curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubectl 
$ sudo chmod +x kubectl && sudo mv kubectl /usr/local/bin/
# 部署管理程序 kubernetes dashboard
$ kd=https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
$ kubectl apply -f $kd
# 编排web应用 kubernetes deployment
$ docker-compose build && kubectl apply -f /path/to/kube-deployment.yml  # 1 deploy of apply config
$ docker stack deploy -c /path/to/docker-compose.yml mystack             # 2 deploy stack with compose

# 查看集群
$ kubectl cluster-info
# 查看节点[IP&状态等]
$ kubectl get nodes
# 查看事件
$ kubectl get events
# 查看已创建pod
$ kubectl get pods
$ kubectl get pods -l app=nginx #根据label筛选pods
$ kubectl get pods -n nuclio    #根据namespace筛选pods
# 查看应用部署详情
$ kubectl get deployments  &&  kubectl get deployment -n test
# 查看pod详情
$ kubectl describe pods redis
$ kubectl get pods nginx -o yaml
# 查看secret
$ kubectl get secret
# 查看services
$ kubectl get services
# 查看namespace
$ kubectl get namespace
# 创建service,pod...
$ kubectl create -f development.yaml  #创建Pods[使用yaml创建]
$ kubectl run nginx --image=nginx --port=8080
$ kubectl replace -f development      #更新Pods
$ kubectl replace --force -f development #[--force强制更新]
$ kubectl delete deploy/nginx -n test #删除Pods [-n代表namespace] 删除副本deployment.yaml
$ kubectl get deployment -n test  &&  kubectl delete deployment nginx2 -n test
$ kubectl delete -f development       # a pod --force
$ kubectl delete pods nginx           # a pod name
$ kubectl delete --all pods -n nginx  # all pods in a namespace
$ kubectl logs $pods_name -n test      #查看日志[-n代表namespace]
$ kubectl exec $pods_name -it -n test -- /bin/sh #执行Pods -pods/service describe
# kubectl describe pod/$pods_name -n test
# kubectl describe deploy/$deploy_name -n test
# kubectl describe service/$service_name -n test
~~~
> `k8s`扩展<br>
  　[istio](https://istio.io/docs/setup/kubernetes/platform-setup/)：连接、安全、控制和观察服务

## [**Minikube**](https://github.com/kubernetes/minikube)

> [`Minikube`搭建本地`k8s`集群](https://minikube.sigs.k8s.io/docs/start/linux/)、[中文文档](http://docs.kubernetes.org.cn/109.html)<br>
  　[nuclio](https://nuclio.io)：高性能(serverless)事件微服务和数据处理平台(结合MQ,Kafka,DB)
~~~bash
# 安装 minikube
$ sudo apt install socat cpu-checker -y
$ curl -LO https://github.com/kubernetes/minikube/releases/download/v1.7.1/minikube-linux-amd64
$ sudo install minikube-linux-amd64 /usr/local/bin/minikube 
# 1 #安装<推荐方式>使用阿里下载minikube
$ curl -Lo minikube http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v1.3.0/minikube-linux-amd64
$ sudo chmod +x minikube && sudo mv minikube /usr/local/bin/

# 安装虚拟机kvm | https://help.ubuntu.com/community/KVM/Installation
$ kvm-ok && uname -m  #INFO: /dev/kvm exists; x86_64;Ubuntu需升级^18.10 > sudo do-release-upgrade -d
$ sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients libvirt-bin bridge-utils #依赖<ubuntu>
$ curl -LO https://github.com/kubernetes/minikube/releases/download/v1.7.1/docker-machine-driver-kvm2
$ sudo adduser `id -un` libvirt        #添加当前用户到组libvirt
$ sudo chown root:libvirt /dev/kvm     #改变目录kvm的组 (如> ll /dev/kvm ;返回root属主)
$ rmmod kvm && modprobe -a kvm         #跳过ERR: Module kvm is in use by: kvmgt kvm_intel
$ sudo apt-get install virt-manager    #可选,安装virt管理应用程序
$ sudo install docker-machine-driver-kvm2 /usr/local/bin/ #安装kvm2
$ libvirtd -d && sudo systemctl start virtlogd.socket #启动kvm2相关服务
# #常用kvm命令
$ cat /var/lib/libvirt/dnsmasq/virbr1.status #通过kvm创建虚拟机的minikube文件记录对应的ip信息等
$ virsh list --all                 #查询安装的虚拟机
$ virsh edit minikube   #配置虚拟机minikube 配置文件
$ virsh setmem minikube 1048576 #设置虚拟机内存限制1G
$ virsh setmaxmem minikube 4194304
$ virsh start minikube  #启动已创建的虚拟机
$ virsh suspend|resume minikube #暂停|恢复

# 启动 minikube 集群
$ sudo minikube config set vm-driver virtualbox #默认虚拟机(virtualbox|kvm2)推荐kvm2
$ sudo minikube config set memory 4096          #默认内存限制4G(default:2GB-RAM)
$ minikube start --vm-driver=virtualbox #Starting local Kubernetes cluster...Starting VM...Downloading
    #下载~/.minikube/cache/iso/minikube-v1.3.0.iso < https://storage.googleapis.com/minikube/iso/minikube-v1.3.0.iso
$ sudo minikube start --vm-driver=kvm2          #启动+代理;可选--registry-mirror=https://registry.docker-cn.com
  --docker-env HTTP_PROXY=http://f1361db2.m.daocloud.io --docker-env HTTPS_PROXY=http://f1361db2.m.daocloud.io
# 2 #启动<推荐方式>使用阿里镜像 https://registry.cn-hangzhou.aliyuncs.com 当使用阿里下载minikube
$ sudo minikube delete && sudo rm -rf ~/.minikube/machines/minikube && sudo chown `id -un`:`id -un`~/.minikube ~/.kube -R 
$ minikube start --vm-driver=kvm2 --cpus=4 --memory=4096 #推荐kvm2 +限制cpu&memory +日志级别--v=7|3|2|1|0

# #启动 第n个集群
$ sudo minikube start -p <name> --vm-driver=kvm2  #创建1个新的VM<name>
$ sudo minikube delete -p minikube          #删除已存在的VM<name=minikube>
# #然后，在集群中运行一个容器服务<hello-minikube>
$ sudo kubectl run hello-minikube --image=k8s.gcr.io/echoserver:1.4 --port=8080
$ #然后，使该服务节点为外部提供服务，并支持浏览器访问。
$ sudo kubectl expose deployment hello-minikube --type=NodePort
$ sudo minikube service hello-minikube
# 打开 Kubernetes 仪表盘
$ sudo minikube dashboard
# 执行 Kubernetes 命令
$ sudo minikube ssh -- [+执行的命令+]
# 停止本地集群服务
$ sudo minikube stop|delete
~~~
~~~bash
# 下载 Nuclio 源码
$ mkdir -p $GOPATH/src/github.com/nuclio/nuclio
$ git clone --depth=1 https://github.com/nuclio/nuclio.git $GOPATH/src/github.com/nuclio/nuclio
$ cd $GOPATH/src/github.com/nuclio/nuclio/hack
# 添加 RBAC (Role-Based Access Control, 基于角色的访问控制) (下面的 *.yaml 可设为下载的源码中的对应文件)
$ sudo kubectl apply -f minikube/resources/kubedns-rbac.yaml
# 在Minikube中引入一个Docker注册表(运行容器registry:2)
$ sudo minikube ssh -- docker run -d -p 5000:5000 registry:2
# 创建 Nuclio 命名空间
$ sudo kubectl create namespace nuclio
# 创建 RBAC Nuclio Role
$ sudo kubectl apply -f k8s/resources/nuclio-rbac.yaml
# 部署 Nuclio 到集群(运行容器quay.io/nuclio/{controller,dashboard};即部署nuclio控制器和仪表板以及其他资源)
$ sudo kubectl delete --all pods --namespace nuclio   #可选,用于重建nuclio(当部署失败时)
$ docker pull quay.io/nuclio/controller:1.1.10-amd64  #可选,拉取镜像nuclio.yaml(controller&dashboard)
$ docker pull quay.io/nuclio/dashboard:1.1.10-amd64
$ sudo kubectl apply -f k8s/resources/nuclio.yaml
# 验证 控制器(controller)和仪表板(dashboard)正在运行
$ sudo kubectl get pods -n nuclio
$ sudo kubectl describe pods -n nuclio
# 转发 Nuclio 仪表板的端口至本机（要使用仪表板，首先要将其服务端口8070转发到本地IP地址）
$ sudo kubectl port-forward -n nuclio $(sudo kubectl get pods -n nuclio -l nuclio.io/app=dashboard -o jsonpath='{.items[0].metadata.name}') 8070:8070
# 启动一个 Nuclio QuickStart Docker 容器 (可选镜像源nuclio/dashboard:1.1.10-amd64)
$ sudo docker run --name nucliodm -itd -p 8070:8070 
  -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp quay.io/nuclio/dashboard:1.1.10-amd64
# 进入 Nuclio Container
$ sudo docker exec -it nucliodm /bin/sh  # docker attach [容器]
# 查看minikube集群中的容器列表
$ sudo minikube ssh -- docker ps
# 处理端口占用问题? [preflight] Some fatal errors occurred: [ERROR Port-10250]: Port 10250 is in use
$ sudo kubeadm reset #[重置]
~~~

## [**Consul**](https://hub.docker.com/_/consul)

> [`Consul`](https://www.consul.io) 是[HashiCorp](https://www.hashicorp.com)开源的一个使用go语言开发的服务发现、配置管理中心服务。<br>
  　[`Docker`+`Consul`+`Nginx`](https://www.jianshu.com/p/9976e874c099)基于nginx和consul构建高可用及自动发现的docker服务架构。Consul集群中的每个主机都运行Consul代理，与Docker守护程序一起运行。每个群集在服务器模式下至少有一个代理，通常为3到5个以实现高可用性。在给定主机上运行的应用程序仅使用其HTTP-API或DNS-API与其本地Consul代理进行通信。主机上的服务也要向本地Consul代理进行注册，该代理将信息与Consul服务器同步。多个HTTP应用程序与Consul的服务发现功能深入集成，并允许应用程序在没有任何中间代理的情况下定位服务并平衡负载 [`查看安装说明`](https://hub.docker.com/_/consul)、[`参数`/`开发模式`](https://www.consul.io/docs/agent/options.html#_dev)、[`API`](https://www.consul.io/docs/agent/http/agent.html)
~~~shell
  ######Docker容器######
  # /consul/data   容器暴露VOLUME(用于持久化存储集群的数据的目录)
    # 对于客户端代理，存储有关集群的一些信息以及客户端的运行状况检查，以防重新启动容器。
    # 对于服务器代理，存储客户端信息以及与一致性算法相关的快照和数据以及Consul的KV存储和目录等。
    # 对于开发模式无用 ( -dev 非生产环境模式下，不会持久化任何状态)
  # /consul/config 配置目录(数据中心的服务配置文件*.json)
    # Consul在Docker中(--net=host)运行，因此在配置Consul的IP地址时需要注意：Consul具有集群地址+客户端地址的概念。
    # Consul群集地址是其他代理可以联系给定代理的地址：
      # -bind{Server群集地址}=<external-ip> 告诉Consul启动时其群集通讯地址
      # -client{客户端地址}=<external-ip> 告诉其它应用程序联系Consul以发出HTTP或DNS请求的地址
      # -e CONSUL_CLIENT_INTERFACE 或 CONSUL_BIND_INTERFACE 用于设置接口名称(一个群集通讯实用程序)

  # 试用 Consul 不指定任何参数
  > docker run -d --name dev-consul-n0 -p 8500:8500 -e CONSUL_BIND_INTERFACE=eth0 consul
  > docker exec -t dev-consul-n0 consul info    # 查看Consul集群的基本信息 www.consul.io/docs/commands/info.html
  > docker exec -t dev-consul-n0 consul members # 查询Consul集群中的所有成员
  > docker exec -it dev-consul-0 sh  # 进入集群Docker主机中执行Shell命令
  
  # 在[开发模式]下运行 Consul Agent 容器将为您提供处于开发模式的Consul服务器，开发服务器在桥接网络上运行多个实例很有用
  > consul agent -dev -datacenter dc1 -node n1 # 单机测试Consul+非Docker运行+启动WebUI服务 http://127.0.0.1:8500/ui
  > docker run -d --name dev-consul-n1 -p 8500:8500 -e CONSUL_BIND_INTERFACE=eth0 consul agent -dev -ui -join=172.17.0.*
      # 查找IP用于参数-join: docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" <docker-name>

  # 在[服务器模式]下运行 Consul Agent
  > docker run -d --net=host consul agent -server -bind=172.17.0.* # 将代理暴露给宿主机(桥接网络)
      -retry-join=<root agent ip> # 指定集群中用于在启动时加入的另一个代理的外部IP(搭建集群数据中心网络)
      -bootstrap-expect=<number of server agents> # 指定集群启动时需要的节点数(多个Server节点选举raft-leader)
      -bootstrap  # 或者指定当前数据中心(单个Server节点为raft-leader)的模式(bootstrap mode)不能与上面参数同时使用。
  # 在[客户端模式]下运行 Consul Agent
  > docker run -d --net=host consul agent 
      -client=<bridge ip> # 客户端访问(默认127.0.0.1)通过(桥接网络)将接口暴露给其他容器(指定0.0.0.0绑定所有ip)
      -bind=<external ip> # 将代理暴露给宿主机上运行的其它应用程序(当主机上其他容器在使用 --net=host 时可用)
      -retry-join=<root agent ip> # 参考如下：
        # Using DNS > consul agent -retry-join "consul.domain.internal"
        # Using IPv4 > consul agent -retry-join "10.0.4.67"
        # Using IPv6 > consul agent -retry-join "[::1]:8301"
        # Using Cloud Auto-Joining > consul agent -retry-join "provider=aws tag_key=..."
  
  # 在端口53上公开Consul的DNS服务器 https://www.consul.io/docs/agent/services.html
  > docker run -d --net=host -e "CONSUL_ALLOW_PRIVILEGED_PORTS=" consul -dns-port=53 -recursor=8.8.8.8 -bind=<bridge-ip>
  > docker run -it --dns=<bridge-ip> ubuntu sh -c "apt-get update && apt-get install -y dnsutils && dig consul.service.consul"
  # 使用容器进行服务发现，有关详细信息，请参阅API  www.consul.io/docs/agent/http/agent.html
  # 在Docker容器中运行Consul检查(如果Docker守护程序暴露给Consul代理+环境变量DOCKER_HOST，则可以使用容器ID配置检查)
~~~
![](https://github.com/angenalZZZ/doc/blob/master/screenshots/a107560a.png)
~~~bash
  ######Consul命令行######
  $ consul [command] --help
  $ consul catalog nodes   # 节点列表+Node+ID+Address+DC... (DC: 数据中心,即节点归属)
  $ consul members            # 节点列表+Status +Type+Protocol+Segment+更多... (Status: alive表示节点健康)
  $ consul kv put config/api/request_limit 2000  # 添加数据
  $ consul kv get config/api/request_limit             # 查询数据
  $ consul kv delete config/api/request_limit      # 删除数据
  $ consul intention check|create|delete api postgresql   # 检查|创建|删除-微服务api
  > curl http://localhost:8500/v1/health/service/consul?pretty  # 集群Node+Service+Checks健康状况 (Status: passing正常,warning,fail...)
  $ consul leave -http-addr=127.0.0.1:8500           # 使节点优雅的移除所在集群dc1
  ######单机运行Consul######
  $ consul agent -dev -ui -datacenter=dc1 -node=n1 -http-port=8500  # 启动WebUI服务 http://127.0.0.1:8500/ui
  ######虚拟机搭建Consul集群######
  $ consul agent -data-dir /tmp/node0 -node=node0 -bind=192.168.11.143  # node0机器
      -datacenter=dc1 -ui -client=192.168.11.143 -server -bootstrap-expect 1
  $ consul agent -data-dir /tmp/node1 -node=node1 -bind=192.168.11.144  # node1机器，不开启远程访问-client
      -datacenter=dc1 -ui
  $ consul agent -data-dir /tmp/node2 -node=node2 -bind=192.168.11.145  # node2机器
      -datacenter=dc1 -ui -client=192.168.11.145
  $ consul join 192.168.11.143                                                                    # 将node1节点加入到node0上  (node1上执行)
  $ consul join -rpc-addr=192.168.11.145:8400  192.168.11.143  # 将node2节点加入到node0上  (node2上执行)
  $ consul members -rpc-addr=192.168.11.143:8400                       # 查看当前集群节点  (在node1上执行, node0上运行该命令)
      # 需要加-rpc-addr 选项，原因是-client 指定了客户端接口的绑定地址，包括：HTTP、DNS、RPC，
      # 而 consul join 、consul members 都是通过RPC与Consul交互 (即指定了 -client 绑定`RPC`的, 需要加 -rpc-addr 才可执行)
  
~~~

## [**Etcd**](https://github.com/etcd-io/etcd)

> [`etcd`](https://coreos.com/etcd/docs/latest/demo.html) 分布式、可靠的KV存储，用于分布式系统中共享配置和服务发现。 [`install`](https://www.jianshu.com/p/e892997b387b)  [`download`](https://github.com/etcd-io/etcd/releases)  [`play...`](http://play.etcd.io/install)
 * 简单: 良好定义的HTTP接口，面向用户的API(gRPC)，易理解；👍支持消息发布与订阅；

 * 安全: 支持SSL客户端安全认证；数据持久化(默认数据更新就进行持久化)；

 * 快速: 每秒1w/qps；版本高速迭代和开发中，这既是一个优点，也是一个缺点；

 * 可靠: 使用Raft一致性算法来管理高可用复制(分布式存储)

![](https://github.com/angenalZZZ/doc/blob/master/screenshots/EtcdVer.png)
![](https://github.com/angenalZZZ/doc/blob/master/screenshots/EtcdDesign.png)

~~~shell
# 版本: 默认API版本为2(修改参数ETCDCTL_API=3)；K8S v1.11 以后默认使用 Etcd v3 弃用 v2
# 端口: 默认2379为客户端通讯，2380进行服务器间通讯；
# <本地简单运行>----------------------------------------------------
 > nssm install EtcdServer etcd.exe --config-file etcd.conf.yml # 以管理员运行服务
 # 运行(客户端) > etcdctl [command]  # etcdctl和etcd交互,命令如下:
 # put[输入], get[输出--rev=1'取版本号1'], del[删除], watch[观察历史修订], compact[压缩修订版本]
 # lease grant 10 (1.授予租约>'TTL为10秒';返回[id]); put --lease=[id] [key] [value] (指定key授予租约)
 # lease revoke [id] (2.撤销租约>指定[id]>因租约撤销导致foo被删除)
 # lease keep-alive [id] (3.维持租约)
# <搭建本地集群>----------------------------------------------------
 $ go get github.com/mattn/goreman  # 提前安装Go,或下载可执行文件goreman
 $ goreman -f Procfile start        # 用到gitub项目根目录下的Procfile文件(需要修改)
 $ etcdctl -w="table" --endpoints=localhost:12379 member list # 查询集群信息
# <搭建docker运行>--------------------------------------------------
 $ sudo mkdir -p /etcd/data && sudo mkdir -p /etcd/ssl-certs-dir
 $ docker run --name etcd --network=bridge --network-alias=etcd --restart=always -p 2379:2379 -p 2380:2380 -e ETCDCTL_API=3 
    -v /etcd/data:/etcd-data -v /etcd/ssl-certs-dir:/etcd-ssl-certs-dir quay.io/coreos/etcd:v3.3.12 
    /usr/local/bin/etcd --name s1 --data-dir /etcd-data 
    --listen-client-urls http://0.0.0.0:2379 --advertise-client-urls http://0.0.0.0:2379 
    --listen-peer-urls http://0.0.0.0:2380 --initial-advertise-peer-urls http://0.0.0.0:2380 
    --initial-cluster s1=http://0.0.0.0:2380,s2=https://0.0.0.0:2381,s3=https://0.0.0.0:2382 # 安装http时取消,s2...s3
    --initial-cluster-token tkn --initial-cluster-state new                                  # 安装http时取消-下面语句
    --client-cert-auth --trusted-ca-file /etcd-ssl-certs-dir/etcd-root-ca.pem 
    --cert-file /etcd-ssl-certs-dir/s1.pem --key-file /etcd-ssl-certs-dir/s1-key.pem 
    --peer-client-cert-auth --peer-trusted-ca-file /etcd-ssl-certs-dir/etcd-root-ca.pem 
    --peer-cert-file /etcd-ssl-certs-dir/s1.pem --peer-key-file /etcd-ssl-certs-dir/s1-key.pem 
~~~

####  免费的容器镜像服务

> [阿里云`/fp-api/front`](https://cr.console.aliyun.com/repository/cn-hangzhou/fp-api/front/detail)

  1. 登录阿里云Docker Registry
~~~bash
  $ sudo docker login --username=angenal@hotmail.com registry.cn-hangzhou.aliyuncs.com
~~~
  2. 从Registry中拉取镜像
~~~bash
  $ sudo docker pull registry.cn-hangzhou.aliyuncs.com/fp-api/front:[镜像版本号]
~~~
  3. 将镜像推送到Registry
~~~bash
  # [ImageId]和[镜像版本号]参数(docker images 查询)
  # 　公网地址：registry.cn　经典内网：registry-internal.cn　专有网络：registry-vpc.cn
  $ sudo docker tag [ImageId] registry.cn-hangzhou.aliyuncs.com/fp-api/front:[镜像版本号]
  $ sudo docker push registry.cn-hangzhou.aliyuncs.com/fp-api/front:[镜像版本号]
~~~

#### 免费的开发服务器

> [转发服务`ngrok`](https://dashboard.ngrok.com/get-started)

~~~bash
  # 保存路径 C:/Windows/System32/ngrok.exe
  # 查看帮助
  > ngrok help
  # 配置认证账号 add your account's authtoken to your ngrok.yml file
  > ngrok authtoken 7pWLVhS1gxiMAQdaFeYJy_31krnw9drNLLJftaNSFnm
  # 开启转发服务
  > ngrok http 80                    # secure public URL for port 80 web server
    ngrok http -subdomain=baz 8080   # port 8080 available at baz.ngrok.io
    ngrok http foo.dev:80            # tunnel to host:port instead of localhost
    ngrok tcp 22                     # tunnel arbitrary TCP traffic to port 22
    ngrok tls -hostname=foo.com 443  # TLS traffic for foo.com to port 443
    ngrok start foo bar baz          # start tunnels from the configuration file
~~~

