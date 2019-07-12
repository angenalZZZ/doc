# **系统命令**

# [**windows-cmd**](https://github.com/Awesome-Windows/awesome-windows-command-line) | [windows-tool](https://github.com/Awesome-Windows/Awesome) | [shell](https://github.com/fengyuhetao/shell) | [**linux**](https://wangchujiang.com/linux-command/hot.html) 
> [`All Linux Command`](https://ss64.com/bash/)、[`All Windows CMD`](https://ss64.com/nt/)<br>
> [`《Linux就该这么学》pdf`](https://www.linuxprobe.com/docs/LinuxProbe.pdf)、
  [`《Linux基础课程》video`](https://www.linuxprobe.com/chapter-01.html)、
　[`免费的容器镜像服务`](#免费的容器镜像服务)、[`免费的开发服务器`](#免费的开发服务器)<br>

 * [Windows10安装Linux子系统(WSL)](https://www.cnblogs.com/xiaoliangge/p/9124089.html)
 * [Linux开发环境及常用安装zsh-Redis-mysql-nsq-Botpress-Gotify-SSH-fio等](#Linux开发环境及常用安装zsh-redis-mysql-nsq-botpress-gotify-ssh-fio等)
 * [Linux常用命令](#Linux常用命令)
 * [docker](#docker) | [k8s](#Kubernetes) | [consul](#Consul) | [etcd](#Etcd) | [Nginx](#Nginx)

~~~shell
  # 清屏
  > cls
  $ clear
  
  # 系统
  > ver              # 系统  修复 > sfc/scannow
  > net config workstation
  > shell:startup    # [开始]菜单/启动/添加*.vbs
  $ uname -a         # 系统信息: $(uname -s)=系统'Linux'; $(uname -m)=CPU架构'x86_64';
  $ cat /etc/issue   # 系统版本号'发行版本名称'*** Linux | lsb_release -cs
  $ cat /etc/redhat-release
  
  # 时间
  > wmic OS Get localdatetime /value # 当前本地时间
  # 工具 1.下载 http://sourceforge.net/projects/unxutils 2.解压,重命名usr/local/wbin/date.exe为unixdate.exe
  > unixdate --help         # 帮助
  > unixdate +%s            # 当前时间戳 (unix timestamp)
  > unixdate "+%Y/%m/%d %X" # 当前本地时间 yyyy/MM/dd HH:mm:ss
  $ date -u "+%Y/%m/%d %X"  # 当前UTC时间 yyyy/MM/dd HH:mm:ss
  $ export TZ='Asia/Shanghai' # *设置本地时区* | (帮助选择时区) tzselect | vi ~/.profile < TZ='Asia/Shanghai'
  $ date "+%Y/%m/%d %X"     # 当前本地时间 | (本地日期) date +%Y%m%d | (Hardware-Clock) hwclock
  $ date --date='TZ="Europe/Paris" 2004-10-31 06:30' # 指定时区时间
  $ echo $(date +%Y%m%d)
  # <Windows+Ubuntu>双系统时间同步问题  | www.jianshu.com/p/cf445a2c55e8
  $ sudo timedatectl set-local-rtc 1   # Ubuntu先将RTC硬件时间由UTC改为CST(中国标准时间);然后,设置"日期和时间";
  $ sudo hwclock --localtime --systohc # 最后,同步机器时间(将CST本地时间更新到RTC硬件时间;Windows使用RTC为CST)
  
  # 帮助
  > help cmd
  $ info       # 系统菜单信息: Basics,Compression,Editors,Screen.…… 菜单导航&帮助文档;
    #系统菜单信息: GNU Utilities,Individual utilities,Libraries,Math,Network applications,Text manipulation.
  $ man        # 在线帮助说明
  $ whatis id  # 查找命令id的帮助说明 print real and effective user and group IDs
  $ history    # 历史命令列表
  $ curl https://www.baidu.com/ |tee b.txt # 下载保存html
  
  # 用户登陆
  > mkdir -p %USERPROFILE% # 用户目录
  > mkdir.\to\path         # 创建目录 $ mkdir -p to/path
  $ mkdir -p $HOME         # 用户目录 > cd ~ ; cd /home/$(whoami) # root用户为 / = cd ~
  > quser             # 当前用户状态
  $ whoami && w && id # 当前用户信息
  $ echo $USER
  $ id              # 返回 uid=0(root) gid=0(root) groups=0(root)
  $ id -u           # 返回 uid                     添加用户(-d=$home)      (G=选择用户组)(用户名admin)
  $ mkdir -p /home/admin & chmod 777 /home/admin & useradd -d /home/admin -G root,adm,users admin
  $ passwd admin    # 修改密码
  
  $ sudo su -       # 切换用户至root (并切换到用户目录/root) [或执行: sudo bash || sh]
  $ su admin        # 切换用户至admin
  $ exit            # 退出
  
  $ cat /etc/passwd # 查看密码
  $ login           # 用户登录
  $ cat /etc/shadow # 用户列表
  $ userdel -r admin# 删除用户
  $ cat /etc/group  # 用户组列表
  $ groups          # 用户所在组
  $ groupadd        # 添加用户组
  
  # 进程详情
  > tasklist
  > wmic process where "caption = 'java.exe' and commandline like '%server-1.properties%'" get processid
  > netstat -ano | findstr :3000 # 杀死进程使用, 指定占用的端口号
  > taskkill /F /PID <<PID>>     # PowerShell
  $ ps aux              # 进程列表: USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
  $ ps -eo pid,cmd | grep uuid # [o输出字段,e依赖的系统环境]
  $ ps -u $USER -o pid,%cpu,tty,cputime,cmd
  $ ps -ef | grep dotnet # 查看dotnet进程id
  $ top -Hp [进程id]      # 进程列表: 内存&CPU占用
  $ dotnet-dump collect -p [进程id] ; dotnet-dump analyze core_***  # 查找.NET Core 占用CPU 100% 的原因
    > clrthreads ; setthread [线程DBG] ; clrstack ; clrstack -a ; dumpobj 0x00*** # 分析线程/堆栈/内存数据
  $ ps aux | head -1; ps aux | sort -rn -k3 | head -10 # 占用CPU最高的前10个进程
  $ ps -e -o stat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}' | xargs kill -9 # 批量删除僵尸(Z开头的)进程
  $ killall           # 杀死进程使用, 杀死单个进程: kill -9 [ProcessId]
  $ lsof -i @localhost:3000 && kill -9 <<PID>> # 杀死进程使用, 指定占用的端口号
  $ smem -k -s USS    # 进程的内存使用情况
  # < ubuntu > apt update & apt install smem
  # < centos > yum install epel-release & yum install smem python-matplotlib python-tk
  
  # 文件系统
  > dir [目录]          # 默认当前目录(命令pwd)
  $ ls -an [目录]       # 查看目录及文件读写权限[-al]
  $ touch main.js       # 新建文件
  $ mv main.js main.cs  # 重命名文件,移动文件位置
  $ cat main.cs         # 输出文件内容
  $ namo|vi main.cs     # 编辑文件内容
  $ file main.js && ls -an main.js # 查看文件类型-信息 & 查看文件读写权限&更新时间
  $ for n in {1..10000}; do echo content > "__${n}.tmp"; done  # 创建 10000 个临时文件
  
  # 文件查找
  > for /r C:\windows\addins\ %i in (explorer.exe) do @echo %i # 在指定目录下查找匹配文件
  $ locate /bin/ps          # 遍历文件系统/路径包含/bin/ps所有匹配文件
  $ find / -name [filename] # 查找在根目录下/所有匹配文件
  $ find /etc -type f -name passwd
  
  # 目录访问权限
  > cd [目录]
  $ sudo chmod 777 .         # 修改当前目录(.)权限为可读写
  $ sudo chown -R 1000 [目录] # 改变[目录](R所有子目录)的"拥有者"为uid:1000 = $(id -u)
  $ sudo chgrp –R users [目录] # 改变[目录]的"所属用户组"为G:users = $(id -g)
  $ sudo chmod -R 777 to/path # 每个人都有读和写以及执行的权限(约定的三个数字owner=7;group=7;others=7)
  $ sudo chmod 666 to/path    # 每个人都有读和写的权限
  $ sudo chmod 700 to/path    # 只有所有者有读和写以及执行的权限
  $ sudo chmod 600 to/path    # 只有所有者有读和写的权限
  $ sudo chmod 644 to/path    # 所有者有读和写的权限，组用户只有读的权限
  
  # 文件复制
  > xcopy /isy C:\...\bin\Release\netcoreapp2.1\* F:\app\dotnetcore\centos\a
  > robocopy /e source destination [file [file]...] # Windows的可靠文件复制/备份  帮助: robocopy /?
  $ cp -if /mnt/floppy/* ~/floppy                   # [~/floppy 指向 /root/floppy 或 /home/floppy]
  $ cp -if /mnt/d/Docker/App/ubuntu/usr/local/bin/* /usr/local/bin # [i覆盖文件时,询问?]
  $ cp -fr /usr/local/bin/* /mnt/d/Docker/App/ubuntu/usr/local/bin # [r复制文件目录!]
  
  # 文件删除
  > del /f /s /q [目录|文件]
  > rd /s /q %windir%\temp & md %windir%\temp [删除临时文件]
  $ rm -f -r [r删除目录,否则删除文件] [f强制] [rmdir移除空目录]
  
  # 网络地址
  > ipconfig /?
  $ ifconfig | grep inet
  # 科学上网 - 代理设置 (解决网络问题)
  $ sudo vim /etc/profile [用户配置：~/.profile] # 将以下三行填入：
export http_proxy=http://127.0.0.1:5005
export https_proxy=http://127.0.0.1:5005
export ftp_proxy=http://127.0.0.1:5005
  
  # 网络端口
  > netstat -anT                                                  # tcp端口(本地地址,外部地址,状态)
  > netstat -anp tcp | findstr -i "listening" # 查找本机tcp端口监听列表
  $ netstat -atW | grep -i "listen"                 # tcp端口-centos $ yum install -y net-tools & yum install -y traceroute
  $ netstat -tulnp | grep -i "time_wait" # tcp超时-ubuntu $ apt-get update & apt-get install -y net-tools
  $ ss -t4 state time-wait                                # tcp超时-ubuntu $ apt-get install -y iproute2 iproute2-doc
  $ ss -at '( dport = :ssh or sport = :ssh )' # 端口为 ssh 的套接字
  $ ss -lntp '( dst :443 or dst :80 )'               # 目的端口为 80,443 的套接字
  $ ss -nt state connected dport = :80
  $ ss -nt dport lt :100  # 端口小于100
  $ ss -nt dport gt :1024 # 端口大于1024
  $ ss -lntp  # tcp端口+users进程name-pid-fd  # 常用ss(iproute工具)比netstat(net-tools工具)更强大
  $ ss -aup   # udp端口
  
  # 网络共享
  > net share           # 查找
  > net share c         # 添加
  > net share c /delete # 删除
  
  # 主机环境
  > notepad C:\Windows\System32\drivers\etc\hosts
  > set              # 查看系统环境变量windows
  $ export       # 查看系统环境变量linux
  $ cat /etc/hosts   # 一次显示整个文件
  $ cat > /etc/hosts # 从键盘创建一个文件
  
  # 关机命令
  > sleep 9000; shutdown -s
  > at 03:30:00PM shutdown -s
  > schtasks /create /sc once /tn "auto shutdown my computer" /tr "shutdown -s" /st 15:30
  > at 11:00:00PM /every:M,T,W,TH,F,SA,SU shutdown -s
  > at 11:00:00PM shutdown -r [r重启]
  
  # 系统硬件驱动
  > devmgmt.msc
  
  # 系统硬件序列号
  > wmic memorychip get serialnumber
  > wmic diskdrive get serialnumber
  > wmic baseboard get serialnumber
  > wmic cdrom where drive='G:' get SerialNumber
  # 系统自动登录
  > autologon  userName domainName password
  # 修改计算机名
  > wmic computersystem where caption='currentname' rename newname
  # 网络WiFi关闭
  > netsh interface set interface name="Wireless Network Connection" admin=DISABLED
  # 防火墙开关
  > netsh advfirewall set allprofiles[currentprofile publicprofile privateprofile] state on
  > netsh advfirewall set allprofiles[currentprofile publicprofile privateprofile] state off
  # 时区设置
  > tzutil /g [获取] /l [列表]
  > tzutil /s "China Standard Time" [设置]
  # 打印设置
  > wmic printer get Default,DeviceID,Name,Network                          # 获取打印机设备
  > wmic printer get DeviceID,PrinterPaperNames                             # 设备ID,打印纸张
  > wmic printer where default='TRUE' get name                              # 获取默认打印机
  > wmic printer where name='Microsoft Print to PDF' call setdefaultprinter # 设置默认打印机
  
  # 证书：           CA根证书(服务器身份验证)
    *使用者          Acme Co
    *公钥            RSA (2048 Bits)
    *公钥参数         05 00
    *增强型密钥用法   服务器身份验证 (1.3.6.1.5.5.7.3.1)
    *使用者可选名称   DNS Name=localhost  \  IP Address=0.0.0.0  \  IP Address=127.0.0.1
    *密钥用法         Digital Signature, Key Encipherment, Certificate Signing (a4)
    *基本约束         Subject Type=CA  \  Path Length Constraint=None
    *指纹            a79be724538b668fa817e8578d6a8078337fd3ad
  # 修改PowerShell脚本执行策略 windows 10
  > Get-ExecutionPolicy
  > Set-ExecutionPolicy RemoteSigned [RemoteSigned,AllSigned,Bypass,Restricted...]
  # 创建PowerShell脚本数字签名认证 windows 10
  > cd "C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64" # 签名工具makecert [eku指定为代码签名]
  > makecert -n "CN=Power Shell Local Certificate Root" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr LocalMachine
  # 打开PowerShell查询数字签名证书
  > ls Cert:\CurrentUser\Root | where {$_.Subject -eq "CN=Power Shell Local Certificate Root"}
  
~~~

## Linux开发环境及常用安装zsh-Redis-mysql-nsq-Botpress-Gotify-SSH-fio等

~~~bash
# *更新软件源* sudo vi /etc/apt/sources.list (复制[阿里源ubuntu`18.04`bionic`]到文件顶部)
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
$ sudo apt-get update && sudo apt-get upgrade # 更新软件源操作完毕.
~~~

 `zsh`是一款强大的虚拟终端，推荐使用 [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) 配置管理终端
~~~bash
# 安装 zsh
$ sudo apt-get -y install zsh
# 设置终端shell默认为zsh, 输入以下命令后(重启终端>选择>2) [加sudo修改root的默认shell]
$ chsh -s `which zsh`  # 安装完毕
# 安装 antigen 设置主题
$ curl -L https://raw.githubusercontent.com/skywind3000/vim/30b702725847bac4708de34664bb68454b54e0c0/etc/zshrc.zsh > ~/.zshrc
# 修改配置 ~/.zshrc ; 添加[主题ys] antigen theme ys 至文件`# antigen theme`处; 参考 github.com/robbyrussell/oh-my-zsh/wiki/themes
# 最后再执行 zsh ; 如果出现 compinit 权限问题, 解决如下:
$ sudo chmod -R 755 /usr/local/share/zsh/site-functions
$ source ~/.zshrc # 使配置生效
~~~

~~~shell
  # 环境搭建
  # < Windows Subsystem for Linux | WSL >---------------------------
  $ sudo do-release-upgrade -d        # 升级至18.04LTS ( 如果是16.04? > cat /etc/issue )
  $ lsb_release -c                            # 获取系统代号,更新软件源sources.list
  $ sudo vim /etc/apt/sources.list    # 更新软件源 https://www.cnblogs.com/xudalin/p/9071902.html
  $ sudo apt-get update && sudo apt-get upgrade # 更新升级apt
  $ sudo apt install gcc                 # 安装gcc编译工具(可选)
  $ sudo apt install make             # 安装构建工具make(可选)
  $ sudo apt install build-essential  # 安装gcc/g++/gdb/make等工具链
  $ sudo apt install libgtk2.0-dev pkg-config gnome-core # 安装桌面开发gtk,glib,gnome.
  $ sudo apt install openjdk-8-jdk    # 安装JavaSDK:openjdk
  $ sudo apt install openssh-server
  $ sudo apt install python3              # 安装Python3
  $ sudo apt install python3-pip      # 安装pip3               将Python3设为默认?参考下面!
  $ sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100
  $ sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150
  $ sudo update-alternatives --config python # 手动配置/切换版本: python --version
  $ sudo apt install nodejs                  # 安装Nodejs(此安装的版本太低; 推荐wget安装方式)
  $ wget https://npm.taobao.org/mirrors/node/v10.16.0/node-v10.16.0-linux-x64.tar.xz
  $ sudo tar -zxf node-v10.16.0-linux-x64.tar.xz -C /usr/local/
  $ sudo mv /usr/local/node-v10.16.0-linux-x64 /usr/local/node
  $ vi ~/.bashrc  # 配置 export PATH=/usr/local/node/bin:$PATH # bash生效 source ~/.bashrc ; zsh需修改~/.zshrc
   # (选项)设置软链接: ln -s /usr/local/node/bin/node /usr/local/bin/node ; ln -s /usr/local/node/bin/npm /usr/local/bin/npm
  $ npm install -g npm
  
  # 安装Git
  $ sudo add-apt-repository ppa:git-core/ppa
  $ sudo apt-get update
  $ sudo apt install git
  $ git --version                                        # git config --local -l
  $ git config --global user.name "yangzhou"             # git config --local user.name "用户名"
  $ git config --global user.email "angenal@hotmail.com" # git config --local user.email "用户邮箱地址"
  $ git config --global http.postBuffer 524288000        # set more buffer
  $ git config --global http.sslVerify "false"           # set cancel ssl of https
  $ git init [Git项目所在目录-默认当前目录]                # git init app && ls app/.git/
  $ git status && git stash list
  $ git diff
  $ git add [filename]
  $ git commit -m "添加文件"
  $ git checkout -- [filename]  # 签出，放弃工作区最新的更改，适用于还未提交的情况
  $ git stash && git stash drop # 加入了暂存区后再清除暂存区，适用于还未提交的情况
  $ git reset HEAD [filename]   # 放弃最新提交[取消git.add]，不改变工作区和库区，只改变了暂存区
  $ git reset --hard HEAD^         # 版本回退，工作区和库区都进行相应的回退
  $ rm [filename] && git rm [filename] && git commit -m "删除文件"
  $ git remote add origin https://github.com/dragonFly12345/ubuntuGitTest.git # 使用远程HTTPS
  $ git remote remove origin                                               # 删除后用于重新绑定远程
  $ git remote add origin git@github.com:dragonFly12345/ubuntuGitTest.git # 使用远程SSH
  $ ssh-keygen -t rsa -C "angenal@hotmail.com"      # 使用远程SSH，需要创建SSH认证
  $ git push origin master -u                                                # [u用在第一次推送时]
  # 安装lazyGit，方便管理。
  $ wget https://github.com/jesseduffield/lazygit/releases/download/v0.8.1/lazygit_0.8.1_Linux_x86_64.tar.gz
  
  # 安装数据库Redis (Key-Value数据库) www.redis.cn
  $ wget http://download.redis.io/releases/redis-stable.tar.gz # 下载源码
  $ tar xzf redis-stable.tar.gz                                # 解压源码
  $ cd redis-stable && sudo make install        # 编译Redis
  $ cd utils && sudo ./install_server.sh            # 安装Redis
  $ rm -f -r ~/redis-stable && rm -f ~/redis-stable.tar.gz     # 删除源码
  $ ps aux |grep redis              # 查看进程: /usr/local/bin/redis-server 127.0.0.1:6379
  $ redis-server                         # 启动服务(独立模式), 可通过 ps aux 查看进程
  $ sudo service redis_6379 start                  # (可选)启动服务(非独立模式) start|stop|restart
  $ sudo update-rc.d redis_6379 defaults # (可选)将 Redis init 脚本添加到所有默认运行级别(stop服务后)
  # 开机启动Redis
  > nssm install RedisWSLubuntu1804 bash.exe -c redis-server # 启动前,设置Windows服务登录账户为Administrator
  # 客户端命令Redis
  $ redis-cli -h 127.0.0.1 -p 6379 -a "123456" -n 0 # [p端口],[a密码],[n数据库]
  $ config set requirepass "123456" # 修改配置> sudo vi /etc/redis/6379.conf
  $ auth 123456                                         # 密码认证;再执行其它命令.
  # 性能测试Redis
  > redis-benchmark -n 10000 -q       # 本机Redis  < SET: 90K, GET: 90K > requests per second
  > buntdb-benchmark -n 10000 -q  # 本机BuntDB < SET:230K,GET:5000K > requests per second
  
  # 安装 MySQL
  $ sudo apt-get update
  $ sudo apt-get install mysql-server       # 安装
  $ sudo mysql_secure_installation         # 配置
  $ systemctl status mysql.service             # 检查服务状态
  $ ps aux |grep mysqld　　　　　            # 查看进程: /usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid
  $ sudo mysql -uroot -p
  $ 配置远程访问   (@localhost本机访问; @"%"所有主机都可连接)
  > CREATE USER 'newusername'@'host_name' IDENTIFIED BY 'password';
  > select host,user,password from user;    # 当前用户: SELECT USER();
  > grant select,insert,update,delete,create,drop,index,alter on dbname.* to newusername@192.168.1.10 identified by '123456';
  > GRANT ALL PRIVILEGES ON dbname.* TO newusername@"%" IDENTIFIED BY "123456"; 
  > GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY "123456";
  > SET PASSWORD FOR 'root'@'host_name' = PASSWORD('password');
  > mysqladmin -u root -h host_name password "password"   # 连接mysql
  > mysqladmin -u root -p '123456' password 'newpassword'  # 修改密码
  > mysqladmin -u root -p shutdown                                                    # 关闭mysql
  # 安装 MySQL 的一个开源分支 MariaDB 
  $ sudo yum -y install mariadb mariadb-server # CentOS 7
  $ sudo systemctl start mariadb                           # 启动
  $ sudo systemctl enable mariadb                       # 开机启动
  $ sudo mysqladmin -u root password root      # 设置密码
  $ mysql -u root -p                                                         # 登录mysql
  $ mysql> source db.sql                                               # 执行sql

  # 安装数据库Pilosa (分布式位图索引) www.pilosa.com
  $ curl -L -O https://github.com/pilosa/pilosa/releases/download/v1.3.0/pilosa-v1.3.0-linux-amd64.tar.gz
  $ tar xfz pilosa-v1.3.0-linux-amd64.tar.gz & cp -i pilosa-v1.3.0-linux-amd64/pilosa /usr/local/bin
  $ pilosa server --data-dir ~/.pilosa --bind :10101 --handler.allowed-origins "*"&     # 或指定origins: http://localhost:10102
  $ go get github.com/pilosa/console && cd $GOPATH/src/github.com/pilosa/console && make install && pilosa-console -bind :10102

  # 安装消息平台 nsq.io
  > nsqlookupd                                                                                                                               # 先启动 nsqlookud 消息服务
  > nsqd --lookupd-tcp-address=127.0.0.1:4160 --tcp-address=0.0.0.0:4150       # 再启动几个 nsqd 存储数据
  > nsqd --lookupd-tcp-address=127.0.0.1:4160 --tcp-address=0.0.0.0:4152 --http-address=0.0.0.0:4153
  > nsqadmin --lookupd-http-address=127.0.0.1:4161 #--tcp-address=0.0.0.0:4171 # 最后启动 nqsadmin Web 服务
  # 安装消息平台 kafka.apache.org/quickstart
  $ wget http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.3.0/kafka_2.12-2.3.0.tgz
  $ tar -xzf kafka_2.12-2.3.0.tgz && cd kafka_2.12-2.3.0
  $ bin/zookeeper-server-start.sh config/zookeeper.properties     # start a ZooKeeper server
  $ bin/kafka-server-start.sh config/server.properties            # start the Kafka server
  $ bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test
  $ bin/kafka-topics.sh --list --bootstrap-server localhost:9092  ## create a topic and list topic
  $ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test ## send some messages
  $ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning ## start a consumer
  $ cp config/server.properties config/server-1.properties        # setting up a multi-broker cluster
  $ cp config/server.properties config/server-2.properties        # setting up a multi-broker cluster

  # 安装 Chat Bots 聊天机器人 (Windows服务)
  > nssm install Botpress D:\Program\botpress\bp.exe serve
  > nssm install Gotify %gopath%\bin\gotify\server\gotify.exe

  # 安装 SSH 建立安全的加密连接：一个密码对应一个SSH-key
  > ssh-keygen -t rsa -C "angenal.2008@yahoo.com.cn"
  > dir "C:\Users\Administrator/.ssh"     # 存储的本地公钥位置
  > clip < %USERPROFILE%/.ssh/id_rsa.pub  # 拷贝公钥到粘贴板中
  $ cat ~/.ssh/id_rsa.pub                 # https://code.aliyun.com/help/ssh/README
  $ xclip -sel clip < ~/.ssh/id_rsa.pub   # GNU/Linux (requires xclip)
  $ pbcopy < ~/.ssh/id_rsa.pub            # Mac-OS

  # 安装 构建工具|代码仓库|版本管理 < make、curl、git、gitea >
  > ftp://ftp.equation.com/make/64/make.exe # 下载构建工具make < Windows >
  $ sudo apt install make  # 安装<Ubuntu/Debian> | <CentOS/Fedora/RHEL> sudo yum install make
  $ sudo apt install curl  # 安装curl < ubuntu >
  $ sudo apt install git   # 安装git  < ubuntu >
  $ mkdir -p /git & cd /git & sudo chmod 777 . # 创建git仓储根目录:可读写
  > Gitea 文档 https://docs.gitea.io/zh-cn | 下载 https://dl.gitea.io/gitea/master | 源码 github.com/go-gitea/gitea
  > Gitea API 使用指南 https://docs.gitea.io/zh-cn/api-usage
  # 注册Windows服务
  > sc create gitea start= auto binPath= "D:\Program\Git\Server\gitea\gitea.exe web --config \"D:\Program\Git\Server\gitea\custom\conf\app.ini\""
  # 删除Windows服务
  > sc delete gitea

  # 安装Docker客户端 (连接到 Docker for Windows10)
  # < Windows Subsystem for Linux | WSL >---------------------------
  $ sudo apt install docker.io              # 安装Docker客户端 | docker.io get client connection.
  $ export DOCKER_HOST=tcp://127.0.0.1:2375 # 设置环境, 使用 vi ~/.bashrc [~/.bash_profile](在文件结尾添加)
  $ docker [COMMAND] --help                 # 执行Docker命令

  # Docker正式环境: 修改Linux内核参数 https://blog.csdn.net/guanheng68/article/details/81710406
  $ sysctl -w vm.max_map_count=262144      # 操作无效时, 使用 vi /etc/sysctl.conf 修改
  $ grep vm.max_map_count /etc/sysctl.conf # 检查设置

  # 安装 Ansible 配置管理和IT自动化工具-(系统运维)(Ubuntu)一个由Python编写的强大的配置管理解决方案
  $ sudo apt update
  $ sudo apt install software-properties-common
  $ sudo apt-add-repository --yes --update ppa:ansible/ansible
  $ sudo apt install ansible
  # 安装 Airflow 任务调度  由Python编写  https://www.jianshu.com/p/9bed1e3ab93b
  $ sudo apt install libkrb5-dev libsasl2-dev libmysqlclient-dev  # 安装airflow[all]依赖包
  $ mkdir airflow && cd airflow
  $ pip install setuptools_git
  $ pip download pymssql
  $ pip download apache-airflow[all]                                                     # 1.离线: tar -zcf airflow.tar.gz *
  $ cd airflow                                                                                                      # 2.解压: tar -zxf airflow.tar.gz
  $ pip install apache-airflow[all] --no-index -f ./                                # 3.安装airflow[all]
  $ echo "export AIRFLOW_HOME=~/app/airflow" >> ~/.bashrc  # 4.配置
  $ source ~/.bashrc && airflow initdb                                                     # 5.部署

  # 图片压缩
  $ sudo apt-get install jpegoptim   # jpg 图片压缩: jpegoptim *.jpg ; find . -name '*.jpg' | xargs jpegoptim --strip-all;
  $ sudo apt-get install optipng        # png 图片压缩: optipng *.png ; find -type f -name "*.png" -exec optipng {} \;
  $ git clone git://github.com/xing/TinyPNG.git && ./TinyPNG/install.sh  # TinyPNG 图片压缩
  
  # 加密解密
  $ chmod +x toplip # 赋予可执行权限
  $ ./toplip   # 运行 http://os.51cto.com/art/201903/593569.htm https://2ton.com.au/standalone_binaries/toplip
  
  # 检测工具
  # < fio 检测存储性能 >---------------------------
  $ wget https://github.com/axboe/fio/archive/fio-3.14.tar.gz  #! http://brick.kernel.dk/snaps/fio-2.1.10.tar.gz
  $ tar -zxf fio-3.14.tar.gz && cd fio-fio-3.14
  $ ./configure --enable-gfio # 配置: enable gfio (参数可选)
  $ make                                    # 编译: make fio && make gfio
  $ sudo make install         # 安装: install fio gfio genfio fio-* /usr/local/bin
  $ cd .. && rm -rf fio-*     # 安装完毕后删除源(可选)
  $ fio -S& [--server]        # 启动后端← + →客户端↓测试↓ [参考:examples/*.fio]
  $ fio --client=host1.list fio1.job --client=host2.list fio2.job
  $ fio --ioengine=libaio --direct=1 --thread --norandommap \ # SATA接口硬盘
    --filename=/dev/sda --name=init_seq --output=init_seq1.log \
    --rw=write --bs=128k --numjobs=1 --iodepth=32 --loops=1 # blog.csdn.net/dinglisong/article/details/83111515
  $ gfio   # 桌面应用→分析(>1h)→ 顺序读、顺序写、随机读、随机写等存储性能
  
~~~

----

# [**docker**](https://docs.docker.com)

>  [下载](https://download.docker.com)、[安装](https://docs.docker.com/install)　[docker-desktop](https://www.docker.com/products/docker-desktop)：Build构建&Compose组织&Kubernetes集群<br>
  `环境 & 版本` : `Linux x64, Kernel^3.10 cgroups & namespaces.`, `docker-ce`社区版 + `docker-ee`企业版 <br>
  `加速器`      : [`阿里云`](https://cr.console.aliyun.com/#/accelerator)、[`DaoCloud道客`](https://dashboard.daocloud.io/packages/explore)   [..](http://8fe1b42e.m.daocloud.io)
~~~
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io   # for Linux
sudo systemctl daemon-reload && sudo systemctl restart docker.service
~~~
> `Dockerfile` : `docker build Image(tag=name+version)` > `push Registry` <br>
  `Registry & Disk` : `Repository` > `Image-Url` | `Image save .tar to-Disk`, `Container export .tar(snapshot)` <br>
  `Docker`     : `pull Image from-Registry` | `load Image .tar from-Disk` <br>
  `Data`       : `docker container run Image` - `--volumes-from Data-Container` - `-v from-Disk:Data-Dir`

> `安装`
~~~shell
# 安装Docker，先切换用户root ~ su
$ curl -sSL https://get.daocloud.io/docker | sh  
# 卸载Docker，最后清理 ~ rm -fr /var/lib/docker/
$ apt-get remove docker docker-engine  
# 安装 Docker Compose
$ curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose 
$ chmod +x /usr/local/bin/docker-compose
# 安装 Docker Machine   #  http://github.com/docker/machine/releases/download/v0.16.1/docker-machine-Linux-x86_64
$ sudo dpkg -i virtualbox-6.0_6.0.8-130520_Ubuntu_bionic_amd64.deb --fix-missing  #基于virtualBox | www.virtualbox.org/wiki/Linux_Downloads
$ curl -L https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
$ chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine  # install /tmp/docker-machine /usr/local/bin/docker-machine
$ docker-machine version                    # 安装完毕
# 不使用sudo执行docker命令，先切换当前用户( root ~ exit )
$ sudo gpasswd -a ${USER} docker  # 将当前用户加入docker组 
$ sudo service docker restart              # 重启docker
$ newgrp - docker                                    # 刷新docker组
~~~

> **Shell** [samples](https://docs.docker.com/samples)、[labs/tutorials](https://github.com/angenal/labs)、[小结](https://github.com/AlexWoo/doc/blob/master/devops/docker小结.md)
~~~
  # 构建
  docker build --build-arg NODE_ENV=dev -t test-image # 当前目录下有Dockerfile
  # 运行
  docker-machine ip          # 获得当前Docker宿主机的IP地址
  docker-machine ssh default # 登录到Boot2docker虚拟机之上(Linux-无需如此)
  docker run --name test-image-docker -it -p 9999:8888 test-image # 已加载镜像 test-image 时, 用 docker images 查询
  # 网络
  docker network ls                                 # 查看网络列表
  docker network create -d bridge [network-name]    # 创建自定义网络[-d bridge 网络驱动=桥接模式]
  docker network connect [network-name] [container] # 1.加入自定义网络(参数2,3,4可一起写)
  docker network connect --alias db [network-name] [container-db] # 2.入网,提供别名访问
  docker network connect --link other_container:alias_name [network-name] [container] # 3.入网,其它容器连接别名
  docker network connect --ip 10.10.36.122 [network-name] [container] # 4.入网,其它容器连接指定ip
  docker network disconnect [network-name] [container] # 退出网络
  docker network create -d host host        # 创建自定义网络host(默认已添加); -d [host:与主机共享一个IP地址/内网地址]
  docker network create -d bridge workgroup # 创建自定义网络workgroup; -d [bridge(默认):分配给容器一个IP地址]
  docker network connect workgroup redis5 && docker network connect workgroup centos.netcore # 加入自定义网络workgroup
  docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" [container] # 查询IP地址
  docker inspect -f "Name:{{.Name}}, Hostname:{{.Config.Hostname}}, IP:{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" [container]
  docker inspect -f "{{.Config.Hostname}} {{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" $(docker ps -aq) #Shell
  docker run --name myweb -d -P --network=workgroup --link redis5:redis5 nginx # 容器之间安全互联 myweb连接redis5:redis5别名

  # 基础
  docker [COMMAND] --help
  docker images # 查看镜像
  docker ps -a  # 查看容器 | docker container ls -a
  docker search ubuntu # 搜索镜像
  docker pull ubuntu   # 下载镜像
  docker load -i /opt/images/ubuntu_latest.tar # 加载镜像 (使用Xftp将镜像tar上传至Docker虚拟机或共享盘)
  docker commit web myweb # 创建新镜像myweb(容器web) 另存为镜像 (save container to image)
  docker save -o d:\docker\images\ubuntu_latest.tar ubuntu:latest       # 保存镜像 (save image)
  docker export ubuntu > "d:\docker\snapshot\ubuntu_19_04.tar"           # 导出快照 (export snapshot)
  docker container export -o="d:\docker\snapshot\ubuntu_19_04.tar" ubuntu # 导出快照 (container export snapshot)
  docker cp d:\docker\app\xxx\publish centos.netcore:/home/app/xxx/publish # 复制目录 (copy dir to container)
  docker cp centos.netcore:/home/app/entrypoint.sh d:\docker\app\centos\home\app\entrypoint.sh # 复制文件

  docker container start $(docker ps -aq)   # 启动所有容器
  docker container stop $(docker ps -aq)    # 停止所有容器
  docker container restart $(docker ps -aq) # 重启所有容器
  docker kill $(docker ps -a -q)   # 杀死所有运行的容器
  docker container prune             # 删除所有停止的容器
  docker volume prune                 # 删除未使用volumes
  docker system prune                  # 删除未使用数据
  docker rm [container]                # 删除1个容器
  docker rm $(docker ps -a -q)   # 删除所有容器
  docker rmi [image]                      # 删除1个镜像
  docker rmi $(docker images -q) # 删除所有镜像
  docker port [container]            # 查看端口映射
  docker inspect [container]      # 查看容器详情
  docker rename web [container]  # 容器重命名 > 查看容器 docker ps -a
  docker logs [container]                   # 查看容器日志
  docker update --restart=always [container] # 修改配置: 设置为开机启动 (可在 docker run 时添加此参数)
  
  docker stop 8b49 & docker rm -f mysite    # 停止+删除 :容器[ID前缀3-4位 或 containerName]
  docker stop web & docker commit web myweb & docker run -p 8080:80 -td myweb # commit新容器myweb&端口映射
  docker exec -it redis5 /bin/sh -c "ps aux & /bin/sh"  # 在容器中执行命令: 查看进程详情后,进入工作目录执行sh

  docker run -it --rm -e AUTHOR="Test" alpine /bin/sh #查找镜像alpine+运行容器alpine+终端交互it+停止自动删除+执行命令
  docker run --name mysite -d -p 8080:80 -p 8081:443 dockersamples/static-site #查找镜像&运行容器mysite&服务&端口映射
  
  docker run --name redis5 --network=workgroup --network-alias=redis5 --restart=always -d -m 512m -p 6379:6379 
    -v d:\docker\app\redis5\redis.conf:/etc/redis/redis.conf -v d:\docker\app\redis5\data:/data 
    redis:5.0.3-alpine redis-server /etc/redis/redis.conf # 执行Sh /usr/local/bin/docker-entrypoint.sh
  docker run -p 6379:6379 -itd redislabs/redistimeseries  # 时序Db https://github.com/RedisLabsModules
  docker run --name ssdb --network=workgroup --network-alias=ssdb -d -m 512m -p 8888:8888 
    -v d:\docker\app\ssdb\ssdb.conf:/ssdb/ssdb.conf leobuskin/ssdb-docker # 替代Redis http://ssdb.io/zh_cn
  
  ## https://docs.docker.com/compose/aspnet-mssql-compose/  ${PWD} = d:\docker\app\microsoft.net\mvc
  # Startup.sh1: docker run -v ${PWD}:/app --workdir /app microsoft/aspnetcore-build:lts dotnet new mvc --auth Individual
  docker run --name dotnet --network=workgroup -it -m 512m -p 8080:80 -v "d:\docker\app\microsoft.net\app:/app" 
    microsoft/dotnet # 最新版dotnet
    microsoft/dotnet:sdk # 最新版dotnet-sdk
    microsoft/dotnet:aspnetcore-runtime #最新版dotnet-runtime
  
  docker run --name centos -it --network=workgroup -m 512m -p 8000:80 -v "d:\docker\app\centos\home:/home" -w /home 
    centos /bin/bash # 其它: --workdir /home/ConsoleApp2NewLife centos /bin/sh -c "/bin/bash ./entrypoint.sh"
    $ rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm & yum install -y dotnet-runtime-2.1
    $ dotnet /home/ConsoleApp2NewLife/ConsoleApp2NewLife.dll # 访问tcp://127.0.0.1:8000
  
  docker run --name mysql -itd -p 3306:3306 --network=workgroup --network-alias=mysql --env MYSQL_ROOT_PASSWORD=HGJ766GR767FKJU0 
    mysql:5.7 # mariadb、mongo、mysql/mysql-server、microsoft/mssql-server-linux, (--network-alias)其它容器连此容器
  docker run --name mssql -itd -p 1433:1433 --network=workgroup --network-alias=mssql -v "d:\docker\app\mssql\data:/var/opt/mssql/data" 
    -v "d:\docker\app\mssql\log:/var/opt/mssql/log" -e SA_PASSWORD=HGJ766GR767FKJU0 -e ACCEPT_EULA=Y 
    mcr.microsoft.com/mssql/server # 数据库mssql
  # 外部访问控制：(--link)其它容器连db, (--net=host -bind=192.168.1.2)不安全连接(与主机共享一个IP)+内网私有访问bind-ip
  
  # 消息平台 rabbitmq | github.com/judasn/Linux-Tutorial/blob/master/markdown-file/RabbitMQ-Install-And-Settings.md
  docker run --name rabbitmq3 -d --network=workgroup --network-alias=rabbitmq 
    -p 5671:5671 -p 5672:5672 -p 4369:4369 -p 25672:25672 -p 15671:15671 -p 15672:15672 -p 61613:61613 
    -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=HGJ766GR767FKJU0 
    rabbitmq:3-management # 消息库rabbitmq http://localhost:15672 访问控制台
    # 消息服务rabbitmq插件: docker exec -it rabbitmq3 bash ; cd plugins ; rabbitmq-plugins enable rabbitmq_web_stomp
  # 消息平台 nsq | nsq.io/deployment/docker.html
  docker run --name nsqlookupd --network=workgroup --network-alias=nsqlookupd -p 4160:4160 -p 4161:4161 
    nsqio/nsq /nsqlookupd  # First Run nsqlookupd for nsqd & nsqadmin 
  docker run --name nsqd --network=workgroup --network-alias=nsqd -p 4150:4150 -p 4151:4151 -v d:\docker\app\nsq\data:/data 
    nsqio/nsq /nsqd --data-path=/data --lookupd-tcp-address=nsqlookupd:4160 # --broadcast-address=<dockerIP>
  docker run --name nsqadmin -d --network=workgroup -p 4171:4171 nsqio/nsq /nsqadmin --lookupd-http-address=nsqlookupd:4161
  # 消息平台 kafka | wurstmeister.github.io/kafka-docker
  docker run --name kafka wurstmeister/kafka
  
  # 事件|代理|自动化系统
  docker run --name beehive -d --network=workgroup -p 8181:8181 -v d:\docker\app\beehive\conf:/conf gabrielalacchi/beehive
  # 高性能的图形数据库(NoSQL)
  docker run --name neo4j --network=workgroup --network-alias=neo4j -m 512m -p 7474:7474 -p 7687:7687 
    -v "d:\docker\app\neo4j\data:/data" -v "d:\docker\app\neo4j\logs:/logs" neo4j:3.0
  # 大数据+分布式位图索引+实时计算
  docker run --name pilosa --network=workgroup --network-alias=pilosa -d -p 10101:10101 -v d:\docker\app\pilosa\data:/data 
    pilosa/pilosa server --data-dir /data --bind :10101 --handler.allowed-origins http://localhost:10102
  # 一个基于celery任务DAG管理工具 kuanshijiao.com/2017/03/07/airflow1
  docker run --name airflow --network=workgroup --network-alias=airflow -d -p 8480:8080 -e LOAD_EX=y puckel/docker-airflow
  # 一个安全的消息服务平台，自带后台管理
  docker run --name mattermost-preview -d -p 8065:8065 --add-host dockerhost:127.0.0.1 mattermost/mattermost-preview
  
  docker run --name timescaledb -d -p 5432:5432 -e POSTGRES_PASSWORD=123456 timescale/timescaledb:latest-pg11 # PostgreSQL
  docker run --name opentsdb -d -p 4242:4242 -v d:\docker\app\opentsdb\tmp:/tmp -v d:\docker\app\opentsdb\data\hbase:/data/hbase 
    -v d:\docker\app\opentsdb\opentsdb-plugins:/opentsdb-plugins petergrace/opentsdb-docker
    # 时序数据库opentsdb http://opentsdb.net/docs/build/html/resources.html
  docker run --name m3db -d -p 7201:7201 -p 7203:7203 -p 9003:9003 quay.io/m3/m3dbnode 
    # 分布式时序数据库M3DB(单节点时?可能吃掉整个磁盘资源!) # m3db.github.io/m3/how_to/single_node/ github.com/m3db/m3
  
  # 云存储解决方案minio  文档指南 https://docs.min.io/cn
  > minio.exe server d:\docker\app\minio\data  # 本地网盘svr：http://127.0.0.1:9000/ : Access-Key & Secret-Key
  > hidec /w minio.exe server d:\docker\app\minio\data # 隐藏控制台 & 后台运行 & 配置↑ data\.minio.sys\config\config.json
  > nssm install MinIO minio.exe server d:\docker\app\minio\data # 安装/Windows服务/云存储MinIO
  > mc config host add minio http://127.0.0.1:9000 <ACCESS-KEY> <SECRET-KEY> # 客户端 dl.minio.io/client/mc/release
  > mc ls -r minio # 获取所有云存储对象列表
  > mc find minio/img --maxdepth 3 --name "*.png" --path "*" --larger 1KB --smaller 2MB --older-than 0d2h30m --json
  docker run --name minio-service -p 9000:9000 -v d:\docker\app\minio\data:/data -v d:\docker\app\minio\config:/root/.minio 
    -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" 
    minio/minio server /data # 对象存储服务，例如图片、视频、日志文件、备份数据和容器/虚拟机镜像等 https://docs.min.io/cn
    # 设置安全密钥: using Docker secrets
    # echo "AKIAIOSFODNN7EXAMPLE" | docker secret create access_key -
    # echo "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" | docker secret create secret_key -
  
  # 基于 Jenkins 快速搭建持续集成环境
  git clone https://github.com/AliyunContainerService/docker-jenkins 
    && cd docker-jenkins/jenkins && docker build -t denverdino/jenkins .
  docker run --name jenkins -d -p 8080:8080 -p 50000:50000 -v d:\docker\app\jenkins_home:/var/jenkins_home denverdino/jenkins
  # docker run --name jenkins -d -p 8080:8080 -p 50000:50000 -v d:\docker\app\jenkins_home:/var/jenkins_home jenkins
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

> **Dockerfile** [文档](https://docs.docker.com/get-started)<br>
　$ docker build -t <YOUR_USERNAME>/myapp . # 构建+标签[用户名/镜像名]
~~~
  # 基础镜像
  FROM node:10.15.0
  
  # 备注镜像相关信息，通过 docker inspect 查看
  LABEL maintainer="test <test@gmail.com>"
  LABEL description="this is a test image"
  LABEL version="1.0"
  
  # 设置工作目录，若不存在会自动创建，其他指令会以此为相对路径
  WORKDIR /work/app
  
  # ADD <src> <dest>
  # 添加资源到工作目录，若是压缩文件会自动解压，可指定远程地址下载url
  ADD 'https://github.com/nodejscn/node-api-cn/blob/master/README.md' ./doc/
  
  # COPY <src> <dest>
  # 复制资源到工作目录，不会解压，无法从远程地址下载
  COPY ./ ./
  
  # RUN 构建镜像时执行的命令(安装运行时环境、软件等)
  RUN npm install
  
  # ARG 构建镜像时可传递的参数，配合 ENV 使用 docker build --build-arg NODE_ENV=dev
  ARG NODE_ENV
  ARG TZ='Asia/Shanghai'
  
  # ENV 容器运行时环境变量，配合 ARG 使用 $NODE_ENV '${TZ}'
  ENV NODE_ENV=$NODE_ENV
  ENV TZ '${TZ}'
  
  # EXPOSE 容器端口(可指定多个)，启动时指定与宿主机端口的映射 docker run -p 9999:8888
  EXPOSE 8080 8888
  
  # CMD 容器启动后执行的命令，会被 docker run 命令覆盖
  CMD ["npm", "start"]  # other, web-proxy: CMD ["nginx", "-g", "daemon off;"]
  
  # ENTRYPOINT 容器启动后执行的命令，不会被 docker run 命令覆盖；一般不会使用；
  # 任何 docker run 命令设置的指令参数 或 CMD 指令，都将作为参数追加至 ENTRYPOINT 命令之后
  # ENTRYPOINT ["dotnet", "aspnetapp.dll"]
~~~

> **.dockerignore** 配置文件/屏蔽读取
~~~
# 一般临时文件
*/temp*
*/*/temp*
temp?
*.md
!README*.md
# 编译临时文件
bin\
obj\
~~~

> **docker-compose.yml** [安装Compose](https://docs.docker.com/compose/install/) [文档v3](https://docs.docker.com/compose/overview) | [老版本v2](https://www.jianshu.com/p/2217cfed29d7) | [votingapp例子](https://github.com/angenal/labs/blob/master/beginner/chapters/votingapp.md)<br>
　管理容器的生命周期，从应用创建、部署、扩容、更新、调度均可在一个平台上完成。<br>
　[`启动`](https://docs.docker-cn.com/compose/reference/up/)：`docker-compose up -d` | [`停止`](https://docs.docker-cn.com/compose/reference/down/)：`docker-compose down` | [`更多`](https://docs.docker-cn.com/compose/reference)：`pause`、`unpause`、`start`、`stop`、`restart`
~~~
  version: '3' # docker compose 版本(版本不同,语法命令有所不同)
  services:    # docker services 容器服务编排
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
      container_name: redis-container
      image: redis:latest
      networks:
      - back-tier

  networks: # 网络设置(自定义)
    front-tier:
      driver: bridge
    back-tier:
      driver: bridge
~~~

# [**Kubernetes**](https://www.kubernetes.org.cn)

> [`k8s`](https://www.kubernetes.org.cn) 是一个流行的容器管理编排平台，集中式管理数个服务的容器集群；<br>
  　[docker-desktop](https://www.docker.com/products/docker-desktop)已添加Docker-Compose与Kubernetes进行完整的集成。<br>
~~~
  # 部署
  > docker-compose build && kubectl apply -f /path/to/kube-deployment.yml  # 1 deploy of apply config
  > docker stack deploy -c /path/to/docker-compose.yml mystack             # 2 deploy stack with compose
~~~
> `k8s`扩展<br>
  　[istio](https://istio.io/docs/setup/kubernetes/platform-setup/)：连接、安全、控制和观察服务

# [**Consul**](https://hub.docker.com/_/consul)

> [`Consul`](https://www.consul.io) 是google开源的一个使用go语言开发的服务发现、配置管理中心服务。<br>
  　[`Docker`+`Consul`+`Nginx`](https://www.jianshu.com/p/9976e874c099)基于nginx和consul构建高可用及自动发现的docker服务架构。Consul集群中的每个主机都运行Consul代理，与Docker守护程序一起运行。每个群集在服务器模式下至少有一个代理，通常为3到5个以实现高可用性。在给定主机上运行的应用程序仅使用其HTTP-API或DNS-API与其本地Consul代理进行通信。主机上的服务也要向本地Consul代理进行注册，该代理将信息与Consul服务器同步。多个HTTP应用程序与Consul的服务发现功能深入集成，并允许应用程序在没有任何中间代理的情况下定位服务并平衡负载。[`查看安装说明`](https://hub.docker.com/_/consul)、[`参数`/`开发模式`](https://www.consul.io/docs/agent/options.html#_dev)、[`代理API`](https://www.consul.io/docs/agent/http/agent.html)
~~~
  # /consul/data   容器暴露VOLUME
    # 对于客户端代理，存储有关群集的一些信息以及客户端的运行状况检查，以防重新启动容器。
    # 对于服务器代理，存储客户端信息以及与一致性算法相关的快照和数据以及Consul的键/值存储和目录等。
  # /consul/config 配置目录
    # Consul总是--net=host在Docker中运行，因此在配置Consul的IP地址时需要注意。Consul具有其集群地址的概念以及其客户端地址。
    # Consul群集地址是其他Consul代理可以联系给定代理的地址。客户端地址是主机上的其他进程联系Consul以发出HTTP或DNS请求的地址。
    # -bind=<external ip> 告诉Consul启动时其群集地址？
  # Consul包括一个小实用程序，用于查找客户端或按接口名称绑定地址
    # -e CONSUL_CLIENT_INTERFACE或CONSUL_BIND_INTERFACE 用于设置接口名称
    # -bind=<interface ip> & -client=<interface ip> 用于查找客户端
  
  # 在开发模式下运行Consul 不带参数的Consul容器将为您提供处于开发模式的Consul服务器，使用开发服务器在桥接网络上运行，
      对于在单个机器上测试Consul的多个实例非常有用。开发模式还在端口8500上启动Consul的Web UI版本。
      通过-ui在命令行上向Consul 提供选项，可以将其添加到其他Consul配置中。
  > docker run -d --name dev-consul-node0 -p 8500:8500 -e CONSUL_BIND_INTERFACE=eth0 consul # 不指定任何参数给consul
      # 查找IP-join: docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" dev-consul-node0
  > docker run -d --name dev-consul-node1 -e CONSUL_BIND_INTERFACE=eth0 consul agent -dev -join=172.17.0. #可运行多个
  > docker exec -t dev-consul-node0 consul info    # 查看Consul集群的基本信息 https://www.consul.io/docs/commands/info.html
  > docker exec -t dev-consul-node0 consul members # 查询Consul集群中的所有成员
  > curl http://localhost:8500/v1/health/service/consul?pretty # 查询Consul集群的健康状况
  > docker exec -it dev-consul-node0 sh # 进入集群主机中执行shell
  $ consul --help                               # 操作帮助
  $ consul catalog nodes                        # 节点列表
  $ consul kv put config/api/request_limit 2000 # 添加数据
  $ consul kv get config/api/request_limit      # 查询数据
  $ consul kv delete config/api/request_limit   # 删除数据
  $ consul intention check api postgresql       # 检查微服务api
  $ consul intention create api postgresql      # 创建微服务api
  $ consul intention delete api postgresql      # 删除微服务api
  
  # 在服务器模式下运行Consul Agent
  > docker run -d --net=host consul agent -server -bind=172.17.0.1 # 将代理暴露给容器的网络（桥接网络）
      -retry-join=<root agent ip> # 指定群集中用于在启动时加入的另一个代理的外部IP
      -bootstrap-expect=<number of server agents> # 其他数据中心数目，或者只指定为当前数据中心-bootstrap
  # 在客户端模式下运行Consul Agent
  > docker run -d --net=host consul agent 
      -client=<bridge ip> # 客户端(默认127.0.0.1)通过（桥接网络）将接口公开给其他容器，可用选项-client=0.0.0.0绑定所有接口
      -bind=<external ip> # 当主机上其他容器也使用--net=host将代理暴露给容器外主机上运行的其他应用程序进程
      -retry-join=<root agent ip> # 参考下：
        # Using a DNS entry > consul agent -retry-join "consul.domain.internal"
        # Using IPv4 > consul agent -retry-join "10.0.4.67"
        # Using IPv6 > consul agent -retry-join "[::1]:8301"
        # Using Cloud Auto-Joining > consul agent -retry-join "provider=aws tag_key=..."
  
  # 在端口53上公开Consul的DNS服务器 https://www.consul.io/docs/agent/services.html
  > docker run -d --net=host -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' consul -dns-port=53 -recursor=8.8.8.8 -bind=<bridge ip>
  > docker run -i --dns=<bridge ip> -t ubuntu sh -c "apt-get update && apt-get install -y dnsutils && dig consul.service.consul"
  # 使用容器进行服务发现，有关详细信息，请参阅[代理API] https://www.consul.io/docs/agent/http/agent.html
  # 在Docker容器中运行运行状况检查
      # 如果Docker守护程序暴露给Consul代理并且DOCKER_HOST设置了环境变量，则可以使用Docker容器ID配置检查以执行。
~~~

# [**Etcd**](https://github.com/etcd-io/etcd)

> [`etcd`](https://coreos.com/etcd/docs/latest/demo.html) 分布式、可靠的键值存储，用于分布式系统中共享配置和服务发现。 [`download`](https://github.com/etcd-io/etcd/releases) [`play...`](http://play.etcd.io/install)
 * 简单: 良好定义的HTTP接口，面向用户的API(gRPC)，易理解；支持消息发布与订阅；
 * 安全: 支持SSL客户端安全认证；数据持久化(默认数据更新就进行持久化)；
 * 快速: 每秒1w/qps；版本高速迭代和开发中，这既是一个优点，也是一个缺点；
 * 可靠: 使用Raft一致性算法来管理高可用复制(分布式存储)👍
~~~
# 版本: 默认API版本为2(修改参数ETCDCTL_API=3)；
# 端口: 默认2379为客户端通讯，2380进行服务器间通讯；
# <本地简单运行>----------------------------------------------------
 > nssm install EtcdServer etcd.exe # 以管理员运行服务
 # 运行(客户端) > etcdctl [command]  # etcdctl和etcd交互,命令如下:
 # put[输入], get[输出--rev=1'取版本号1'], del[删除], watch[观察历史修订], compact[压缩修订版本]
 # lease grant 10 (1.授予租约>'TTL为10秒';返回[id]); put --lease=[id] [key] [value] (指定key授予租约)
 # lease revoke [id] (2.撤销租约>指定[id]>因租约撤销导致foo被删除)
 # lease keep-alive [id] (3.维持租约)
# <搭建本地集群>----------------------------------------------------
 $ go get github.com/mattn/goreman  # 提前安装Go,或下载可执行文件goreman
 $ goreman -f Procfile start        # 用到gitub项目根目录下的Procfile文件(需要修改)
 $ etcdctl-w="table" --endpoints=localhost:12379 member list  # 查询集群信息
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

#### Nginx

 * 基本配置与参数说明
~~~
#运行用户
user nobody;
#启动进程,通常设置成和cpu的数量相等
worker_processes  1;

#全局错误日志及PID文件
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

#工作模式及连接数上限
events {
    #epoll是多路复用IO(I/O Multiplexing)中的一种方式,
    #仅用于linux2.6以上内核,可以大大提高nginx的性能
    use   epoll;

    #单个后台worker process进程的最大并发链接数
    worker_connections  1024;

    # 并发总数是 worker_processes 和 worker_connections 的乘积
    # 即 max_clients = worker_processes * worker_connections
    # 在设置了反向代理的情况下，max_clients = worker_processes * worker_connections / 4  为什么
    # 为什么上面反向代理要除以4，应该说是一个经验值
    # 根据以上条件，正常情况下的Nginx Server可以应付的最大连接数为：4 * 8000 = 32000
    # worker_connections 值的设置跟物理内存大小有关
    # 因为并发受IO约束，max_clients的值须小于系统可以打开的最大文件数
    # 而系统可以打开的最大文件数和内存大小成正比，一般1GB内存的机器上可以打开的文件数大约是10万左右
    # 我们来看看360M内存的VPS可以打开的文件句柄数是多少：
    # $ cat /proc/sys/fs/file-max
    # 输出 34336
    # 32000 < 34336，即并发连接总数小于系统可以打开的文件句柄总数，这样就在操作系统可以承受的范围之内
    # 所以，worker_connections 的值需根据 worker_processes 进程数目和系统可以打开的最大文件总数进行适当地进行设置
    # 使得并发总数小于操作系统可以打开的最大文件数目
    # 其实质也就是根据主机的物理CPU和内存进行配置
    # 当然，理论上的并发总数可能会和实际有所偏差，因为主机还有其他的工作进程需要消耗系统资源。
    # ulimit -SHn 65535

}

http {
    #设定mime类型,类型由mime.type文件定义
    include    mime.types;
    default_type  application/octet-stream;
    #设定日志格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log  main;

    #sendfile 指令指定 nginx 是否调用 sendfile 函数（zero copy 方式）来输出文件，
    #对于普通应用，必须设为 on,
    #如果用来进行下载等应用磁盘IO重负载应用，可设置为 off，
    #以平衡磁盘与网络I/O处理速度，降低系统的uptime.
    sendfile     on;
    #tcp_nopush     on;

    #连接超时时间
    #keepalive_timeout  0;
    keepalive_timeout  65;
    tcp_nodelay     on;

    #开启gzip压缩
    gzip  on;
    gzip_disable "MSIE [1-6].";

    #设定请求缓冲
    client_header_buffer_size    128k;
    large_client_header_buffers  4 128k;

    #设定虚拟主机配置
    server {
        #侦听80端口
        listen    80;
        #定义使用 www.nginx.cn访问
        server_name  www.nginx.cn;

        #定义服务器的默认网站根目录位置
        root html;

        #设定本虚拟主机的访问日志
        access_log  logs/nginx.access.log  main;

        #默认请求
        location / {

            #定义首页索引文件的名称
            index index.php index.html index.htm;

        }

        # 定义错误提示页面
        error_page   500 502 503 504 /50x.html;
        location = /50x.html {
        }

        #静态文件，nginx自己处理
        location ~ ^/(images|javascript|js|css|flash|media|static)/ {

            #过期30天，静态文件不怎么更新，过期可以设大一点，
            #如果频繁更新，则可以设置得小一点。
            expires 30d;
        }

        #PHP 脚本请求全部转发到 FastCGI处理. 使用FastCGI默认配置.
        location ~ .php$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

        #禁止访问 .htxxx 文件
            location ~ /.ht {
            deny all;
        }

    }
}
~~~

 * 例子 https & ws
~~~
 #代理https
 upstream web {
    server 0.0.0.0:3000;      
 }
 #代理websocket
 upstream websocket {
    server 0.0.0.0:3000;   
 }
 server { 
    listen       443; 
    server_name  localhost;
    ssl          on;
    ssl_certificate     /cert/cert.crt;#配置证书
    ssl_certificate_key  /cert/cert.key;#配置密钥
    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  50m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 SSLv2 SSLv3;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    #charset koi8-r;
    #access_log  logs/host.access.log  main;

  #wss 反向代理  
  location /wss {
     proxy_pass http://websocket/; # 代理到上面的地址去
     proxy_read_timeout 60s;
     proxy_set_header Host $host;
     proxy_set_header X-Real_IP $remote_addr;
     proxy_set_header X-Forwarded-for $remote_addr;
     proxy_set_header Upgrade $http_upgrade;
     proxy_set_header Connection 'Upgrade';	
  }
  #https 反向代理
  location / {
     proxy_pass         http://web/;
     proxy_set_header   Host             $host;
     proxy_set_header   X-Real-IP        $remote_addr;
     proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
  }
}
~~~

####  免费的容器镜像服务

> [阿里云`/fp-api/front`](https://cr.console.aliyun.com/repository/cn-hangzhou/fp-api/front/detail)

  1. 登录阿里云Docker Registry
~~~
  $ sudo docker login --username=angenal@hotmail.com registry.cn-hangzhou.aliyuncs.com
~~~
  2. 从Registry中拉取镜像
~~~
  $ sudo docker pull registry.cn-hangzhou.aliyuncs.com/fp-api/front:[镜像版本号]
~~~
  3. 将镜像推送到Registry
~~~
  # [ImageId]和[镜像版本号]参数(用 docker images 查询)
  # 　公网地址：registry.cn　经典内网：registry-internal.cn　专有网络：registry-vpc.cn
  $ sudo docker tag [ImageId] registry.cn-hangzhou.aliyuncs.com/fp-api/front:[镜像版本号]
  $ sudo docker push registry.cn-hangzhou.aliyuncs.com/fp-api/front:[镜像版本号]
~~~

#### 免费的开发服务器

> [转发服务`ngrok`](https://dashboard.ngrok.com/get-started)

~~~
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

----


## Linux常用命令

    Shell连接符：
      && <中间> 连接两条命令并按顺序执行;
      &  <结尾> 使命令程序脱离终端进程在后台执行;

#### 一、Linux下常用命令：文件与目录操作
~~~
basename：从文件名中去掉路径和扩展名
cd：切换当前工作目录到指定目录
chgrp：改变文件所属组
chmod：改变文件的权限
chown：改变文件的所有者和组
cp：复制文件或目录
dd：复制文件并转换文件内容
file：确定文件类型
find：在指定目录下查找文件并执行指定的操作
ln：创建文件链接
locate/slocate：快速定位文件的路径
ls/dir/vdir：显示目录内容
mkdir：创建目录
mv：移动或重命名文件
pwd：显示当前工作目录
rename：重命名文件
rm：删除文件或目录
rmdir：删除空目录
touch：修改文件的时间属性
updatedb：创建或更新slocate数据库
whereis：显示指令程序、源代码和man手册页
which：显示指令的绝对路径
~~~

#### 二、Linux下常用命令：备份与压缩 ar：创建、修改归档文件和从归档文件中提取文件
~~~
arj：.arj文件压缩指令
bunzip2：压缩bzip2格式的压缩文件
bzcat：解压缩文件到标准输出
bzip2：创建.bz2格式的压缩文件
bzip2recover：修复损坏的.bz2文件
bzless/bzmore：解压缩.bz2文件并分屏显示内容
compress：压缩数据文件
cpio：存取归档包中的文件
dump：文件系统备份
gunzip：解压缩由gzip压缩的文件
gzexe：压缩可执行程序
gzip：GNU的压缩和解压缩工具
lha：压缩和解压缩指令
resotre：还原由dump备份的文件或文件系统
tar：创建备份档案文件
unarj：解压缩.arj文件
uncompress：解压缩.Z文件
unzip：解压缩.zip文件
zcat：解压缩文件并送到标准输出
zforce：强制gzip格式的文件加上.gz扩展名
zip：压缩文件
zipinfo：显示zip压缩文件的详细信息
znew：将“.Z”文件转换成“.gz”文件
~~~

#### 三、Linux下常用命令：文本处理
~~~
cat：链接文件并显示到标准输出
cksum：检查和计算文件循环冗余校验码
cmp：比较两个文件的差异
col：过滤控制字符
colrm：从输入中过滤掉指定的列
comm：比较两个有序文件的不同
csplit：分割文件
cut：显示文件中每行的指定内容
diff3：比较3个文件的不同
diff：比较并显示两个文件的不同
diffstat：根据diff指令的结果显示统计信息
ed：行文本编辑器
emacs：全屏文本编辑器
ex：文本编辑器
expand：将Tab转换为空白（Space）
fmt：最优化文本格式
fold：设置文件显示的行宽
grep/egrep/fgrep：显示文件中匹配的行
head：输出文件开头部分内容
ispell：交互式拼写检查程序
jed：文本编辑器
joe：编辑文本文件
join：合并两个文件的相同字段
less：分屏查看文本文件
look：显示文件中以特定字符串开头的行
more：分屏查看文本文件
od：以数字编码输出文件内容
paste：合并文件的内容
pico：文本编辑器
sed：流文件编辑器
sort：排序数据文件
spell：拼写检查
split：分割文件
sum：计算并显示文件的校验码
tac：反序显示文件内容
tail：输出文件尾部部分内容
tee：将输入内容复制到标准输出和指定文件
tr：转换或删除文件中的字符
unexpand：将空白（Space）转换为Tab
uniq：删除文件中的重复行
vi：全屏文本编辑器
wc：计算文件的字节数、单词数和行数
~~~

#### 四、Linux下常用命令：shell指令
~~~
alias：定义命令别名
bg：将作业（或任务）放到后台运行
bind：显示或设置键盘配置
declare：声明shell变量
dirs：显示shell目录堆栈中的记录
echo：打印字符串到标准输出
enable：激活与关闭shell内部命令
eval：执行指定指令并返回结果
exec：执行给定指令后退出登录
exit：退出当前shell
export：设置与显示环境变量
fc：编辑并执行历史命令
fg：将后台任务（或作业）切换到前台运行
hash：显示与清除指令时运行查询的哈希表
history：显示与操纵历史命令
jobs：显示shell的作业信息
kill：杀死进程或作业
logout：退出登录shell
popd：从shell目录堆栈中删除记录
pushd：向shell目录堆栈中添加记录
set：设置shell的执行方式
shopt：设置控制shell行为变量的开关值
ulimit：设置shell的资源限制
umask：设置创建文件的权限掩码
unalias：取消由alias定义的命令别名
unset：删除定义的变量或函数
~~~

#### 五、Linux下常用命令：打印相关指令 accept：接受打印请求
~~~
cancel：取消打印任务
disable：停止打印机
enable：启动打印机
lp：打印文件
lpadmin：配置cups打印机和类
lpc：控制打印机
lpq：显示当前打印队列
lpr：打印文件
lprm：删除当前打印队列中的作业
lpstat：显示CUPS的状态信息
pr：打印前转换文本格式
reject：拒绝打印请求
~~~

#### 六、Linux下常用命令：其他基础指令 bc：实现精确计算的计算器
~~~
cal：显示日历
clear：清屏指令
consoletype：显示当前使用的终端类型
ctrlaltdel：设置热键Ctrl+Alt+Del的功能
date：显示和设置系统日期时间
dircolors：设置ls指令显示时的颜色
eject：弹出可移动设备的介质
halt：关闭计算机
hostid：显示当前主机的数字标识
hwclock：查询和设置系统硬件时钟
info：读取帮助文档
login：登录系统
man：显示联机帮助手册
md5sum：计算并显示文件的md5摘要信息
mesg：设置终端写权限
mtools：显示mtools软件包的指令
mtoolstest：测试并显示mtools工具包的配置
poweroff：关闭计算机并切断电源
reboot：重新启动计算机
shutdown：关闭计算机
sleep：睡眠指定长的时间
stat：显示文件或文件系统的状态
talk：与其他用户交谈
wall：向所有终端发送信息
whatis：在数据库中查询关键字
who：显示当前已登录用户的信息
whoami：显示当前用户名
write：向指定用户终端发送信息
yes：不断输出指定字符串
~~~

#### 七、Linux下常用命令：用户管理 chfn：改变用户的finger信息
~~~
chsh：改变用户登录时的默认shell
finger：用户信息查询程序
gpasswd：管理组文件/etc/group
groupadd：创建组
groupdel：删除组
groupmod：修改组信息
groups：显示用户所属的组
grpck：验证组文件/etc/group的完整性
grpconv：启用组的影子口令文件
grpunconv：关闭组的影子口令文件
logname：显示登录用户名
passwd：设置用户密码
pwck：验证用户文件密码文件的完整性
pwconv：启用用户的影子口令文件
pwunconv：关闭用户的影子口令文件
su：切换用户
useradd：创建用户
userdel：删除用户
usermod：修改用户的配置信息
users：显示当前登录系统的用户名
~~~

#### 八、Linux下常用命令：进程管理 init：进程初始化控制
~~~
killall：根据名称结束进程
nice：设置进程优先级
nohup：以忽略挂起信号方式运行程序
pgrep：基于名字查询并显示进程号
pidof：查找正在运行程序的进程号
pkill：向指定的进程发送信号
ps：显示系统当前的进程状态
pstree：用树形图显示进程的父子关系
renice：调整进程优先级
w：显示当前登录用户的相关信息
watch：全屏方式显示指定命令的输出信息
~~~

#### 九、Linux下常用命令：磁盘与文件系统管理
~~~
badblocks：磁盘坏块检查工具
blockdev：从命令行调用块设备的ioctl函数
chattr：改变文件的第2扩展文件系统属性
convertquota：转换quota文件格式
df：报告磁盘剩余空间情况
dumpe2fs：显示ext2/ext3文件系统信息
e2fsck：检查ext2/ext3文件系统
e2image：保存ext2/ext3源数据到文件
e2label：设置ext2/ext3文件系统标签
edquota：编辑用户的磁盘空间配额
fdisk：Linux下的分区工具
findfs：查找文件系统
fsck：检查与修复Linux文件系统
grub：Linux下的引导加载器
hdparm：调整硬盘I/O性能
lilo：Linux加载器
lsattr：显示文件的ext2文件系统属性
mkbootdisk：为当前系统创建专门的引导软盘
mke2fs：创建第2扩展文件系统
mkfs：创建各种文件系统
mkinitrd：创建初始化ram磁盘映像文件
mkisofs：创建光盘映像文件
mknod：创建块设备或字符设备文件
mkswap：创建交换分区文件系统
mktemp：创建临时文件
mount：加载文件系统
parted：磁盘分区管理工具
quota：显示用户磁盘配额
quotacheck：创建、检查和修复配额文件
quotaoff：关闭文件系统的磁盘配额功能
quotaon：打开文件系统的磁盘配额功能
quotastat：显示磁盘配额状态
repquota：显示文件系统磁盘配额信息报表
swapoff：关闭交换空间
swapon：激活交换空间
sync：强制将缓存数据写入磁盘
tune2fs：调整ext2/ext3文件系统的参数
umount：卸载已经加载的文件系统
~~~

#### 十、Linux下常用命令：内核与性能
~~~
depmod：处理内核可加载模块的依赖关系
dmesg：显示内核的输出信息
free：显示内存使用情况
insmod：加载模块到内核
iostat：报告CPU、I/O设备及分区状态
ipcs：显示进程间通信的状态信息
kernelversion：显示内核主版本号
lsmod：显示已加载的模块
modinfo：显示内核模块信息
modprobe：加载内核模块并解决依赖关系
mpstat：显示进程相关状态信息
rmmod：从内核中删除模块
sar：收集、显示和保存系统活动信息
slabtop：实时显示内核的slab缓存信息
sysctl：运行时修改内核参数
tload：监视系统平均负载情况
top：显示和管理系统进程
uname：显示系统信息
uptime：显示系统运行时间及平均负载
vmstat：显示虚拟内存的状态
~~~

#### 十一、Linux下常用命令：X-Window系统
~~~
startx：初始化X-Window会话
xauth：X系统授权许可文件管理工具
xhost：显示和配置X服务器的访问权限
xinit：X-Window系统初始化程序
xlsatoms：显示X服务器原子数据定义
xlsclients：显示指定显示器上运行的X程序
xlsfonts：显示X服务器使用的字体信息
xset：设置X系统的用户偏爱属性
~~~

#### 十二、Linux下常用命令：系统安全
~~~
chroot：以指定根目录运行指令
nmap：网络探测工具和安全扫描器
scp：加密的远程复制工具
sftp：安全文件传输工具
slogin：加密的远程登录工具
ssh：加密的远程登录工具
sudo：以另一个用户身份执行指令
~~~

#### 十三、Linux下常用命令：编程相关指令
~~~
awk/gawk：模式扫描与处理语言
expr：计算表达式的值
gcc：GNU的C语言编译器
gdb：GNU调试器
ldd：显示共享库依赖
make：工程编译工具
nm：显示目标文件的符号表
perl：perl语言的命令行工具
php：PHP脚本语言命令行接口
test：条件测试
~~~

#### 十四、Linux下常用命令：其他系统管理与维护指令
~~~
arch：显示当前主机的硬件架构
at：按照时间安排任务的执行
atq：查询待执行的任务
atrm：删除待执行的任务
batch：在指定时间运行任务
chkconfig：设置系统在不同运行等级下所执行的服务
crontab：按照时间设置计划任务
last：显示以前登录过系统的用户相关信息
lastb：显示登录系统失败的用户相关信息
logrotate：系统日志的轮循工具
logsave：将命令的输出信息保存到日志文件
logwatch：报告和分析系统日志
lsusb：显示所有的USB设备
patch：补丁与更新文件
rpm：Red Hat软件包管理器
runlevel：显示当前系统的运行等级
service：Linux服务管理和控制工具
telinit：切换当前系统的运行等级
yum：RPM软件包自动化管理工具
~~~

#### 十五、Linux下常用命令：网络配置
~~~
dnsdomainname：显示系统的DNS域名
domainname：显示和设置主机域名
hostname：显示或者设置系统主机名
ifcfg：配置网络接口
ifconfig：配置网络接口的网络参数
ifdown：关闭指定网络接口
ifup：启动指定网络接口
nisdomainname：显示和设置主机域名
route：显示与操纵本机的IP路由表
ypdomainname：显示和设置主机域名
~~~

#### 十六、Linux下常用命令：网络测试与应用
~~~
arp：管理本机arp缓冲区
arping：向相邻主机发送ARP请求报文
arpwatch：监听网络上的ARP信息
dig：域名查询工具
elinks：纯文本网页浏览器
elm：电子邮件客户端程序
ftp：文件传输协议客户端
host：DNS域名查询工具
ipcalc：IP地址计算器
lynx：纯文本网页浏览器
mail：电子邮件管理程序
ncftp：增强的FTP客户端工具
netstat：显示网络状态
nslookup：DNS域名查询工具
pine：电子邮件和新闻组处理程序
ping：测试到达目标主机的网络是否通畅
rsh：远程shell
telnet：远程登录工具
tftp：简单文件传输协议客户端
tracepath：追踪数据经过的路由
traceroute：追踪数据包到达目的主机经过的路由
wget：从指定URL地址下载文件
~~~

#### 十七、Linux下常用命令：高级网络指令 arptables：管理内核的ARP规则表
~~~
ip：强大的多功能网络配置工具
iptables：IP包过滤与NAT管理工具
iptables-save：保存内核中iptables的配置
iptables-restore：还原iptables的配置信息
tcpdump：监听网络流量
~~~

#### 十八、Linux下常用命令：网络服务器指令
~~~
ab：Web服务器性能测试
apachectl：Apache HTTP服务器控制接口
exportfs：管理NFS服务器共享的文件系统
htdigest：管理用于摘要认证的用户文件
htpasswd：管理用于基本认证的用户文件
httpd：Apache超文本传输协议服务器
mailq：显示待发送的邮件队列
mysql：MySQL服务器的客户端工具
mysqladmin：MySQL服务器管理工具
msqldump：MySQL服务器备份工具
mysqlimport：MySQL数据库导入工具
mysqlshow：显示MySQL数据库、表和字段信息
nfsstat：显示网络文件系统状态
sendmail：电子邮件传送代理程序
showmount：显示NFS服务器上的加载信息
smbclient：samba服务器客户端工具
smbmount：加载samba文件系统
smbpasswd：改变samba用户的密码
squid：HTTP代理服务器程序
sshd：OpenSSH守护进程
# 安装服务sshd
  # < centos >--------------------------- 
  $ rpm -qa | grep ssh  # 检查服务ssh是否已安装: netstat -antp | grep sshd [端口:22]
  $ yum install -y initscripts # 安装服务netstat [/sbin/service]
  $ yum install -y openssh-server # 安装服务ssh
  $ service sshd start | service sshd stop # 启动sshd|停止
  $ chkconfig sshd on # 开机启动
  # < ubuntu >--------------------------- Ubuntu 18.04 LTS on Windows 10
  $ sudo apt-get remove --purge openssh-server   # 先删ssh -(可忽略此操作)
  $ sudo apt-get install openssh-server          # 再安装ssh
  $ sudo rm /etc/ssh/ssh_config                  # 先删配置文件, 让ssh服务自己想办法链接-(可忽略此操作)
  $ sudo ssh-keygen -A                           # 先生成主机keys-(当提示Could not load host key)
  $ sudo service ssh --full-restart              # 再启动ssh +(设置登录后)
  # systemctl------------------------------------
  $ systemctl start sshd   # systemctl启动sshd
  $ systemctl status sshd  # systemctl查看状态
  $ systemctl enable sshd  # systemctl开机启动生效
    ln -s '/usr/lib/systemd/system/sshd.service' '/etc/systemd/system/multi-user.target.wants/sshd.service'
  $ systemctl disable sshd # systemctl关闭开机启动
    rm '/etc/systemd/system/multi-user.target.wants/sshd.service'
  # root-login------------------------------------
  $ sudo passwd root              # 修改root密码，用于root登录ssh
  $ sudo vim /etc/ssh/sshd_config # 修改配置文件 > # Authentication: (全部启用,去除#)
    # vim命令（:w 编辑模式, :i 插入模式, :x 回车保存, :qa! 退出不保存, gg dG 清空文件）
    > PermitRootLogin yes         # 启用root登录  #PermitRootLogin prohibit-password
    > sudo service ssh restart    # 重启ssh
~~~

#### 上传文件
~~~bash
#!/bin/bash
# hmac_keys_in mark=Z2VoZWlt
#
UPLOADER="mark"
SECRET="geheim"

TIMESTAMP="$(date --utc +%s)"
# length and contents are not important, "abcdef" would work as well
NONCE="$(cat /dev/urandom | tr -d -c '[:alnum:]' | head -c $(( 32 - ${#TIMESTAMP} )))"

SIGNATURE="$(printf "${TIMESTAMP}${NONCE}" \
             | openssl dgst -sha256 -hmac "${SECRET}" -binary \
             | openssl enc -base64)"

# order does not matter; any skipped fields in Authorization will be set to defaults
exec curl -T \
  --header "Timestamp: ${TIMESTAMP}" \
  --header "Token: ${NONCE}" \
  --header "Authorization: Signature keyId='${UPLOADER}',signature='${SIGNATURE}'" \
  "<filename>" "<url>"
~~~

