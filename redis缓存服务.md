
# **[`Redis`](http://redis.cn) - [`Remote Dictionary Service`](http://redis.io)** 
  [Redis中文网](http://www.redis.cn/)

> [`安装`](https://github.com/angenalZZZ/doc/blob/master/cmd_bash_shell.md#redis)、[`配置`](#1配置Redis)、[`扩展模块`](https://redis.com/redis-enterprise-software/download-center/modules/)、[`查询服务信息`](#2查询服务信息)、[`基础数据结构`](#3基础数据结构)、[`命令`](http://doc.redisfans.com)、[`教程`](http://www.runoob.com/redis/redis-tutorial.html)<br>
> [`RedisDesktopManager`](https://github.com/lework/RedisDesktopManager-Windows)、[AnotherRedisDesktopManager](https://gitee.com/qishibo/AnotherRedisDesktopManager/releases)

[`Redis`](https://redis.io/)
~~~
mac    > brew install redis 
ubuntu > apt-get install redis ; http://download.redis.io/releases/redis-5.0.14.tar.gz redis-6.0.16.tar.gz
centos > yum install redis #(redhat)
windows> https://github.com/tporadowski/redis/releases ; https://github.com/MicrosoftArchive/redis/releases 
docker > docker pull redis ; docker run --name redis-server -d -p6379:6379 redis ; docker exec -it redis-server redis-cli 
~~~

[`Redis Stack`](https://redis.io/download/)as json document, graph, time series. clients library: [`.NET`](https://redis.io/docs/stack/get-started/tutorials/stack-dotnet/)、[`Java`](https://redis.io/docs/stack/get-started/tutorials/stack-spring/)、[`Node.js`](https://redis.io/docs/stack/get-started/tutorials/stack-node/)

[`install.cmd` for windows](https://github.com/MicrosoftArchive/redis/releases)
~~~
@echo on
cd /d %~dp0
sc create Redis binPath= "\"%CD%\redis-server.exe\" --service-run \"%CD%\redis.windows-service.conf\"" DisplayName= "Redis" start= auto depend= TCPIP
sc description Redis "Redis Cache Service"
net start Redis
~~~
[安装](https://www.kancloud.cn/yami/mall4j/1250375)
~~~
#安装redis编译时依赖tcl
wget http://downloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz
tar xzf tcl8.6.8-src.tar.gz -C /usr/local/
cd /usr/local/tcl8.6.8/unix/
./configure
make && make install

#下载安装redis
wget http://download.redis.io/releases/redis-4.0.14.tar.gz
# wget http://download.redis.io/releases/redis-5.0.14.tar.gz
# wget http://download.redis.io/releases/redis-6.0.20.tar.gz
# wget http://download.redis.io/releases/redis-6.2.17.tar.gz
# wget http://download.redis.io/releases/redis-7.0.15.tar.gz
tar xzvf redis-6.2.17.tar.gz -C /usr/local/
cd  /usr/local/redis-6.2.17/
make && make test && make install
#配置开机启动
cp ./utils/redis_init_script /etc/init.d/
mv /etc/init.d/redis_init_script /etc/init.d/redis_6379
mkdir -p /etc/redis /var/redis/6379
cp ./redis.conf /etc/redis/
mv /etc/redis/redis.conf /etc/redis/6379.conf
#修改配置文件
vi /etc/redis/6379.conf
daemonize	yes				#让redis以daemon进程运行
port		6379			        #设置redis的监听端口号
pidfile		/var/run/redis_6379.pid 	#设置redis的pid文件位置
dir 		/var/redis/6379			#设置持久化文件的存储位置
#修改启动文件
cd /etc/init.d
vi redis_6379 # 文件顶部加入以下两行注释
# chkconfig:   2345 90 10
# description:  Redis is a persistent key-value database
#启用开机启动
chkconfig redis_6379 on
#添加执行权限
chmod 777 redis_6379
#启动服务
./redis_6379 start
#使用客户端
redis-cli SHUTDOWN # 连接本机的6379端口停止redis进程
redis-cli -h 127.0.0.1 -p 6379 SHUTDOWN # 制定要连接的ip和端口号
redis-cli PING # ping redis的端口，看是否正常
redis-cli # 进入交互式命令行
~~~
~~~
# 更新Centos内核
yum update -y kernel
yum install -y kernel-headers kernel-devel gcc make
init 6  # 重启系统
# 关闭防火器
systemctl disable firewalld && systemctl stop firewalld
# 同步时间问题
yum install -y ntpdate
ntpdate time.windows.com
#ntpdate cn.pool.ntp.org
# 修改默认配置，开启IPv6[系统默认未开启]，并优化内核TCP参数 
vi /usr/lib/sysctl.d/00-system.conf # 参考git文件: /k8s/usr/lib/sysctl.d/00-system.conf
# 修改open-files限制高并发数/etc/sysctl.conf # 参考git文件: /k8s/etc/sysctl.conf
# 使修改生效
sysctl -p
# 查看生效情况
sysctl --system
# 开始安装
ubuntu > 
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get install redis-stack-server
centos > 
cat > /etc/yum.repos.d/redis.repo <<EOF
[Redis]
name=Redis
baseurl=http://packages.redis.io/rpm/rhel7
enabled=1
gpgcheck=1
EOF
#curl -fsSL https://packages.redis.io/gpg > /tmp/redis.key
sudo rpm --import /tmp/redis.key
sudo yum install epel-release
sudo yum install redis-stack-server
# 修改配置
cat > /etc/redis-stack.conf <<EOF
bind 192.168.1.207
port 6379
timeout 0
daemonize yes
loadmodule /opt/redis-stack/lib/redisearch.so
loadmodule /opt/redis-stack/lib/redisgraph.so
loadmodule /opt/redis-stack/lib/redistimeseries.so
loadmodule /opt/redis-stack/lib/rejson.so
loadmodule /opt/redis-stack/lib/redisbloom.so
EOF
# 查安装结果
yum list installed|grep redis
# 设置为开机启动
systemctl enable redis-stack-server && systemctl start redis-stack-server
# 查看版本
redis-stack-server -v
~~~
> [`Redis Stack`](https://redis.io/download/#redis-stack-downloads) Centos7 手动安装
~~~shell
# 下载安装包
cd /media/ShareFolder/app/redis
wget https://packages.redis.io/redis-stack/redis-stack-server-6.2.4-v1.rhel7.x86_64.tar.gz
# 解压安装包
tar -xzf redis-stack-server-6.2.4-v1.rhel7.x86_64.tar.gz
mv redis-stack-server-6.2.4-v1 /opt/redis-stack
cd /opt/redis-stack
# 创建数据目录
mkdir -p data
# 修改端口号等
# vi etc/redis-stack.conf /opt/redis-stack/etc/redis-stack-service.conf
# bind 192.168.1.207
# port 16379
# timeout 0
# daemonize yes
# requirepass 123456 # 设置密码

# 手动启动(测试)
/opt/redis-stack/bin/redis-server /opt/redis-stack/etc/redis-stack-service.conf --dir /opt/redis-stack/data
# 退出程序 Ctrl+C 
# 创建系统用户(忽略)
# useradd --system --user-group --no-create-home redis
# chown -R redis:redis /opt/redis-stack

# 安装系统服务
# cp /media/ShareFolder/app/redis/redis-stack-server.service /usr/lib/systemd/system/redis-stack-server.service
cat > /usr/lib/systemd/system/redis-stack-server.service <<EOF
[Unit]
Description=Redis stack server
Documentation=https://redis.io/docs
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/bin/bash -c '/opt/redis-stack/bin/redis-server /opt/redis-stack/etc/redis-stack-service.conf --dir /opt/redis-stack/data --daemonize yes'
ExecStop=/bin/bash -c '/opt/redis-stack/bin/redis-cli shutdown'
PrivateTmp=true
Restart=always

[Install]
WantedBy=multi-user.target
EOF
# 重新加载系统配置
systemctl daemon-reload

# 查看启动的服务列表
systemctl list-unit-files | grep enabled
# 查看失败的服务列表
systemctl --failed
# 开机启动或禁用
systemctl is-enabled redis-stack-server
systemctl enable redis-stack-server
systemctl disable redis-stack-server
# 手动启动服务
systemctl start redis-stack-server
# 查看服务状态与日志
systemctl status redis-stack-server
# 防火墙配置
firewall-cmd --zone=public --add-port=6379/tcp --permanent
firewall-cmd --zone=public --add-port=16379/tcp --permanent
systemctl reload firewalld
# 卸载服务
systemctl stop redis-stack-server
rm -f /usr/lib/systemd/system/redis-stack-server.service
systemctl daemon-reload
rm -rf /opt/redis-stack

# 客户端命令Redis
redis-cli -h 192.168.1.207 -p 16379 # -a "123456"
> MODULE LIST # 查看加载的模块, 加载更多模块请访问 https://redis.io/docs/modules
> auth 123456 # 密码认证;再执行其它命令.
> exit
~~~

[`Redis`高性能内存数据库](http://www.redis.cn)
~~~shell
  $ sudo apt install -y build-essential pkg-config libssl-dev  # 准备编译环境
  $ cd /tmp
  $ wget http://download.redis.io/releases/redis-stable.tar.gz # 下载源码
  $ wget http://download.redis.io/releases/redis-5.0.14.tar.gz redis-6.0.16.tar.gz # 指定版本
  $ tar -xzf redis-*.tar.gz                                    # 解压源码
  $ cd redis-stable
  # sudo make MALLOC=libc BUILD_TLS=yes                        # 编译Redis同时启用TLS
  $ sudo make install                                          # 编译Redis未启用TLS
  $ cd utils && sudo ./install_server.sh                       # 自动安装Redis(推荐)
  $ rm -rf ~/redis-stable && rm -f ~/redis-stable.tar.gz       # 删除源码(安装后)
  # 手动安装Redis
  # sudo adduser --system --group --no-create-home redis       # 创建系统redis用户-不建主目录
  # cd /tmp/redis-stable/src
  # sudo cp redis-server redis-cli redis-benchmark redis-check-aof redis-check-rdb /usr/local/bin/
  # sudo ln -sf /usr/local/bin/redis-sentinel redis-server
  # sudo mkdir /var/lib/redis                                  # 创建数据目录
  # sudo chown -R redis:redis /var/lib/redis
  # sudo chmod 770 /var/lib/redis
  # sudo mkdir /var/log/redis                                  # 创建日志目录
  # sudo chown -R redis:redis /var/log/redis
  # sudo mkdir /var/run/redis                                  # 创建pid文件目录
  # sudo chown -R redis:redis /var/run/redis
  # sudo mkdir /etc/redis                                      # 创建配置文件目录
  # sudo chown -R redis:redis /etc/redis
  # sudo cp /tmp/redis-stable/redis.conf /etc/redis/
  # sudo vim /etc/systemd/system/redis.service                 # 创建 Redis service
~~~
> redis-server.service
~~~
[Unit]
Description=Redis server
Documentation=https://redis.io/docs
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/bin/redis-server /etc/redis/6379.conf
PIDFile=/var/run/redis/6379.pid
ExecStartPost=/bin/sh -c "echo $MAINPID > /var/run/redis/6379.pid"
TimeoutStartSec=5
TimeoutStopSec=5
Restart=always
User=redis
Group=redis

UMask=007
PrivateTmp=yes
LimitNOFILE=65535

ReadOnlyDirectories=/
ReadWritePaths=-/var/lib/redis
ReadWritePaths=-/var/log/redis
ReadWritePaths=-/var/run/redis

# redis-server can write to its own config file when in cluster mode so we
# permit writing there by default. If you are not using this feature, it is
# recommended that you replace the following lines with "ProtectSystem=full".
ProtectSystem=full
#ReadWriteDirectories=-/etc/redis

[Install]
WantedBy=multi-user.target
Alias=redis.service
~~~
> redis-stack-server.service
~~~
[Unit]
Description=Redis stack server
Documentation=https://redis.io/docs
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/bin/bash -c '/opt/redis-stack/bin/redis-server /opt/redis-stack/etc/redis-stack-service.conf --dir /opt/redis-stack/data --daemonize yes'
ExecStop=/bin/bash -c '/opt/redis-stack/bin/redis-cli shutdown'
PrivateTmp=true
Restart=always

[Install]
WantedBy=multi-user.target
~~~
~~~shell
  $ sudo cp /etc/redis/redis.conf /etc/redis/6379.conf
  #
  #-config>>  /etc/redis/6379.conf       # 修改配置文件
  # supervised systemd
  # daemonize yes
  # << bind 0.0.0.0                      # 允许远程连接
  # << requirepass "123456"              # 设置访问密码 <随机生成> openssl rand -base64 10
  # << protected-mode no                 # 关闭保护模式
  # dir /var/lib/redis/6379              # 数据目录6379
  # logfile "/var/log/redis/6379.log"    # 日志文件
  # pidfile "/var/run/redis/6379.pid"    # 进程文件
  #
  # Redis启用TLS
  #> sudo openssl req -x509 -nodes -newkey rsa:4096 -keyout /etc/redis/redis-server-key.pem -out /etc/redis/redis-server-cert.pem -days 3650 
  #
  # tls-cert-file /etc/redis/redis-server-cert.pem
  # tls-key-file /etc/redis/redis-server-key.pem
  # tls-ca-cert-file /etc/ssl/certs/ca-certificates.crt
  # tls-auth-clients no  # Disallow clients that don't use TLS.
  # port 0               # Disable non-TLS services.
  # tls-port 6379        # Enable TLS based service on default Redis port.
  #
  # Redis加载模块
  # cp /mnt/c/rejson.so /var/lib/redis/
  #> sudo chown -R redis:redis /var/lib/redis/rejson.so
  # 
  # loadmodule /var/lib/redis/rejson.so  # 编辑redis.conf
  #> redis-server --loadmodule /var/lib/redis/rejson.so # 先检测是否能正常加载
  #
  $ sudo systemctl restart redis-server  # 重启服务(先保存配置文件6379.conf)
  $ sudo systemctl status redis-server   # 查看状态
  #
  $ ps aux|grep redis                    # 查看进程: /usr/local/bin/redis-server 127.0.0.1:6379
  $ redis-server                         # (可选)启动服务(独立模式|常规启动), 可通过 ps aux 查看进程
  # redis-server /etc/redis/6379.conf    # (可选)启动服务(指定配置文件)
  $ sudo service redis_6379 start        # (可选)启动服务(非独立模式|后台启动服务) start|stop|restart
  $ sudo update-rc.d redis_6379 defaults # (推荐)开机启动Redis将init脚本添加到所有默认运行级别(需stop后处理)
  > nssm install RedisWSLubuntu1804 bash.exe -c redis-server # 启动前设置Windows服务登录账户为Administrator
  # 客户端命令Redis
  $ redis-cli -h 127.0.0.1 -p 6379 -a "123456" -n 0 # [p端口],[a密码],[n数据库]
  $ redis-cli --tls --cacert /etc/redis/redis-server-cert.pem # 安全连接Redis(启用TLS时)
  $ redis-cli shutdown                   # 关闭Redis服务
  $ config set requirepass "123456"      # 设置访问密码
  $ auth 123456                          # 密码认证;再执行其它命令.
  # 性能测试Redis
  > redis-benchmark -h 127.0.0.1 -p 6369 -c 30 -d 512 -t set,get -n 1000000 -r 100000000 # SET: 64K, GET: 68K
  > redis-benchmark -n 10000 -q -c 30       # 本机Redis       < SET: 42K, GET: 50K > requests per second
  > buntdb-benchmark -n=10000 -q -r=30 -mem # 本机BuntDB(推荐) < SET:760K,GET:5000K > github.com/tidwall/buntdb
~~~

[`KeyDB` - The faster Redis Alternative](https://keydb.dev/)、[`快速搭建KeyDB集群`](https://docs.keydb.dev/docs/)
~~~
#ubuntu >>
$ echo "deb https://download.keydb.dev/open-source-dist $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/keydb.list
# echo "deb [trusted=yes] https://download.keydb.dev/open-source-dist $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/keydb.list
$ sudo wget -O /etc/apt/trusted.gpg.d/keydb.gpg https://download.keydb.dev/open-source-dist/keyring.gpg
$ sudo apt update
$ sudo apt upgrade # 升级apt(当update失败时)
# sudo apt update --allow-unauthenticated # 同上or同下(当update失败时)
# sudo apt -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true update
$ sudo apt install keydb           # keydb-server and keydb-tools
# sudo apt -o APT::Get::AllowUnauthenticated=true install keydb
$ sudo apt install keydb-sentinel  # run it as a service
$ sudo service keydb-server status # /lib/systemd/system/keydb-server.service
$ sudo service keydb-server start
$ sudo service keydb-server stop
$ sudo systemctl enable keydb-server # run on boot
# keydb config file: /etc/keydb/keydb.conf
# uninstall keydb:ubuntu
$ sudo apt autoremove --purge keydb keydb-server keydb-sentinel keydb-tools
$ sudo rm /etc/apt/sources.list.d/keydb.list

#centos7 >>
# yum install -y sudo
# su - centos
$ cd ~
$ rpm --import https://download.keydb.dev/pkg/open_source/rpm/RPM-GPG-KEY-keydb
$ wget https://download.keydb.dev/pkg/open_source/rpm/centos7/x86_64/keydb-latest-1.el7.x86_64.rpm
$ sudo yum install ./keydb-latest-1.el7.x86_64.rpm  # yum install -y sudo
$ yum info keydb
$ sudo service keydb status  # /lib/systemd/system/keydb.service
$ sudo service keydb start   # /lib/systemd/system/keydb-sentinel.service
$ sudo service keydb stop
$ sudo systemctl enable keydb  # run on boot
# usermod -aG keydb centos && groups centos # 添加centos普通用户的keydb用户组&&查询出来
# keydb config file: /etc/keydb/sentinel.conf
# uninstall keydb:centos
$ sudo yum remove keydb

#创建2个节点组成集群;
# cp /etc/keydb/keydb.conf /etc/keydb/16379.conf
# cp /etc/keydb/keydb.conf /etc/keydb/26379.conf
vi /etc/keydb/16379.conf # 设置>>
port 16379
replicaof 127.0.0.1 26379
masterauth 123456
requirepass 123456
active-replica yes
vi /etc/keydb/26379.conf # 设置>>
port 26379
requirepass 123456
active-replica yes
# chown keydb:keydb /etc/keydb/*.conf
#手动启动集群;
# keydb-server /etc/keydb/16379.conf
# keydb-server /etc/keydb/26379.conf
#查询集群状态;
> redis-cli -h 127.0.0.1 -p 26379 -a 123456 -n 0
> set k1 v1
> exit
> redis-cli -h 127.0.0.1 -p 16379 -a 123456 -n 0
> get k1
> exit
#使用Nginx负载均衡(redis端口:6379){"keydb":"localhost:6379,password=123456"};修改nginx.conf>
events {
  worker_connections 1024;
}
stream
{
  upstream keydb
  {
    server 192.168.1.10:16379;
    server 192.168.1.10:26379;
  }
  server
  {
    listen 127.0.0.1:6379;
    proxy_pass keydb;
    proxy_protocol off;
  }
}
#开机启动服务 https://github.com/ochinchina/supervisord
~~~

####  1.配置Redis 
  * > 非集群 普通模式
~~~
# 配置文件路径: /etc/redis/6379.conf
--------------------------------------------------------------------
# ***限制redis只能本地访问***
  bind 127.0.0.1 ::1 # bind 192.168.1.100 10.0.0.1 # 不限制本地访问,需要指定外网RemoteIP
# ***指定访问端口号***
  port 6379
  protected-mode yes # 仅接受从 127.0.0.1, ::1 连接的客户机，特别是未配置密码时
  tcp-keepalive 300  # TCP保持连接时长。在Linux上，指定用于发送ACK确认心跳的时长（秒）
  tcp-backlog 511    # 在每秒请求数较高的环境中，指定 tcp_max_syn_backlog 可以获得所需的效果
  timeout 0      # 客户端空闲N秒后关闭连接; (默认)禁用关闭客户端连接
# ***守护进程的方式启动***
  daemonize yes  # 默认情况下，Redis不作为守护进程运行。Redis将在后台监控时写入一个pid文件。
  supervised no  # 在Linux上，如果您从upstart或systemd运行Redis
  pidfile /var/run/redis_6379.pid  # 启动时写入pid，退出时删除。当指定了 daemonize yes 时。
# ***日志跟踪级别***
  loglevel notice # warning, error
# ***日志跟踪文件***
  logfile "/var/log/redis_6379.log"
# ***限制客户端连接数***
  maxclients 100
# ***限制内存上限***
  maxmemory 200mb
# ***当超过内存上限时，指定删除策略***
  maxmemory-policy noeviction # (默认)不删除未过期的Key
# ***设置密码***
  requirepass 123456
# ***数据持久化到本地磁盘*** AOF and RDB 两种持久化模式
  appendonly yes # (默认)no不持久化;
# ***数据持久化路径: /data/appendonly.aof
  appendfilename "appendonly.aof"
# save <seconds> <changes>  # Save the Real DB on disk:
  save 900 1
  save 300 10
  save 60 10000
  rdbcompression yes
  rdbchecksum yes
  dbfilename dump.rdb
  # dir ./
# The working directory.
  dir /var/lib/redis/6379

################# REPLICATION #################
#
#   +------------------+      +---------------+
#   |      Master      | ---> |    Replica    |
#   | (receive writes) |      |  (exact copy) |
#   +------------------+      +---------------+
#
# slaveof <masterip> <masterport>
# masterauth <master-password>
##Redis主从复制的作用
# 第一点是数据冗余了，实现了数据的热备份，是持久化之外的另一种方式。
# 第二点是针对单机故障问题。当主节点也就是master出现问题时，可以由从节点来提供服务也就是slave，实现了快速恢复故障，也就是服务冗余。
# 第三点是读写分离，master服务器主要是写，slave主要用来读数据，可以提高服务器的负载能力。同时可以根据需求的变化，添加从节点的数量。
# 第四点是负载均衡，配合读写分离，有主节点提供写服务，从节点提供读服务，分担服务器负载，尤其在写少读多的情况下，通过多个从节点分担读负载，可以大大提高redis服务器的并发量和负载。
# 第五点是高可用的基石，主从复制是哨兵和集群能够实施的基础，因此我们可以说主从复制是高可用的基石。
~~~
  * > 集群 普通主从模式
    提供了复制（replication）功能，能较好地避免单独故障问题，以及提出了读写分离，降低了Master节点的压力。
    数据库分为两类，一类是主数据库（master），另一类是从数据库（slave）。
    主数据库可以进行读写操作，当写操作导致数据变化时会自动将数据同步给从数据库。
~~~
redis-server --port <slavePort> --slaveof <masterIp> <masterPort>
~~~
  * > 集群 哨兵模式(全量存储，即每台redis存储相同的内容，比较消耗内存资源)
    高可用架构：当主数据库遇到异常中断服务后，开发者可以通过手动的方式选择一个从数据库来升格为主数据库，以使得系统能够继续提供服务。
    Redis 2.8 开始提供哨兵工具实现自动化的系统监控和故障恢复。
    (1)监控主数据库和从数据库是否正常运行。
    (2)主数据库出现故障时自动将从数据库转换为主数据库。
~~~
redis-server --port 6379
redis-server --port 6380 --slaveof 192.168.1.8 6379
redis-server --port 6381 --slaveof 192.168.1.8 6379
#->config(sentinel.conf): 
  sentinel monitor mymaster 192.168.1.8 6379 1
~~~
  * > [集群 cluster架构](https://redis.io/topics/cluster-tutorial)(分布式存储，即每台redis存储不同的内容，最大化利用内存)
    高可用架构：最小配置为三主三从的redis-cluster架构，
    其中A、B、C节点都是redis-master节点，A1、B1、C1节点都是对应的redis-slave节点。
~~~
#->config(/etc/redis/redis.conf): 
  port 7000
  daemonize yes                   # 后台运行
  cluster-enabled yes             # 启用集群
  cluster-config-file nodes.conf  # 集群nodes配置
  cluster-node-timeout 5000       # 配置集群节点的超时时间，主节点超过指定的时间不可达进行故障切换
  cluster-slave-validity-factor 0 # 如果设置为0，无论主设备和从设备之间的链路保持断开连接的时间长短，从设备都将尝试故障切换主设备；
    # 如果该值为正值，则计算最大断开时间作为节点超时值乘以此选项提供的系数，如果该节点是从节点，
    # 否则，在主链路断开连接的时间超过指定的超时值时，它不会尝试启动故障切换。
  cluster-migration-barrier 1     # 主设备将保持连接的最小从设备数量，以便另一个从设备迁移到不受任何从设备覆盖的主设备。
  cluster-require-full-coverage no
  readonly no                     # 选填，默认master节点可读写；#readonly yes 当启用slave节点读时；
  appendonly yes                  # 启动AOF增量持久化策略
  appendfsync always              # 发生改变就记录日志
~~~

####  2.查询服务信息
> [try redis-cli](http://try.redis.io)
> redis://user:pass@host:port/db
~~~
redis-cli -h 127.0.0.1 -p 6379 -a 123456 -n 0 # redis连接参数 [p端口],[a密码一般不填],[n数据库*默认0]
redis-cli -r 10000 RPUSH queue:myqueue '{"class":"MyClass","args":["hello","world"]}' #-<插入1万条记录进队列中>
openssl s_client -connect 127.0.0.1:6379 -cert test.crt -key test.key -CAfile ca.pem  #-Debug SSL
> info [all]                    # 获取所有信息
  # 1. Server 服务器运行的环境参数
  # 2. Clients 客户端相关信息
  # 3. Memory 服务器运行内存统计数据
  # 4. Persistence 持久化信息
  # 5. Stats 通用统计数据
  # 6. Replication 主从复制相关信息
  # 7. CPU CPU 使用情况
  # 8. Cluster 集群信息
  # 9. KeySpace 键值对统计数量信息
  
> info memory                   # 获取内存相关信息,内存分配mem_allocator:libc、tcmalloc(google)、jemalloc(facebook:默认:性能最佳)
> redis-cli info memory | grep used | grep human
  used_memory_human:827.46K     # 内存分配器 (jemalloc...) 从操作系统分配的内存总量
  used_memory_rss_human:3.61M   # 操作系统看到的内存占用 ,top 命令看到的内存
  used_memory_peak_human:29.41K # Redis 内存消耗的峰值
  used_memory_lua_human:37.00K  # lua 脚本引擎占用的内存大小
  # 如果单个 Redis 内存占用过大，并且在业务上没有太多压缩的空间的话，可以考虑集群化了。
  
> info replication              # 获取主从复制相关信息
> info replication | grep backlog
  repl_backlog_active:0
  repl_backlog_size:1048576     # 积压缓冲区大小
  # 复制积压缓冲区大小非常重要，它严重影响到主从复制的效率。当从库因为网络原因临时断开了主库的复制，然后网络恢复了，又重新连上的时候，
  # 这段断开的时间内发生在 master 上的修改操作指令都会放在积压缓冲区中，这样从库可以通过积压缓冲区恢复中断的主从同步过程。
  # 积压缓冲区是环形的，后来的指令会覆盖掉前面的内容。如果从库断开的时间过长，或者缓冲区的大小设置的太小，
  # 都会导致从库无法快速恢复中断的主从同步过程，因为中间的修改指令被覆盖掉了。这时候从库就会进行全量同步模式，非常耗费 CPU 和网络资源。
  
> redis-cli info stats | grep sync
  sync_full:0
  sync_partial_ok:0
  sync_partial_err:0            # 半同步失败次数
  # 通过查看sync_partial_err变量来决定是否需要扩大积压缓冲区，它表示主从半同步复制失败的次数。

> info clients                  # 客户端相关信息, 如:connected_clients(正在连接的客户端数量);
> info client list              # 列出所有的客户端链接地址
> info stats | grep reject
  rejected_connections(超出最大连接数限制而被拒绝的客户端连接次数)数字很大，意味着服务器的最大连接数设置过低，需要调整 maxclients 参数。

# 客户端与Redis建立连接后会自动选择0号数据库，不过可以随时使用SELECT命令更换数据库
> select 1  # 选择1号数据库
> keys *    # 查询所有key(慎用)~下面eval~开始生成测试数据~
> eval "for index = 0,100000 do redis.call('SET', 'test_key' .. index, index) end" 0
> eval "for index = 0,100000 do redis.call('SET', 'test_key:' .. math.random(1, 100) .. ':' .. math.random(1,100), index) end" 0
> eval "for index = 0,100000 do redis.call('HSET', 'test_large_hash', index, index) end" 0
> eval "for index = 0,100000 do redis.call('ZADD', 'test_large_zset', index, index) end" 0
> eval "for index = 0,100000 do redis.call('SADD', 'test_large_set', index) end" 0
> eval "for index = 0,100000 do redis.call('LPUSH', 'test_large_list', index) end" 0
> flushdb 1 # 清空数据库1
> flushall  # 清空一个Redis实例中所有数据库中的数据：Redis默认支持16个数据库（可以通过配置文件支持更多，无上限）
# 性能测试
> redis-benchmark -n 10000 -q
> info stats | grep ops  # 每秒操作数:instantaneous_ops_per_sec:***
> monitor               # 如果 qps 过高，快速观察究竟是哪些 key 访问比较频繁，从而在业务上进行优化，减少 IO 次数(执行后立即ctrl+c中断)
> debug object [key]   # 调试输出 key of object: { Value at: 指针地址, refcount: 引用计数, encoding: 数据类型, serializedlength..}
~~~

####  3.基础数据结构
> [Redis核心原理与应用实践](https://juejin.im/book/5afc2e5f6fb9a07a9b362527)

~~~
--------------------------------------------------------------------
#Redis-Db数据库结构体:             # 内存分配器 (jemalloc...) 从操作系统分配的内存总量
--------------------------------------------------------------------
struct RedisDb {
  dict* dicts;                    # 所有key集合 key=>value(快查hash函数,siphash算法,避免hash攻击...)
  dict* expires;                  # 过期key集合 key=>long (timestamp)
}
--------------------------------------------------------------------
#Redis-Object对象头结构体:         # 存储空间为16字节,公共基类
--------------------------------------------------------------------
struct RedisObject {
  int4 type;                      # 对象的不同类型4bits
  int4 encoding;                  # 存储编码形式4bits
  int24 lru;                      # LRU信息24bits
  int32 refcount;                 # 对象的引用计数(为零时对象就会被销毁)4bytes
  void *ptr;                      # 指针(引用SDS...指向对象内容存储位置)8bytes,64-bit-system
}
--------------------------------------------------------------------
#Redis-dict字典是Redis应用最为频繁的复合型数据结构:所有key集合,过期key集合,hash哈希,zset集合
--------------------------------------------------------------------
struct dict {
  dictht ht[2];                   # ht[0](old-hashtable) <渐进式rehash搬迁> ht[1](new-hashtable)
}
struct dictht {                   # hashtable结构(类似于Java的HashMap)，性能取决于hash函数siphash算法(hash偏向性小,生成key均匀,避免hash攻击)
  ...
  long size;                      # 第一维是数组,数组长度
  long used;                      # table链表中的元素个数
  dictEntry** table;              # 第二维是链表,dictEntry链表的第一个元素的指针
}
struct dictEntry {
  void* key;
  void* val;
  dictEntry* next;                # 链接下一个entry
}
--------------------------------------------------------------------

--------------------------------------------------------------------
1. string # 字符串（SDS带长度信息的字节数组Simple Dynamic String）
--------------------------------------------------------------------
struct SDS<T> {                   # T用作内存优化-结构分配:byte-short-int8-int
  T capacity;                     # 数组容量<=512M(当<1M时扩容加倍;超过1M时扩容+1M)
  T len;                          # 数组长度<=512M
  byte flags;                     # 特殊标识
  byte[] content;                 # 数组内容
}
--------------------------------------------------------------------
 > select 0                       # 查询db: 成功返回 +OK ; 异常返回 -ERR DB index is out of range
 > scan 0 MATCH * COUNT 100       # 查询keys: Array
 > set key value                  # 添加/修改 (value包含空格时添加“”)
 > get key                        # 获取数据: value
 > type key                       # 数据类型: +string ...
 > exists key                     # 是否存在: 成功返回1,失败返回0.
 > renamenx key key2              # 重命名: key to key2
 > del key                        # 删除: 成功返回1,失败返回0.
 > mset name1 value1 name2 value2 # 批量设置
 > mget name1 name2               # 批量获取
 > expire key 60                  # 过期: 60s
 > setex key 60 value             # 添加/过期: 60s
 > ttl key                        # 返回: 过期时间(秒)
 > setnx age 1                    # if age is not exists, set age = 1: 成功返回1,失败返回0.
 > incr age                       # 计数: += 1
 > incrby age 2                   # 计数: += 2
 
--------------------------------------------------------------------
2. list  # 列表 ziplist<T>(压缩列表)、
         # linkedlist(链表-节点间指针关联多会加剧内存碎片化-影响效率)、
         # quicklist(快速列表-改进结构用于代替前两者,是前两者的混合体,将linkedlist按段切分,每一段ziplist紧凑存储并用双向指针串接起来)
         # [内存: 元素少时ziplist压缩列表,元素多时quicklist快速列表,少用linkedlist]: 插入删除快Time=O(1),索引定位慢Time=O(n)
--------------------------------------------------------------------
struct ziplist<T> {               # 压缩列表: 元素个数较少，紧凑的数组结构，存储空间小；删除中间节点会导致级联更新，耗费计算资源。
  int32 zlbytes;                  # 占用字节数
  int32 zltail_offset;            # 最后一个元素距离起始位置的偏移量，用于快速定位
  int16 zllength;                 # 元素个数
  T[] entries;                    # 元素内容列表，紧凑存储结构
  int8 zlend;                     # 标志，压缩列表的结束，值恒定 0xFF
}
struct entry {                    # 压缩列表/元素内容列表/元素内容entry
  int<var> prelen;                # 前一个entry的字节长度
  int<var> encoding;              # 元素类型编码
  optional byte[] content;        # 元素内容
}

struct quicklist {                # 快速列表: 使用多个ziplist紧凑存储，ziplist之间用双向指针连起来；
  ...                             # 单个ziplist长度默认为8k字节,由配置list-max-ziplist-size决定[-1=4kb,-2=8kb..],超出就会新增一个ziplist
  quicklistNode* head;            # 首个元素
  quicklistNode* tail;            # 结尾元素
  long count;                     # 元素个数
  int nodes;                      # ziplist节点个数
  int compressDepth;              # LZF算法压缩深度，默认为0(不压缩),由配置list-compress-depth决定：0,1,2...
  ...                             # 为了支持快速push/pop操作,深度为1时首尾不压缩ziplist,深度为2时首尾第一二个都不压缩ziplist
}
struct quicklistNode {            # 快速列表quicklist的一个节点
  quicklistNode* prev;            # prev+next占16字节(因为64bit系统的指针是8个字节)
  quicklistNode* next;            # prev+next双向指针串接起来
  ziplist*       zl;              # 引用压缩列表ziplist
  int32 size;                     # ziplist占用字节数zlbytes
  int16 count;                    # ziplist元素个数zllength
  int2 encoding;                  # 判断是原生字节数组,还是LZF压缩存储,2bits
}
struct ziplist_compressed {       # 压缩列表,LZF压缩存储
  int32 size;
  byte[] compressed_data;         # 元素内容
}

struct listpack<T> {              # 紧凑列表: Redis 5.0 对ziplist结构改进,存储空间更小;不存在级联更新行为(元素独立),性能好,已用在Stream中
  int32 total_bytes;              # 占用字节数
  int16 size;                     # 元素个数
  T[] entries;                    # 紧凑排列的元素列表
  int8 end;                       # 标志，紧凑列表的结束，值恒定 0xFF
}
struct lpentry {                  # 紧凑列表的元素
  int<var> encoding;              # 编码可选择1|2|3|4|5个字节，同UTF8编码一样，通过字节最高位为1确定编码长度
  optional byte[] content;
  int<var> length;                # 用于计算长度（支持类型多，设计复杂）
}

--------------------------------------------------------------------
 > rpush books python java swift golang # 插入[右进左出/队列,右进右出/栈]: 成功返回4,失败返回0.
 > llen books                     # 列表长度: 成功返回4
 > lpop books                     # 取值快/队列: 成功返回python
 > rpop books                     # 取值快/栈: 成功返回golang
 > lindex books 0                 # 取值慢: 成功返回java, O(n) 慎用
 > lrange books 0 -1              # 取全部: 成功返回java swift, O(n) 慎用
 > ltrim books 1 -1               # 从第二个开始截取全部: 成功返回OK, O(n) 慎用
 > ltrim books 1 0                # 清空列表: llen books = 0 内存自动回收

--------------------------------------------------------------------
3. hash   # 哈希 HashMap 无序字典[内存: 数组+链表二维结构，采用渐进式rehash策略，存储消耗高于单个字符串]
--------------------------------------------------------------------
 > hset books java "think in java" # 添加/修改: 字符串如果有空格要用引用
 > hgetall books
 > hget books java
 > hmset books golang "c in go" python "python cookbook"  # 批量添加/修改
 > hmget bokks java golang python
 > hlen books                      # 集合长度: 成功返回1
 > hset books count 3              # 添加: count 计数
 > hincrby books count 1           # 计数: += 1 , hget books count = 4

--------------------------------------------------------------------
4. set    # 无序集合 intset<T>(整数集合-存储空间小)、HashSet(哈希集合-存储空间大), 集合: 唯一键-值-对
--------------------------------------------------------------------
struct intset<T> {                # 整数集合: 元素个数较少，紧凑的数组结构
  int32 encoding;                 # 决定整数位<T>: 16位、32位、64位
  int32 length;                   # 元素个数
  int<T> contents;                # 整数数组
}

--------------------------------------------------------------------
 > sadd books java                 # 添加: 返回1
 > sadd books java                 # 重复: 返回0
 > sadd books golang python        # 批量: 返回2
 > smembers books                  # 查询: 返回所有/无序
 > sismember books jaja            # 判断: 存在与否
 > scard books                     # 集合长度: 成功返回3
 > spop books                      # 取值/删除: 弹出一个

--------------------------------------------------------------------
5. zset   # 有序集合 (复合结构 = SkipList跳跃列表[SortedSet] + HashMap字典), 集合: 唯一键-值-对
          # [内存: SkipList跳跃列表+HashMap字典，每个value赋予一个score的排序权重]
--------------------------------------------------------------------
struct zset {
  dict* dicts;                    # 所有value集合 value=>score，每个value赋予一个score的排序权重
  zskiplist* zsl;                 # 跳跃列表zskiplist
}
struct zsl {                      # 跳跃列表zskiplist
  zslnode* head;                  # SkipList跳跃列表头指针
  int maxLevel;                   # 跳跃列表当前的最高层；随机层数：调用随机算法分配一个合理的层数；最顶层是2^-63，遍历时从maxLevel层往下遍历。
  map<string, zslnode*> ht;       # HashMap字典-所有的键值对
}
struct zslnode {
  string value;
  double score;
  zslnode*[] forwards;            # 多层连接指针
  zslnode* backward;              # 回溯指针
}

--------------------------------------------------------------------
 > zadd books 9.0 "java"           # 添加: 返回1
 > zadd books 8.8 python           # 添加: 返回1
 > zadd books 8.6 golang           # 添加: 返回1
 > zrange books 0 -1               # 查询: 返回所有 / 按 score 排序
 > zrevrange books 0 -1            # 查询: 返回所有 / 按 score 倒序
 > zrangebyscore books 0 8.9       # 查询: 返回部分 / 区间 score 0 - 8.9
 > zrangebyscore books -inf 8.9 withscores # 查询: 返回部分 / 区间 score -∞(inf无穷大) - 8.9 , withscores(同时返回score)
 > zcard books                     # 集合长度: 成功返回3
 > zscore books "java"             # 查询score: 成功返回9.0
 > zrank books "java"              # 排名: 成功返回0 / 第一名
 > zrem books "java"               # 删除: 成功返回1

--------------------------------------------------------------------
 # 以上的list/hash/set/zset是容器型数据结构,它们有通用规则:
 # 1. create if not exists 容器不存在就创建一个再操作 2. drop if no elements 容器中元素没有了释放内存,列表消失
--------------------------------------------------------------------
6. stream   # 频道[发送/接收/历史]消息
--------------------------------------------------------------------
 > xadd channel1 * create-channel null              # 创建频道channel1,发送空消息create-channel
 > xadd channel1 * message1 "hello world" message2 "my name is stream"  # 创建频道channel1,发送消息message1...
 > xread block 10 streams channel1 1538804450788-0  # 接收消息
 > xrange channel1 1538804450789-0 +                # 历史消息

~~~

~~~
 # 分布式锁
 > set lock:id001 true ex 5 nx   # setnx 和 expire 组合在一起的原子指令，它就是分布式锁的奥义所在。
   OK
   ... do something critical ...
 > del lock:id001
   # 1. 分布式锁不能解决超时问题，如果在加锁和释放锁之间的逻辑执行的太长，以至于超出了锁的超时限制，就会出现问题。
   # 因为这时候第一个线程持有的锁过期了，临界区的逻辑还没有执行完，这个时候第二个线程就提前重新持有了这把锁，
   # 导致临界区代码不能得到严格的串行执行。为了避免这个问题，Redis 分布式锁不要用于较长时间的任务。
   # 如果真的偶尔出现了，数据出现的小波错乱可能需要人工介入解决。
   # 2. 可重入性是指线程在持有锁的情况下再次请求加锁，如果一个锁支持同一个线程的多次加锁，
   # 那么这个锁就是可重入的。比如 Java 语言里有个 ReentrantLock 就是可重入锁。
   # Redis 分布式锁如果要支持可重入，需要对客户端的 set 方法进行包装，使用线程的 Threadlocal 变量存储当前持有锁的计数。
--------------------------------------------------------------------
 # 压力测试工具(dev)
 > redis-benchmark -t set -P 2 -q # 管道提升性能: 成功返回SET:51975.05 requests per second, 慎用 参数-P越大QPS越高,但可能CPU已100%了.

~~~


