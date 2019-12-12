# **系统命令**

# [**windows-cmd**](https://github.com/Awesome-Windows/awesome-windows-command-line) | [windows-tool](https://github.com/Awesome-Windows/Awesome) | [shell](https://github.com/fengyuhetao/shell) | [**linux**](https://wangchujiang.com/linux-command/hot.html) 
> [`All Linux Command`](https://ss64.com/bash/)、[`All Windows CMD`](https://ss64.com/nt/)<br>
> [`《Linux就该这么学》pdf`](https://www.linuxprobe.com/docs/LinuxProbe.pdf)、
  [`《Linux基础课程》video`](https://www.linuxprobe.com/chapter-01.html)<br>

 * [Windows10安装Linux子系统(WSL)](https://www.cnblogs.com/xiaoliangge/p/9124089.html)
 * [Linux开发环境及常用安装zsh-ssh-git-redis-mysql-mongodb-pilosa-influxdb-grafana-nsq.kafka.rabbitmq...](#linux开发环境及常用安装)
 * [Linux常用命令ls-find-grep-xargs-sort-uniq-tr-wc-sed-awk-head-tail...](#Linux常用命令)
 * [docker](#docker) | [k8s](#Kubernetes) | [Minikube](#Minikube) | [Consul](#Consul) | [etcd](#Etcd) 
　[`免费的容器镜像服务`](#免费的容器镜像服务)、[`免费的开发服务器`](#免费的开发服务器)

~~~shell
  # 清屏
  > cls
  $ clear         # 快捷命令: alias cls='clear'
  
  # 系统
  > ver              # 系统  修复 > sfc/scannow
  > net config workstation
  > shell:startup    # [开始]菜单/启动/添加*.vbs
  $ uname -a         # 系统信息: $(uname -s)=系统'Linux'; $(uname -m)=CPU架构'x86_64';
  $ egrep -c ' lm ' /proc/cpuinfo  &&  egrep -c '(vmx|svm)' /proc/cpuinfo
  # 系统版本号'发行版本'*** Linux-redhat > cat /etc/redhat-release
  $ cat /etc/issue && lsb_release -cs ; lsb_release -a #Linux发行版本信息
  $ echo "Linux-x86_64" && echo $(uname -s)-$(uname -m) && echo `uname -s`-`uname -m`
  
  # 时间
  > wmic OS Get localdatetime /value # 当前本地时间
  # 工具 1.下载 http://sourceforge.net/projects/unxutils 2.解压,重命名usr/local/wbin/date.exe为unixdate.exe
  > unixdate --help         # 帮助
  > unixdate +%s            # 当前时间戳 (unix timestamp)
  > unixdate "+%Y/%m/%d %X" # 当前本地时间 yyyy/MM/dd HH:mm:ss
  $ date -u "+%Y/%m/%d %X"  # 当前UTC时间 yyyy/MM/dd HH:mm:ss
  $ TZ=Asia/Shanghai date +%FT%T%z # 当前时间2019-11-11T11:11:11+0800
  $ TIMESTAMP="$(date --utc +%s)" # 时间戳+签名认证
  $ SECRET=123456 && TOKEN="$(cat /dev/urandom|tr -d -c '[:alnum:]'|head -c $(( 32 - ${#TIMESTAMP} )))"
  $ SIGNATURE="$(printf "${TIMESTAMP}${TOKEN}"|openssl dgst -sha256 -hmac "${SECRET}" -binary|openssl enc -base64)"
  $ echo "Authorization: signature=${SIGNATURE},secret=${SECRET},token=${TOKEN},timestamp=${TIMESTAMP}"
  $ /usr/share/zoneinfo/localtime -> /etc/localtime  # 本地时间文件
  $ export TZ='Asia/Shanghai' # 设置本地时区 | 帮助选择时区的命令tzselect |配置文件vi ~/.profile<TZ='Asia/Shanghai'
  $ date "+%Y/%m/%d %X"     # 打印当前本地时间 | 本地日期 date +%Y%m%d | $(Hardware-Clock) hwclock
  $ date --date='TZ="Europe/Paris" 2004-10-31 06:30:00' # 修改时区&时间
  $ echo $(date +%Y%m%d)    # 打印当前本地时间-变量
  # <Windows+Ubuntu>双系统时间同步问题  | www.jianshu.com/p/cf445a2c55e8
  $ sudo timedatectl set-local-rtc 1   # Ubuntu先将RTC硬件时间由UTC改为CST(中国标准时间);然后设置"日期和时间";
  $ sudo hwclock --localtime --systohc # 然后,同步机器时间(将CST本地时间更新到RTC硬件时间;Windows使用的RTC为CST)
  
  # 帮助
  > help cmd
  $ info       # 系统菜单信息: Basics,Compression,Editors,Screen.…… 菜单导航&帮助文档;
   #系统菜单信息: GNU Utilities,Individual utilities,Libraries,Math,Network applications,Text manipulation
  $ man        # 在线帮助说明
  $ whatis id  # 查找命令id的帮助说明 print real and effective user and group IDs
  $ history    # 历史命令列表
  
  # 用户登陆
  > mkdir -p %USERPROFILE% # 用户目录
  > mkdir to/path # 创建目录 $ mkdir -p to/path  [-p递归创建目录]
  $ cd -          # 上次访问目录; 用户$HOME目录 > cd ~ ; cd /home/$(whoami) # root 用户为 cd ~  = /root 
  > quser         # 当前用户状态
  $ whoami && w && id  # 当前用户信息
  $ echo -e "$USER\n$HOME\n$SHELL\n$PATH\n$LOGNAME\n$MAIL" # 当前用户环境 [-e允许反斜杠转义字符]
  $ id            # 返回 uid=0(root) gid=0(root) groups=0(root)  ; root登录:  su - ; su root
  $ id -u         # 返回 uid          添加用户(-d=$home)      (-G=多选用户组)       例如(用户名=admin)
  $ mkdir -p /home/admin & chmod 777 /home/admin 
  # 新建用户 - 默认值: useradd -D  |  cat /etc/default/useradd ;修改默认shell: useradd -D -s /bin/zsh
  $ useradd -d /home/admin -G adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare,libvirt admin
  # 修改密码
  $ passwd admin 
  # 修改用户多选组-G=groups   ;查用户组${id -g 用户名} $ groups yangzhou
  $ usermod -G yangzhou,adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare,docker,mysql,mongodb,libvirt,rabbitmq yangzhou
  $ usermod -aG rabbitmq yangzhou # 直接添加组给用户
  # 查询用户信息
  $ sudo grep $USER /etc/passwd /etc/shadow /etc/group /etc/gshadow
  
  $ sudo su -      # 切换用户至root (并切换到用户主目录/root；超级用户提示符结尾 # 普通用户$ 主目录/home/*)
  $ su admin       # 切换用户至admin
  $ exit           # 退出登录
  
  $ cat /etc/passwd # 查看所有用户
  $ cat /etc/passwd |grep `id -un` # 查看当前登录用户
  $ login           # 用户登录
  $ cat /etc/shadow # 用户列表
  $ userdel -r admin# 删除用户
  $ cat /etc/group  # 用户组列表
  $ groups          # 用户所在组
  $ groupadd        # 添加用户组
  
  # 网络端口
  > netstat -anT                              # tcp端口(本地地址,外部地址,状态)
  > netstat -anp tcp|findstr -i "listening"   # tcp端口-监听列表; [p传输协议]
  $ netstat -anp|grep 3306                    # 1.通过端口查看进程; 2.通过进程id查看占用端口; [p显示进程]
  $ sudo netstat -anpW |grep -i "grafana-server" # 网络端口资源查找; [端口tcp+udp]
  $ sudo netstat -anptW|grep -i "listen"         # 网络端口资源列表; [端口tcp] 本机所有tcp网络应用程序列表
  $ netstat -atW |grep -i "listen"            # tcp端口-centos $ yum install -y net-tools traceroute
  $ netstat -tulnp | grep -i "time_wait"      # tcp超时-ubuntu $ apt-get update & apt install -y net-tools
  $ ss -t4 state time-wait                    # tcp超时-ubuntu $ apt install -y iproute2 iproute2-doc
  $ ss -at '( dport = :ssh or sport = :ssh )' # 端口为 ssh 的套接字
  $ ss -lntp '( dst :443 or dst :80 )'        # 目的端口为 80,443 的套接字
  $ ss -lntp  # tcp端口+users进程name-pid-fd  # 常用ss(iproute工具)比netstat(net-tools工具)更强大
  $ ss -nt state connected dport = :80
  $ ss -nt dport lt :100  # 端口小于100
  $ ss -nt dport gt :1024 # 端口大于1024
  $ ss -aup   # udp端口
  
  # 进程详情
  > tasklist
  > wmic process where "caption = 'java.exe' and commandline like '%server-1.properties%'" get processid
  > netstat -ano | findstr :3000 # 杀死进程使用, 指定占用的端口号
  > taskkill /F /PID <<PID>>     # PowerShell
  $ ps aux                       # 进程列表: USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
  $ ps -eo pid,cmd | grep uuid   # [o输出字段,e依赖的系统环境]
  $ ps -u $USER -o pid,%cpu,tty,cputime,cmd
  $ ps -ef | grep dotnet         # 查看dotnet进程id
  $ top -Hp [进程id]             # 进程列表: 内存&CPU占用
  $ dotnet-dump collect -p [进程id] ; dotnet-dump analyze core_***  # 查找.NET Core 占用CPU 100% 的原因
    > clrthreads ; setthread [线程DBG] ; clrstack ; clrstack -a ; dumpobj 0x00*** # 分析线程/堆栈/内存数据
  $ ps aux | head -1; ps aux | sort -rn -k3 | head -10 # 占用CPU最高的前10个进程
  $ ps -e -o stat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}' | xargs kill -9 # 批量删除(Z开头)僵尸进程
  $ killall            # 杀死进程使用, 杀死单个进程: kill -9 [ProcessId] (-9=KILL)
  $ kill -l            # 查看软件中断SIG [Linux标准信号1~31] (实时信号:32~64)
  $ lsof -i @localhost:3000 && kill -9 <<PID>> # 杀死进程使用, 指定占用的端口号
  $ lsof -i:22         # 查看22端口连接情况(默认为sshd端口) lsof 列出当前系统打开的文件(list open files)
  $ smem -k -s USS     # 进程的内存使用情况
  # < ubuntu > apt update & apt install smem
  # < centos > yum install epel-release & yum install smem python-matplotlib python-tk
  
  # 文件系统
  > dir [目录]           # 默认当前目录(命令pwd)
  $ ls -al [目录]        # 查看目录及文件读写权限 alias ll='ls -alF' ; alias la='ls -A' ; alias l='ls -CF'
  $ touch main.js        # 新建文件
  $ mv main.js main.cs   # 重命名文件,移动文件位置
  $ cat main.cs          # 输出文件内容
  $ namo|vi main.cs      # 编辑文件内容
  $ file main.js && ls -an main.js # 查看文件类型-信息 & 查看文件读写权限&更新时间
  $ for n in {1..10000}; do echo content > "__${n}.tmp"; done # 创建 10000 个临时文件
  
  # 文件查找
  > for /r C:\windows\addins\ %i in (explorer.exe) do @echo %i # 在指定目录下查找匹配文件
  $ locate /bin/ps          # 遍历文件系统/路径包含/bin/ps所有匹配文件
  $ find / -name [filename] # 查找在根目录下/所有匹配文件
  $ find /etc -type f -name passwd
  
  # 目录访问权限
  > cd [目录]
  $ sudo chown -R 1000 [目录]  # 改变[目录](-R递归修改文件和目录)的"拥有者"为uid:1000 = $(id -u)
  $ sudo chgrp –R users [目录] # 改变[目录]的"所属用户组"为G:users = $(id -g)
  $ sudo chmod 744 [目录]      # 修改当前目录(.)权限为可读写及执行(-R递归修改文件和目录)
  $ sudo chmod 777 to/path    # 每个人都有读和写以及执行的权限(约定的三个数字owner=7;group=7;others=7)
  $ sudo chmod 666 to/path    # 每个人都有读和写的权限(常用于文件上传下载)
  $ sudo chmod 700 to/path    # 只有所有者有读和写以及执行的权限
  $ sudo chmod 600 to/path    # 只有所有者有读和写的权限
  $ sudo chmod 644 to/path    # 所有者有读和写的权限，组用户只有读的权限
  $ [ -d /temp ] ||  sudo mkdir /temp && sudo chmod -vR 1777 /temp # 创建共享临时目录 drwxrwxrwt
  $ sudo chmod -vR +t /temp   # 添加目录[文件删除+重命名]的权限 ...rwt
  #0 : None  #1 : Execute Only  #2 : Write Only  #3 : Write & Execute  #4 : Read Only  #5 : Read & Execute  
  #6 : Read & Write  #7 : Read, Write & Execute
  
  # 文件复制
  > xcopy "来源目录" "目标目录" /E /H /K /X /Y
  > xcopy /isy C:\...\bin\Release\netcoreapp2.1\* F:\app\dotnetcore\centos\a
  > robocopy /e source destination [file [file]...] # Windows的可靠文件复制/备份  帮助: robocopy /?
  $ cp -if /mnt/floppy/* ~/floppy                   # [~/floppy 指向 /root/floppy 或 /home/floppy]
  $ cp -if /mnt/d/Docker/App/ubuntu/usr/local/bin/* /usr/local/bin # [i覆盖文件时,询问?]
  $ cp -fr /usr/local/bin/* /mnt/d/Docker/App/ubuntu/usr/local/bin # [r复制文件目录!]
  # 创建目录的`符号链接(软链接)`
  > mklink /d "来源目录" "目标目录"
  $ ln -s '来源目录' '目标目录'
  # 创建目录的`目录联接(硬链接)`
  > mklink /j "来源目录" "目标目录"
  $ ln -f '来源文件' '目标文件'  #-f强制(可选参数)
  
  # 系统备份和还原
  $ tar -czpvf /media/yangzhou/Software/Software/ubuntu/backup@`date +%Y`.tar.gz 
      --exclude=/proc --exclude=/tmp --exclude=/boot --exclude=/home --exclude=/lost+found 
      --exclude=/media --exclude=/mnt --exclude=/run / #-c备份文档 -z用gzip压缩 -p保存权限 -v显示详细 -f输出文件
  $ tar -xzpvf /media/yangzhou/Software/Software/ubuntu/backup@`date +%Y`.tar.gz -C /
  # linux-live-U盘+启动盘制作
  $ df -h                  # 查找U盘位置<假如为sdb>
  $ sudo ntfs-3g /dev/sda1 /mnt/windows  # 挂载硬盘分区<假如为sda1:第1块硬盘分区1>
  $ sudo /sbin/mount.ntfs /dev/sdc2 /40g -o rw,nosuid,nodev
  $ sudo /sbin/mount.ntfs /dev/sdc3 /20g -o rw,nosuid,nodev
  $ sudo umount /dev/sdb*  # 手动卸载 U盘
  $ sudo mkfs.vfat /dev/sdb -I  # 格式化 U盘
  $ sudo dd if=~/ubuntu.iso of=/dev/sdb  # 制作 U盘启动盘
  
  # 文件删除
  > del /f /s /q [目录|文件]
  > rd /s /q %windir%\temp & md %windir%\temp [删除临时文件]
  $ rm -f -r [r删除目录,否则删除文件] [f强制] [rmdir移除空目录]
  
  # 网络地址 - inet&inet6
  > ipconfig /?
  > hostname     # `主机名`
  $ hostname -i  # 127.0.1.1
  $ ifconfig |grep inet
  $ ifconfig |grep 'inet ' |head -5  # 获取前5条ipV4
  $ ifconfig |grep 'inet6' |head -5  # 获取前5条ipV6
  # 科学上网 - 代理设置 (解决网络问题)  蓝灯: https://github.com/getlantern/lantern
  $ sudo vim /etc/profile [全局|用户配置：~/.profile]# 填写如下VPN转发PORT
  export FTP_PROXY=http://<proxy hostname:port>     # 临时使用
  export HTTP_PROXY=http://<proxy hostname:port>
  export HTTPS_PROXY=https://<proxy hostname:port>
  export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24
  # 主机环境 - 解析设置 github.com/googlehosts/hosts
  > notepad C:\Windows\System32\drivers\etc\hosts
  > set                 # 查看系统环境变量windows
  $ export              # 查看系统环境变量linux
  $ cat /etc/hosts      # 一次显示整个文件
  $ cat > /etc/hosts    # 从键盘创建一个文件
  # 刷新dns缓存
  > ipconfig /flushdns
  $ sudo killall -HUP mDNSResponder
  $ sudo dscacheutil -flushcache
  
  # 网络共享
  > net share           # 查找
  > net share c         # 添加
  > net share c /delete # 删除
  
  # 关机命令
  > sleep 9000; shutdown -s
  > at 03:30:00PM shutdown -s
  > schtasks /create /sc once /tn "auto shutdown my computer" /tr "shutdown -s" /st 15:30
  > at 11:00:00PM /every:M,T,W,TH,F,SA,SU shutdown -s
  > at 11:00:00PM shutdown -r [r重启]
  
  # 系统硬件驱动
  > devmgmt.msc
  $ df -h      # 文件系统   容量  挂载点
  $ sudo fdisk -l
  # linux硬件设备-挂载点
  /dev/char
  /dev/cdrom   # 光驱
  /dev/console
  /dev/core -> /proc/kcore
  /dev/cpu
  /dev/disk
  /dev/fd -> /proc/self/fd  # 软驱 /dev/fd[0-1] | dockerd -H fd://
  /dev/initctl -> /run/systemd/initctl/fifo
  /dev/input
  /dev/log -> /run/systemd/journal/dev-log
  /dev/lp      # 打印机 /dev/lp[0-15] 
  /dev/mem
  /dev/memory_bandwidth
  /dev/mouse   # 鼠标
  /dev/mqueue
  /dev/net
  /dev/null
  /dev/port
  /dev/sda{sda1-3,sdb,sdc,$sdd~sdp} # 硬盘 (a~p 代表 16 块不同的硬盘; 数字代表分区数)
  /dev/snapshot
  /dev/stdin -> /proc/self/fd/0
  /dev/stdout -> /proc/self/fd/1
  /dev/stderr -> /proc/self/fd/2
  /dev/tty
  /dev/usb
  /dev/zero
  
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
  
  # 证书：           CA根证书(服务器身份验证)                                # apiserver.crt <=> apiserver.key
    *版本            V1
    *颁发者          acme                                                   # CN = acme
    *使用者          acme-apiserver                                         # CN = acme-apiserver
    *公钥            RSA (2048 Bits)
    *公钥参数         05 00
    *增强型密钥用法   服务器身份验证 (1.3.6.1.5.5.7.3.1)
    *使用者可选名称   DNS Name=localhost \ DNS Name=host.acme.internal \
                     IP Address=0.0.0.0 \ IP Address=10.96.0.1 \ IP Address=192.168.65.3 \ IP Address=127.0.0.1
    *密钥用法         Digital Signature, Key Encipherment, Certificate Signing (a4) #CA已认证$
                     #self.sign-> Digital Signature, Key Encipherment (a0) #自签名,未经CA认证$
    *基本约束         Subject Type=CA \ Path Length Constraint=None
    *指纹             a79be724538b668fa817e8578d6a8078337fd3ad
  
  #1.创建openssl数字签名认证
  $ openssl req -new -nodes -x509 -out conf/server.crt -keyout conf/server.key \
    -days 3650 -subj "/C=DE/ST=NRW/L=Earth/O=Random Company/OU=IT/CN=127.0.0.1/emailAddress=***@example.com"
  #2.安装mkcert数字签名工具 *21k
  $ sudo apt install libnss3-tools  #or: sudo yum install nss-tools #or: sudo pacman -S nss
  $ git clone github.com/FiloSottile/mkcert && go build -ldflags "-X main.Version=$(git describe --tags)"
  $ mkcert -help    #.用于搭建本地CA数字签名认证: CA, Digital Signature, Key Encipherment, Certificate Signing.
  $ mkcert -CAROOT  #1.Print the CA certificate and key storage location: rootCA.pem,rootCA-key.pem
  $ mkcert -install #2.The local CA is installed in the system trust store! #安装本地证书CA服务环境↑↑
  $ mkcert example.com "*.example.com" localhost 127.0.0.1 ::1 #3.创建证书: ./example.com+4.pem,example.com+4-key.pem
  #3.1修改PowerShell脚本执行策略 windows 10
  > Get-ExecutionPolicy
  > Set-ExecutionPolicy RemoteSigned [RemoteSigned,AllSigned,Bypass,Restricted]
  #3.2创建PowerShell数字签名认证 windows 10
  > cd "C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64" # 签名工具makecert [-eku设为代码签名]
  > makecert -n "CN=Api Cert" -a sha1 -eku 1.3.6.1.5.5.7.3.1 -r -sv api-root.pvk api-root.cer -ss Root -sr LocalMachine
  #3.3打开PowerShell查询数字签名证书
  > ls Cert:\CurrentUser\Root | where {$_.Subject -eq "CN=Api Cert"}
  
  # 请求Http资源的工具curl
  $ curl https://www.baidu.com/ |tee baidu.index.html  # 下载并保存html
  $ curl -XGET https://127.0.0.1:8080/v1/user -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1MjgwMTY5MjIsImlkIjowLCJuYmYiOjE1MjgwMTY5MjIsInVzZXJuYW1lIjoiYWRtaW4ifQ.LjxrK9DuAwAzUD8-9v43NzWBN7HXsSLfebw92DKd1JQ" \
    --cacert server.crt --cert server.crt --key server.key  # 开发环境 自签名证书(结合#1.openssl)
  
  # 字体
  $ sudo apt-get install fontconfig                # yum install fontconfig  #<CentOS>
  $ sudo apt-get install ttf-mscorefonts-installer # yum install mkfontscale #安装中文字体
  $ sudo fc-cache -f -v   # 更新字体缓存
  # 输入法
  $ sudo add-apt-repository ppa:fcitx-team/nightly
  $ sudo apt-get install fcitx-pinyin fcitx-sogoupinyin fcitx-googlepinyin # 拼音
  $ sudo apt-get install fcitx-table fcitx-table-wubi fcitx-table-wbpy     # 五笔
  $ sudo apt-get -y install im-config libapt-pkg-perl fcitx fcitx-table-wbpy && im-config -s fcitx # 安装五笔并设置fcitx为默认输入法
~~~

## linux开发环境及常用安装

> [`更新软件源`](https://www.cnblogs.com/xudalin/p/9071902.html) 镜像下载-提高速度 (推荐-阿里源ubuntu`18.04``bionic`)
~~~bash
$ sudo vi /etc/apt/sources.list  # 更新软件源-修改配置文件-内容如下:
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
$ sudo apt-get update && sudo apt-get upgrade # 更新软件源-操作完毕!
~~~

> `zsh`是一款强大的虚拟终端，推荐使用 [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) 配置管理终端
~~~bash
# 安装 zsh
$ sudo apt-get -y install zsh
# 设置终端shell默认为zsh, 输入以下命令后(重启终端>选择>2) [加sudo修改root的默认shell]
$ chsh -s `which zsh`    # 安装完毕
# 安装 antigen 设置主题
$ curl -L https://raw.githubusercontent.com/skywind3000/vim/30b702725847bac4708de34664bb68454b54e0c0/etc/zshrc.zsh > ~/.zshrc
# 修改配置 ~/.zshrc 
#1. # antigen theme +> 添加[主题ys]
antigen theme ys     # 参考 github.com/robbyrussell/oh-my-zsh/wiki/themes
#2. # load local config +> 添加[.bashrc]
[ -f "$HOME/.profile" ] && source "$HOME/.profile"
# 最后再执行 zsh ; 如果出现 compinit 权限问题, 解决如下:
$ sudo chmod -R 755 /usr/local/share/zsh/site-functions
$ source ~/.zshrc # 使配置生效
~~~

> `开发环境搭建` 安装gcc/g++/gdb/make, gtk/glib/gnome, java, dot.NET Core, R, python, nodejs等
~~~shell
  # < Windows Subsystem for Linux | WSL >---------------------------
  $ sudo do-release-upgrade -d        # 升级至18.04LTS ( 如果是16.04? > cat /etc/issue )
  $ lsb_release -c                    # 获取系统代号,更新软件源sources.list
  $ sudo vim /etc/apt/sources.list    # 更新软件源
  $ sudo apt-get update && sudo apt-get upgrade # 更新升级apt
  $ sudo apt-get -y install language-pack-zh-hans # 中文语言包
  $ sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates
  $ sudo apt install openssh-server   # 安装SSH
  $ sudo apt install gcc              # 安装gcc编译工具(可选)
  $ sudo apt install make             # 安装构建工具make(可选)
  $ sudo apt install build-essential  # 安装gcc/g++/gdb/make等工具链
  $ sudo apt install libgtk2.0-dev pkg-config gnome-core # 安装桌面开发gtk/glib/gnome等
  $ sudo apt install default-jre      # 安装jre > java -version
  $ sudo apt install openjdk-8-jdk    # 安装OpenJDK
  $ sudo add-apt-repository ppa:webupd8team/java && sudo apt-get update
  $ sudo apt-get install oracle-java8-installer   # 在线安装, 离线下载 download.oracle.com/otn/java/jdk
  $ sudo apt-get install oracle-java8-set-default # 使用默认版本jdk1.8
  $ sudo update-alternatives –config java         # 多版本JDK之间切换
  
  $ wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
  $ sudo dpkg -i packages-microsoft-prod.deb
  $ sudo apt-get update
  $ sudo apt-get install dotnet-sdk-3.0           # 安装 .NET Core SDK  > dotnet -h
  
  $ sudo apt-get update
  $ sudo apt-get -y install r-recommended --fix-broken # 安装 R 语言(用于统计计算) > /usr/bin/R --help # 大写R
  
  $ sudo apt install -f libncurses5-dev freeglut3-dev fop m4 tk unixodbc unixodbc-dev xsltproc socat # erlang依赖
  $ wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.1-1~ubuntu~xenial_amd64.deb
  $ sudo dpkg -i esl-erlang_22.1-1~ubuntu~xenial_amd64.deb # 安装 erlang 语言(支持CSP消息模型的并发编程语言)
  
  $ sudo apt install python3          # 安装Python3
  $ sudo apt install python3-pip      # 安装pip3         #将Python3设为默认?参考如下
  $ sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100
  $ sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150
  $ sudo update-alternatives --config python  # 手动配置/切换版本: python --version ; pip --version
  $ sudo ln -sf /usr/bin/python2.7 /usr/bin/python # 将Python2(恢复)默认
  
  $ sudo add-apt-repository ppa:ondrej/php  && sudo apt-get update # 安装php (PPA源)
  $ sudo apt-get -y install php7.2-fpm php7.2-mysql php7.2-curl php7.2-gd php7.2-mbstring php7.2-xml php7.2-xmlrpc php7.2-zip php7.2-opcache
  $ sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.2/fpm/php.ini # 设置php 替换 ;cgi.fix_pathinfo=1 为 cgi.fix_pathinfo=0
  $ sudo systemctl restart php7.2-fpm  # 重启php
  $ sudo systemctl status php7.2-fpm   # 检查php状态
  $ sudo apt-get -y install apache2    # 安装apache2
  $ sudo apt-get -y install libapache2-mod-php7.2  # 让apache识别php
  #-config>>  /etc/apache2/apache2.conf, ports.conf, sites-enabled/000-default.conf 等配置文件处理
  $ sudo systemctl [status|restart] apache2  # 然后检查|重启apache2
  $ sudo /etc/init.d/apache2 [status|restart] 
  
  $ sudo apt install nginx        # 安装Nginx
  $ sudo systemctl status nginx   # 检查状态
  $ sudo ufw allow 'Nginx Full'   # 配置防火墙
  $ sudo ufw status               # 验证更改
  $ sudo systemctl restart nginx  # 重启Nginx服务
  $ sudo systemctl disable nginx  # 禁止开机启动
  $ sudo systemctl reload nginx   # 修改配置后，需要重新加载Nginx服务
  $ ls /etc/nginx/sites-available # 设置Nginx服务器模块(类似Apache虚拟主机) www.linuxidc.com/Linux/2018-05/152258.htm
  $ sudo apt install certbot      # 使用Let's Encrypt保护Nginx  www.linuxidc.com/Linux/2018-05/152259.htm
  
  $ sudo systemctl disable nginx && sudo systemctl stop nginx # 准备安装openresty > cd /tmp
  $ sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates software-properties-common
  $ wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
  $ sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
  $ sudo apt-get -y install openresty # 安装openresty  参考 https://openresty.org/en/linux-packages.html
  $ sudo apt-get -y install --no-install-recommends openresty # 最小化安装
  #-config>>  /usr/local/openresty/nginx/conf/nginx.conf
  $ sudo systemctl restart openresty  # 重启
  
  $ sudo apt install nodejs # 安装Nodejs(此安装方式版本太低; 推荐wget安装方式-如下)
  $ wget https://npm.taobao.org/mirrors/node/v10.16.0/node-v10.16.0-linux-x64.tar.xz
  $ sudo tar -zxf node-v10.16.0-linux-x64.tar.xz -C /usr/local/
  $ sudo mv /usr/local/node-v10.16.0-linux-x64 /usr/local/node
  $ vi ~/.bashrc  # 配置 export PATH=/usr/local/node/bin:$PATH # bash生效 source ~/.bashrc ; zsh需修改~/.zshrc
  # (选项)设置软链接: ln -s /usr/local/node/bin/node /usr/local/bin/node ; ln -s /usr/local/node/bin/npm /usr/local/bin/npm
  $ npm install -g npm # 更新安装npm
  
  # 环境变量
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin #系统(内置)
  export PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
  export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre
  export JAVA_VERSION=8u212
  export SCALA_VERSION=2.12
  export GLIBC_VERSION=2.29-r0
  # .profile 文件设置 Aliases
  alias start-pg='sudo service postgresql start'
  alias run-pg='sudo -u postgres psql'
~~~

> `Git` 代码版本管理
~~~shell
  $ sudo add-apt-repository ppa:git-core/ppa
  $ sudo apt-get update
  $ sudo apt install git
  $ git --version                                        # git config --local -l #查看本地配置
  $ git config --global user.name "yangzhou"             # git config --local user.name "用户名"
  $ git config --global user.email "angenal@hotmail.com" # git config --local user.email "用户邮箱地址"
  $ git config --global http.postBuffer 524288000        # set more buffer
  $ git config --global http.sslVerify "false"           # set cancel ssl of https
  $ git init [Git项目所在目录-默认当前目录]                # git init app && ls app/.git/
  $ git status ; git stash list ; git diff
  $ git add [filename]                          # 新增file
  $ git commit -m "添加文件"                     # 新增commit
  $ git reset --soft HEAD^ && git reset HEAD *  # 取消本次提交
  $ git checkout -- [filename]    # 签出，放弃工作区最新的更改，适用于还未提交的情况
  $ git stash && git stash drop   # 加入了暂存区后再清除暂存区，适用于还未提交的情况
  $ git reset HEAD [filename]     # 放弃最新提交[取消git.add]，不改变工作区和库区，只改变了暂存区
  $ git reset --hard HEAD^        # 版本回退，工作区和库区都进行相应的回退
  $ rm [filename] && git rm [filename] && git commit -m "删除文件"
  $ git remote add origin https://github.com/dragonFly12345/ubuntuGitTest.git # 使用远程HTTPS
  $ git remote remove origin                                                  # 删除后用于重新绑定远程
  $ ssh-keygen -t rsa -C "angenal@hotmail.com"                                # 使用远程SSH请先创建SSH认证
  $ git remote add origin git@github.com:dragonFly12345/ubuntuGitTest.git     # 使用远程SSH地址
  $ git push origin master -u                                                 # [u用在第一次推送时]
  # https://github.com/jesseduffield/lazygit/releases/                        # 安装lazyGit管理更方便
  > Gitea 版本管理 docs.gitea.io/zh-cn 下载 dl.gitea.io/gitea/master
  > Gitea API 使用指南 docs.gitea.io/zh-cn/api-usage  github.com/go-gitea/gitea
  # Gitea 注册Windows服务
  > sc create gitea start= auto binPath= "D:\Program\Git\Server\gitea\gitea.exe web --config \"D:\Program\Git\Server\gitea\custom\conf\app.ini\""
~~~

> `Redis` 内存数据库 (KeyValue,) www.redis.cn
~~~shell
  $ wget http://download.redis.io/releases/redis-stable.tar.gz # 下载源码 # cd ~
  $ tar xzf redis-stable.tar.gz                                # 解压源码
  $ cd redis-stable && sudo make install                       # 编译Redis
  $ cd utils && sudo ./install_server.sh                       # 安装Redis
  $ rm -rf ~/redis-stable && rm -f ~/redis-stable.tar.gz       # 删除源码
  #-config>>  /etc/redis/6379.conf       # 修改配置文件
  # << bind 0.0.0.0                      # 允许远程连接
  # << requirepass 123456                # 设置访问密码
  # << protected-mode no                 # 关闭保护模式
  $ ps aux|grep redis                    # 查看进程: /usr/local/bin/redis-server 127.0.0.1:6379
  $ redis-server                         # (可选)启动服务(独立模式|常规启动), 可通过 ps aux 查看进程
  $ sudo service redis_6379 start        # (可选)启动服务(非独立模式|后台启动服务) start|stop|restart
  $ sudo update-rc.d redis_6379 defaults # (推荐)开机启动Redis将init脚本添加到所有默认运行级别(需stop后处理)
  > nssm install RedisWSLubuntu1804 bash.exe -c redis-server # 启动前设置Windows服务登录账户为Administrator
  # 客户端命令Redis
  $ redis-cli -h 127.0.0.1 -p 6379 -a "123456" -n 0 # [p端口],[a密码],[n数据库]
  $ redis-cli shutdown                   # 关闭Redis服务
  $ config set requirepass "123456"      # 设置访问密码
  $ auth 123456                          # 密码认证;再执行其它命令.
  # 性能测试Redis
  > redis-benchmark -n 10000 -q          # 本机Redis  < SET: 90K, GET: 90K > requests per second
  > buntdb-benchmark -n 10000 -q         # 本机BuntDB < SET:230K,GET:5000K > requests per second
~~~

> `MySQL` 关系型数据库
~~~shell
  # 安装
  $ sudo apt-get update
  $ sudo apt-get install mysql-server  # 默认版本 <CentOS7> sudo yum install mariadb mariadb-server
  $ sudo mysql_secure_installation     # 安装配置
  $ sudo systemctl status mysql   # 检查状态
  $ sudo systemctl enable mysql  # 开机启动
  $ ps aux |grep mysqld　　　　　       # 查看进程 /usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid
  $ cat /etc/mysql/debian.cnf          # 查看系统密码
  $ mysql -u debian-sys-maint -p       # 准备修改密码
  > use mysql;
  > update mysql.user set authentication_string=password('root') where user='root' and Host ='localhost';
  > update user set plugin="mysql_native_password";
  > flush privileges; quit;
  $ sudo service mysql restart            # 重启 systemctl restart mysql
  $ mysql -P3306 -uroot -p < init.sql   # 以root身份登录并执行脚本> source init.sql
  # 配置远程访问 (@'localhost'本机访问; @'%'所有主机都可连接)
  > CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
  > select * from user where user='root' \G;  # 查询当前用户: SELECT USER();
  > grant select,insert,update,delete,create,drop,index,alter on dbname.* to newuser@192.168.1.* identified by 'root';
  > GRANT ALL PRIVILEGES ON dbname.* TO 'newuser'@'%' IDENTIFIED BY 'root'; # 授权newuser
  > GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root'; # 默认授权
  > SET PASSWORD FOR 'root'@'%' = PASSWORD('root');    # 设置密码为root
  > mysqladmin -u root password 123456       # 初始化密码
  > mysqladmin -u root -p 123456 password HGJ766GR767FKJU0 # 修改密码
  > mysqladmin -u root -p shutdown                 # 关闭mysql
  
  # GitHub在线使用的数据库迁移工具 github.com/github/gh-ost
  $ gh-ost help
  # 同步MySQL数据至elasticsearch的工具 github.com/siddontang/go-mysql-elasticsearch
  $ go-mysql-elasticsearch -config=./etc/river.toml
  # 使用SQL综合查询数据源(JSON & CSV & PostgreSQL & MySQL & Redis)的工具 github.com/cube2222/octosql/cmd/octosql
  $ octosql help
  # 推荐一个对SQL进行优化和改写的自动化工具SOAR(SQL Optimizer And Rewriter)
  $ wget https://github.com/XiaoMi/soar/releases/download/0.11.0/soar.linux-amd64 -O soar && chmod a+x soar
  $ soar 'select * from film' # 显示优化说明
  
  # 推荐 TiDB, PingCAP公司设计的开源分布式HTAP`混合事务处理和分析`NewSQL兼容MySQL: pingcap.com/docs-cn
  
  # 推荐 Vitess, 一个数据库集群系统, 用于水平弹性扩展MySQL
  $ sudo service apparmor stop               # 1. Disable AppArmor of MySQL,
  $ sudo service apparmor teardown           #    safe to ignore if this errors,
  $ sudo update-rc.d -f apparmor remove      #    remove the apparmor, download vitess-release-*.tar.gz
  $ export VTROOT=/4g/database/vt            # 2. Configure Environment >> .profile
  $ export VTTOP=/4g/database/vt, VTDATAROOT=/4g/database/vt/data, MYSQL_FLAVOR=MySQL57, PATH=$VTROOT/bin:$PATH
  $ cd examples/local && ./101_initial_cluster.sh # 3. Initial install vitess.io/docs/get-started/local
  # Run Vitess on Kubernetes vitess.io/docs/get-started/kubernetes
~~~

> `PostgreSQL` 关系型数据库 - 文档 www.postgresql.org
~~~shell
  $ sudo apt-get update
  $ sudo apt-get -y install postgresql postgresql-contrib # 安装 psql --version
  $ sudo systemctl enable postgresql.service              # 开机启动,WSL将为 sudo /etc/inid.d/postgresql enable
  $ sudo service postgresql status,start,stop             # 状态,启动,停止
  $ sudo passwd postgres                                  # 分配密码后连接到数据库
  $ sudo -u postgres psql -c "\du"                        # 执行psql命令(以用户postgres身份)
  $ sudo apt-get purge postgre*                           # 卸载
~~~

> `mongodb` NoSql数据库 - 文档 docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu
~~~shell
  $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
  $ echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
  $ sudo apt-get update
  $ sudo apt-get -y install mongodb-org                   # 安装/下面是指定版本
  $ sudo apt-get -y install mongodb-org=4.0.10 mongodb-org-server=4.0.10 mongodb-org-shell=4.0.10 mongodb-org-mongos=4.0.10 mongodb-org-tools=4.0.10
  $ sudo systemctl enable mongodb.service                 # 开机启动,WSL将为 sudo /etc/inid.d/mongodb enable
  $ sudo service mongodb status,start,stop                # 状态,启动,停止
  > mongo --eval 'db.runCommand({ connectionStatus: 1 })' # 诊断服务器正在运行
  $ sudo apt-get purge mongodb-org*                       # 卸载 rm -rf /var/log/mongodb /var/lib/mongodb
~~~

> `Pilosa` 分布式位图索引数据库 www.pilosa.com
~~~shell
  $ curl -LO https://github.com/pilosa/pilosa/releases/download/v1.3.0/pilosa-v1.3.0-linux-amd64.tar.gz
  $ tar xfz pilosa-v1.3.0-linux-amd64.tar.gz 
  $ sudo cp -i pilosa-v1.3.0-linux-amd64/pilosa /usr/local/bin
  $ pilosa server --data-dir ~/.pilosa --bind :10101 --handler.allowed-origins "*"&       # 指定origins: http://localhost:10102
  $ go get github.com/pilosa/console && cd $GOPATH/src/github.com/pilosa/console && make install && pilosa-console -bind :10102
~~~

> `InfluxDB` 时间序列数据库 portal.influxdata.com
~~~shell
  $ curl -LO https://dl.influxdata.com/influxdb/releases/influxdb_2.0.0-alpha.17_linux_amd64.tar.gz
  $ tar xfz influxdb_2.0.0-alpha.17_linux_amd64.tar.gz
  $ sudo cp influxdb_2.0.0-alpha.17_linux_amd64/{influx,influxd} /usr/local/bin
  # 配置TCP port 9999  |  https://v2.docs.influxdata.com/v2.0/reference/api
  # 启动 > influxd [--reporting-disabled]  |  https://v2.docs.influxdata.com/v2.0/get-started
  # 安装 http://localhost:9999   <打开website或者cli> influx setup
  # 配置 Usr: default ; Pwd: HGJ766GR767FKJU0 ; Org: angenalZ ; Bucket: default  # 结束安装与初始化设置
  # #初始化Bucket -> 设置数据源Collector + 监听跟踪数据Dashboard + 分析数据使用Flux -> 管理Tasks
~~~

> [`grafana`](https://grafana.com/docs/) 一个开源的度量分析与可视化套件  漂亮的监测、报警、指标分析、图表工具<br>
    时序数据库 [InfluxDB](https://grafana.com/docs/features/datasources/influxdb/),[Prometheus](https://grafana.com/docs/features/datasources/prometheus/),[Graphite](https://grafana.com/docs/features/datasources/graphite/),[OpenTSDB](https://grafana.com/docs/features/datasources/opentsdb/); 文档数据库 [Elasticsearch](https://grafana.com/docs/features/datasources/elasticsearch/),[Loki](https://grafana.com/docs/features/datasources/loki/)...
~~~shell
  $ wget https://dl.grafana.com/oss/release/grafana_6.3.5_amd64.deb
  $ sudo dpkg -i grafana_6.3.5_amd64.deb  #安装服务&自动启动  > /usr/sbin/grafana-server --config=/etc/grafana/grafana.ini --pidfile=/var/run/grafana/grafana-server.pid --packaging=deb cfg:default.paths.logs=/var/log/grafana cfg:default.paths.data=/var/lib/grafana cfg:default.paths.plugins=/var/lib/grafana/plugins cfg:default.paths.provisioning=/etc/grafana/provisioning
  $ sudo netstat -anpW |grep -i "grafana-server" #确认安装&启动成功!
  $ sudo vi /etc/grafana/grafana.ini        #修改配置( default HTTP port 3000 )
  $ sudo service grafana-server restart  #重启服务( http://localhost:8030 : admin )
  > docker run -d --name=grafana -p 3000:3000 grafana/grafana  #另外,可直接安装其Docker服务
~~~

> `消息平台` nsq、kafka、centrifugo、rabbitmq、gotify、botpress <br>
    解耦、冗余、扩展、峰值处理能力、可恢复性、异步通信。
~~~shell
# 消息平台1 nsq (go)服务: nsq.io 开源的分布式消息平台(每天处理数十亿的消息，容错和高可用，可靠的消息交付保证)
  #1.先启动消息服务 (提供近乎实时的分析系统，被Docker、Stripe和BuzzFeed在内的一系列公司使用)
  > nsqlookupd -broadcast-address=[hostname] -tcp-address=0.0.0.0:4160 -http-address=0.0.0.0:4161 -log-level=warn
  #2.再启动几个 nsqd 存储数据
  > nsqd -node-id=[0,1024) --lookupd-tcp-address=127.0.0.1:4160 --tcp-address=0.0.0.0:4150 -http-address=0.0.0.0:4151 \
    -https-address=0.0.0.0:4152 -tls-cert=/certs/cert.pem -tls-key=/certs/key.pem \
    -tls-root-ca-file=/certs/ca.pem -tls-required=[true,false,tcp-https] -tls-client-auth-policy=[require,require-verify] \
    -log-level=warn -sync-timeout=3s -msg-timeout=1m0s
  > nsqd -node-id=[0,1024) --lookupd-tcp-address=127.0.0.1:4160 --tcp-address=0.0.0.0:4153 --http-address=0.0.0.0:4154 \
    -data-path=/nsqd ...
  #3.最后启动Web管理
  > nsqadmin --lookupd-http-address=127.0.0.1:4161 #--tcp-address=0.0.0.0:4171 

# 消息平台2 kafka (erlang)服务: kafka.apache.org/quickstart
  ##安装kafka 参考: https://developer.ibm.com/tutorials/realtime-visitor-analysis-with-kafka/
  $ sudo apt-get -y install apache2      # Install Apache web server
  $ systemctl status apache2.service  # Verify it is running, 检查 web root: /var/www/html/
  $ sudo add-apt-repository ppa:webupd8team/java  # Install Java
  $ sudo apt-get update && sudo apt-get install oracle-java8-installer
  #-download Apache Kafka binary to ~/kafka : https://kafka.apache.org/downloads
  #-config>>  ~/kafka/config/server.properties
  # << advertised.listeners=PLAINTEXT://[KAFKA_VM_IP]:9092
  # << log.dirs=/tmp/kafka-logs
  #-run>>  cd ~/kafka
  $ bin/zookeeper-server-start.sh config/zookeeper.properties &   # run zookeeper
  $ bin/kafka-server-start.sh config/server.properties &          # run kafka
  #-create an `access-log` topic in another console
  $ bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic access-log --partitions 1 --replication-factor 1
  #------
  ##直接下载安装kafka
  $ wget http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.3.0/kafka_2.12-2.3.0.tgz
  $ tar -xzf kafka_2.12-2.3.0.tgz -C /opt/
  $ mv /opt/kafka_2.12-2.3.0 /opt/kafka && cd /opt/kafka          # 或者 ~/kafka
  export KAFKA_VERSION=2.3.0
  export KAFKA_HOME=/opt/kafka
  export PATH=$PATH:/opt/kafka/bin
  $ bin/zookeeper-server-start.sh config/zookeeper.properties     # start a ZooKeeper server
  $ bin/kafka-server-start.sh config/server.properties            # start a Kafka server
  $ bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test --partitions 1 --replication-factor 1
  $ bin/kafka-topics.sh --bootstrap-server localhost:9092 --list  #↑↑ create a topic and list topic
  $ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test #→send→messages
  $ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning #←get←messages
  $ cp config/server.properties config/server-1.properties        # setting up a multi-broker cluster
  $ cp config/server.properties config/server-2.properties        # setting up a multi-broker cluster

# 消息平台3 centrifugo (go)服务: github.com/centrifugal/centrifugo
  $ curl -s https://packagecloud.io/install/repositories/FZambia/centrifugo/script.deb.sh | sudo bash
  #-config>> /lib/systemd/system/centrifugo.service替换$CENTRIFUGO_OPTS=--port "8116" --engine "memory" --grpc_api
  $ systemctl stop centrifugo && systemctl daemon-reload # 修改配置后
  $ systemctl start centrifugo  #重启 # sudo bash /4g/git/doc/sh/centrifugo.script.deb.sh #↑完成安装
  $ centrifugo genconfig  #-> config.json  #→ centrifugo -h
  $ /usr/bin/centrifugo -c /etc/centrifugo/config.json --port "8116" --engine "memory" --grpc_api #--tls --tls_cert ? --tls_key ?

# 消息平台4 rabbitmq (erlang)服务: www.rabbitmq.com  参考: blog.csdn.net/vrg000/article/details/81165030 yq.aliyun.com/articles/175876
  $ sudo apt install -f libncurses5-dev freeglut3-dev fop m4 tk unixodbc unixodbc-dev xsltproc socat #安装erlang依赖
  $ wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.1-1~ubuntu~xenial_amd64.deb
  $ sudo dpkg -i esl-erlang_22.1-1~ubuntu~xenial_amd64.deb # 安装erlang语言
  $ wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.18/rabbitmq-server_3.7.18-1_all.deb
  $ sudo dpkg -i rabbitmq-server_3.7.18-1_all.deb #安装RMQ(amqp:一种消息中间件协议,RMQ为amqp的一个具体实现)
  $ systemctl status rabbitmq-server  |  rabbitmqctl -q status     # 检查RMQ状态
  $ sudo usermod -G ...rabbitmq ${USER}  # 将当前用户加入rabbitmq组 ;先查USER已拥有组> id [用户名]..
  $ rabbitmq-plugins enable rabbitmq_management #开启web访问功能; 安全策略加15672端口 http://192.168.*.*:15672
  $ rabbitmqctl add_user user 123456        #账号密码[默认超管guest:guest]
  $ rabbitmqctl set_user_tags administrator #角色权限[administrator,management,monitoring,policymaker,impersonator]
  # 连接生产者与消费者的端口5672, WEB管理页面的端口15672, 分布式集群的端口25672
  #**Dial.Channel.ExchangeDeclare{Name,Type[fanout|direct|topic|headers],Durability[Durable|Transient],AutoDelete,Internal,Arguments{...}}
  #**Dial.Channel.QueueDeclare{Name,Durability[Durable|Transient],AutoDelete,Arguments{x-message-ttl(ms),x-expires(ms),x-max-length...}}
  # 1.简单队列:一对一  [ 消息Publish事务模式: 1.Channel.txSelect+txSubmit+txRollback 2.ch.comfirmSelect+wait.. 3.ch异步handle..]
  #   send: Dial.Channel{ QueueDeclare[q.Name], Publish[q.Name,amqp.Publishing{ContentType:"text/plain",Body}] }
  #   receive: Dial.Channel{ QueueDeclare[q.Name], Consume[q.Name,Ack?自动:true] > range(<-chan)msgs }
  # 2.工作队列:一对多  [ 1.轮训模式workers+Ack(true) 2.公平模式workers+Qos+Ack(false)?手动=提高性能]
  #   task: Dial.Channel{ QueueDeclare[q.Name,Durable?持久存储], Publish[q.Name,amqp.Publishing{DeliveryMode:amqp.Persistent,Body}] }
  #   worker: Dial.Channel{ QueueDeclare[q.Name,Durable?持久存储], Qos(1,0,false), Consume[q.Name,Ack?手动] > msg.Ack(false) }
  # 3.发布订阅:订阅模式+Exchange交换机+QueueBind队列绑定交换机[消息分发器]
  #   publish: Dial.Channel{ ExchangeDeclare[x.Name,Type:"fanout"], Publish[x.Name,amqp.Publishing{ContentType:"text/plain",Body}] }
  #   subscribe: Dial.Channel{ ExchangeDeclare[x.Name,Type:"fanout"], QueueDeclare[q.Name:"",Exclusive:true只有自己可见?排他性队列], 
  #     QueueBind[q.Name,routing-key:"",x.Name]..., Consume[q.Name,Ack?自动] }
  # 4.发布订阅:路由模式+Routing-路由分发..
  #   publish: Dial.Channel{ ExchangeDeclare[x.Name,Type:"direct"], Publish[x.Name,routing-key:"login",amqp.Publishing] }
  #   subscribe: Dial.Channel{ ExchangeDeclare[x.Name,Type:"direct"], QueueDeclare[q.Name:"",Exclusive:true只有自己可见?排他性队列], 
  #     QueueBind[q.Name,routing-key:"login",x.Name]..., Consume[q.Name,Ack?自动] }
  # 5.发布订阅:通配符模式+Topics-主题分发..
  #   publish: Dial.Channel{ ExchangeDeclare[x.Name,Type:"topic"], Publish[x.Name,routing-key:"admin.login",amqp.Publishing] }
  #   subscribe: Dial.Channel{ ExchangeDeclare[x.Name,Type:"topic"], QueueDeclare[q.Name:"",Exclusive:true只有自己可见?排他性队列], 
  #     QueueBind[q.Name,routing-key:"#login",x.Name]..., Consume[q.Name,Ack?自动] } ;匹配所有为#
  # 6.远程调用-RPC
  #   server: Dial.Channel{ QueueDeclare[q.Name,], Qos(1,0,false), Consume[q.Name,Ack?手动] > 
  #     Publish[q.Name:"",routing-key:msg.ReplyTo,amqp.Publishing{CorrelationId:msg.CorrelationId,Body}], msg.Ack(false) }
  #   client: Dial.Channel{ QueueDeclare[q.Name:"",Exclusive:true], 
  #     Publish[q.Name:"",routing-key:"rpc_queue",amqp.Publishing{ContentType:"text/plain",CorrelationId:1,ReplyTo:q.Name,Body}], 
  #     Consume[q.Name,Ack?自动] }
  
# 消息平台5 gotify (go)服务: github.com/gotify/server
  $ wget https://github.com/gotify/server/releases/download/v2.0.5/gotify-linux-amd64.zip
  $ wget -O config.yml https://raw.githubusercontent.com/gotify/server/master/config.example.yml
  $ unzip gotify-linux-amd64.zip && chmod +x gotify-linux-amd64
  $ sudo ./gotify-linux-amd64  # 配置文件config.yml: gotify.net/docs/config
  > nssm install Gotify %gopath%\bin\gotify\server\gotify.exe
  
# 聊天机器人 Chat Bots (typescript)服务: github.com/botpress/botpress
  > nssm install Botpress D:\Program\botpress\bp.exe serve  # Windows Service
~~~

> `系统服务` 计划任务管理 <br>
    Ⅰ.[uber/cadence](https://cadenceworkflow.io) [分布式的、可扩展的、高可用的任务编排引擎，异步执行长时间运行的业务逻辑](https://github.com/uber/cadence)
~~~shell
#Ⅰ.uber/cadence  https://github.com/uber/cadence/blob/master/docker/README.md
  #-1: Quickstart for localhost development
  $ wget https://github.com/uber/cadence/releases/...
  $ tar -xzf docker.tar.gz && cd docker
  # -run cadence service
  $ docker-compose up | down                             # service with Cadence
  $ docker-compose -f docker-compose-mysql.yml up | down # service with MySQL: 先配置 MYSQL_PWD
  $ docker-compose -f docker-compose-es.yml up | down    # service with ElasticSearch: 先配置 es
  #-2: Quickstart for production
  $ docker run -e CASSANDRA_CONSISTENCY=Quorum \         # Default cassandra consistency level
    -e CASSANDRA_SEEDS=10.x.x.x                          # csv of ipaddrs cassandra server
    -e KEYSPACE=<keyspace>                               # Cassandra keyspace
    -e VISIBILITY_KEYSPACE=<visibility_keyspace>         # Cassandra visibility keyspace
    -e SKIP_SCHEMA_SETUP=true                            # do not setup cassandra schema during startup
    -e RINGPOP_SEEDS=10.x.x.x,10.x.x.x  \                # csv of ipaddrs for gossip bootstrap
    -e STATSD_ENDPOINT=10.x.x.x:8125                     # statsd server endpoint
    -e NUM_HISTORY_SHARDS=1024  \                        # Number of history shards
    -e SERVICES=history,matching \                       # Spinup only the provided services
    -e LOG_LEVEL=debug,info \                            # Logging level
    -e DYNAMIC_CONFIG_FILE_PATH=config/foo.yaml          # Dynamic config file to be watched
    ubercadence/server:<tag>                             # <tag> 0.9.4-auto-setup
~~~

> [`SSH`](https://www.netsarang.com/zh/) [建立安全的加密连接：一个密码对应一个SSH-key](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04)  https://www.chiark.greenend.org.uk
~~~shell
  # 安装服务sshd ：OpenSSH守护进程
  # < centos >---------------------------
  $ rpm -qa | grep ssh  # 检查服务ssh是否已安装: netstat -antp | grep sshd [端口:22]
  $ yum install -y initscripts # 安装服务netstat [/sbin/service]
  $ yum install -y openssh-server # 安装服务ssh
  $ service sshd start | service sshd stop # 启动sshd|停止
  $ chkconfig sshd on # 开机启动
  # < ubuntu >---------------------------
  $ sudo apt-get remove --purge openssh-server # 先删ssh(可忽略此操作)
  $ sudo apt-get -y install openssh-server     # 再安装ssh
  $ sudo rm /etc/ssh/ssh_config                # 先删配置文件, 让ssh服务自己想办法链接-(可忽略此操作)
  $ cd ~/.ssh && ssh-keygen -A                 # SSH生成主机密钥对-(设置登录)
  $ sudo service ssh --full-restart            # 重启ssh service +(设置登录后)
  $ ssh-keygen -f id_rsa2 -N '' -t rsa         #2.1 SSH生成\主机$host2的密钥对\用户$user2
  $ cp -r id_rsa2.pub ~/.ssh/authorized_keys   #2.2 复制公钥至客户端主机~目录\当前用户$USER
  $ ssh -i id_rsa2 -l $user2 $host2            #2.3 登录远程主机$host2\$user2的$HOME目录(id_rsa2权限400)
  # <生成/添加SSH公钥>Git使用远程SSH请先创建SSH认证
  $ ssh-keygen -t rsa -C "angenal@hotmail.com" #1.生成sshkey密钥对
  $ cat ~/.ssh/id_rsa.pub                      #2.获取你的public-key公钥
  $ ssh -T git@gitee.com                       #3.首次使用时确认并添加主机到本机SSH可信列表；成功后，就可以对仓库进行操作了。
  # Git配置多个SSH-Key  https://gitee.com/help/articles/4229#article-header0
  # < sshd service >---------------------
  $ systemctl start sshd   # systemctl启动sshd
  $ systemctl status sshd  # systemctl查看状态
  $ systemctl enable sshd  # systemctl开机启动生效
    ln -s '/usr/lib/systemd/system/sshd.service' '/etc/systemd/system/multi-user.target.wants/sshd.service'
  $ systemctl disable sshd # systemctl关闭开机启动
    rm '/etc/systemd/system/multi-user.target.wants/sshd.service'
  # < ssh root login >-------------------
  $ sudo passwd root              # 修改root密码，用于root登录ssh
  $ sudo vim /etc/ssh/sshd_config # 修改配置文件 > # Authentication: (全部启用,去除#)
    # vim命令（:w 编辑模式, :i 插入模式, :x 回车保存, :qa! 退出不保存, gg dG 清空文件）
    > PermitRootLogin yes         # 启用root登录  #PermitRootLogin prohibit-password
    > sudo service ssh restart    # 重启ssh
  # < user login >-----------------------
  > ssh-keygen -t rsa -C "angenal@hotmail.com" #+生成密钥对( ~/.ssh/ id_rsa + id_rsa.pub )
  > dir "C:\Users\Administrator/.ssh"     # 存储的本地公钥目录
  > clip < %USERPROFILE%/.ssh/id_rsa.pub  # 拷贝公钥到粘贴板中
  $ cat ~/.ssh/id_rsa.pub                 # https://code.aliyun.com/help/ssh/README
  $ xclip -sel clip < ~/.ssh/id_rsa.pub   # GNU/Linux (requires xclip)
  $ pbcopy < ~/.ssh/id_rsa.pub            # <MacOS>
  
  # felix 提供 SSH Web管理后台 + RESTful Api接口<ssh+gin+GORM> github.com/dejavuzhou/felix
  > felix sshw -a :8022 -x 1440 -u admin -p admin -s @Ubr)Vrp~Zoo6Rvrk1PP1*ZXPYby_Z)s  # felix -h
  # WebSsh终端 堡垒机  github.com/huashengdun/webssh
  $ pip install webssh  # 安装webssh
  $ wssh --port=8022 --logging=debug
~~~

> `Serf` [`去中心化集群`Hashicorp开源](https://www.serf.io) 基于Serf实现的网络管理和服务发现, 如[`docker`](#docker),[`consul`](#Consul)等
~~~shell
  $ serf agent  # a single Serf agent
  $ serf members
  #1.启动serf agent节点，并提供UserEvent和Query等接口 (处理一些用户层的事件，如服务发现、自动化部署等)
  $ serf agent -node=node1 -bind=127.0.0.1:5001 -rpc-addr=127.0.0.1:7473 # custom user event, query event!
    -event-handler=user:log='echo node1 >> node1.log' -event-handler=query:greet='echo hello,node1' -tag role=api1
  $ serf agent -node=node2 -bind=127.0.0.1:5002 -rpc-addr=127.0.0.1:7474 
    -event-handler=user:log='echo node2 >> node2.log' -event-handler=query:greet='echo hello,node2' -tag role=api2
  $ serf agent -node=node3 -bind=127.0.0.1:5003 -rpc-addr=127.0.0.1:7475 
    -event-handler=user:log='echo node3 >> node3.log' -event-handler=query:greet='echo hello,node3' -tag role=api3
  #2.节点之间建立连接，形成去中性化集群。 Serf invokes events: member-{join,leave,update,failed,reap}
  $ serf join -rpc-addr=127.0.0.1:7474 127.0.0.1:5001  # node2 join node1
  $ serf join -rpc-addr=127.0.0.1:7473 127.0.0.1:5003  # node1 join node3
  #3.发送一个`log` Event，所有节点都会处理该Event
  $ serf event -rpc-addr=127.0.0.1:7473 log play  #会向对应的日志文件写入文本
  $ serf query -rpc-addr=127.0.0.1:7473 -tag role=api2 greet play #向node1发Query,但通过-tag设置实际的处理节点为node2
~~~

> `图片压缩`
~~~shell
  $ sudo apt-get install jpegoptim   # jpg 图片压缩: jpegoptim *.jpg ; find . -name '*.jpg' | xargs jpegoptim --strip-all;
  $ sudo apt-get install optipng     # png 图片压缩: optipng *.png ; find -type f -name "*.png" -exec optipng {} \;
  $ git clone git://github.com/xing/TinyPNG.git && ./TinyPNG/install.sh
~~~

> `加密解密文件`
~~~shell
  $ chmod +x toplip # 赋予可执行权限
  $ ./toplip        # 运行 http://os.51cto.com/art/201903/593569.htm https://2ton.com.au/standalone_binaries/toplip
~~~

> `io检测工具`
~~~shell
  # < fio 检测存储性能 >---------------------------
  $ wget https://github.com/axboe/fio/archive/fio-3.14.tar.gz  #! http://brick.kernel.dk/snaps/fio-2.1.10.tar.gz
  $ tar -zxf fio-3.14.tar.gz && cd fio-fio-3.14
  $ ./configure --enable-gfio # 配置: enable gfio (参数可选)
  $ make                      # 编译: make fio && make gfio
  $ sudo make install         # 安装: install fio gfio genfio fio-* /usr/local/bin
  $ cd .. && rm -rf fio-*     # 安装完毕后删除源(可选)
  $ fio -S& [--server]        # 启动后端← + →客户端↓测试↓ [参考:examples/*.fio]
  $ fio --client=host1.list fio1.job --client=host2.list fio2.job
  $ fio --ioengine=libaio --direct=1 --thread --norandommap \ # SATA接口硬盘
    --filename=/dev/sda --name=init_seq --output=init_seq1.log \
    --rw=write --bs=128k --numjobs=1 --iodepth=32 --loops=1 # blog.csdn.net/dinglisong/article/details/83111515
  $ gfio   # 桌面应用→分析(>1h)→ 顺序读、顺序写、随机读、随机写等存储性能
~~~

> `glances`[系统实时监控](https://www.tecmint.com/command-line-tools-to-monitor-linux-performance/)
~~~shell
  $ sudo apt-add-repository ppa:arnaud-hartmann/glances-stable
  $ sudo apt-get update
  $ sudo apt-get install glances  #直接安装
  $ glances -t 2  # 本机运行, 刷新频率(默认是 1秒) 本机配置 /etc/glances/glances.conf
  $ glances -s     # 服务器/客户端模式 > glances -c -P 172.16.27.56 (-P设置密码; -p设置端口)
  # 快捷键：
  # a  对进程自动排序
  # c  按 CPU 百分比对进程排序
  # m 按内存百分比对进程排序
  # p  按进程名字母顺序对进程排序
  # i 按读写频率 I/O 对进程排序
  # d 显示/隐藏磁盘 I/O 统计信息
  # f 显示/隐藏文件系统统计信息
  # n 显示/隐藏网络接口统计信息
  # s 显示/隐藏传感器统计信息
  # y 显示/隐藏硬盘温度统计信息
  # l 显示/隐藏日志
  # b 切换网络 I/O 单位(Bytes/bits)
  # w 删除警告日志
  # x 删除警告和严重日志
  # 1 切换全局 CPU 使用情况和每个 CPU 的使用情况
  # h 显示/隐藏这个帮助画面
  # t 以组合形式浏览网络 I/O
  # u 以累计形式浏览网络 I/O
  # q 退出(ESC或Ctrl+C)
~~~

> `Docker` 客户端 (连接到 Docker for Windows10)
~~~shell
  # < Windows Subsystem for Linux | WSL >---------------------------
  $ sudo apt install docker.io              # 安装Docker客户端 | docker.io get client connection.
  $ export DOCKER_HOST=tcp://127.0.0.1:2375 # 设置环境, 使用 vi ~/.bashrc [~/.bash_profile](在文件结尾添加)
  $ docker [COMMAND] --help                 # 执行Docker命令

  # Docker正式环境: 修改Linux内核参数 https://blog.csdn.net/guanheng68/article/details/81710406
  $ sysctl -w vm.max_map_count=262144       # 操作无效时, 使用 vi /etc/sysctl.conf 修改
  $ grep vm.max_map_count /etc/sysctl.conf  # 检查设置

  # 安装 Ansible 配置管理和IT自动化工具-(系统运维)一个强大的配置管理解决方案(由Python编写)
  $ sudo apt update  # < ubuntu >
  $ sudo apt install software-properties-common
  $ sudo apt-add-repository --yes --update ppa:ansible/ansible
  $ sudo apt install ansible        # https://www.jianshu.com/c/67d13df667ba
  # 安装 Airflow 任务调度(由Python编写) https://www.jianshu.com/p/9bed1e3ab93b
  $ sudo apt install libkrb5-dev libsasl2-dev libmysqlclient-dev  # 安装airflow[all]依赖包
  $ mkdir airflow && cd airflow
  $ pip install setuptools_git
  $ pip download pymssql
  $ pip download apache-airflow[all]                       # 1.离线: tar -zcf airflow.tar.gz *
  $ cd airflow                                             # 2.解压: tar -zxf airflow.tar.gz
  $ pip install apache-airflow[all] --no-index -f ./       # 3.安装airflow[all]
  $ echo "export AIRFLOW_HOME=~/app/airflow" >> ~/.bashrc  # 4.配置
  $ source ~/.bashrc && airflow initdb                     # 5.部署
~~~

----

# [**docker**](https://docs.docker.com)

>  [安装](https://docs.docker.com/install)　[docker-hub](https://hub.docker.com/repositories)　[docker-desktop](https://hub.docker.com/?overlay=onboarding)：Build构建&Compose编排&Kubernetes管理&Swarm集群<br>
  `环境 & 版本` : [`Linux x64, Kernel^3.10 cgroups & namespaces`](https://docs.docker.com/install), [`docker-ce`社区版](https://hub.docker.com/?overlay=onboarding) + `docker-ee`企业版 <br>
  `加速器`..   : [`阿里云`](https://cr.console.aliyun.com/#/accelerator)[..](https://4txtc8r4.mirror.aliyuncs.com)、[`DaoCloud道客`](https://dashboard.daocloud.io/packages/explore)[..](http://8fe1b42e.m.daocloud.io)、[`网易`](https://hub-mirror.c.163.com)
~~~
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io # for Linux
sudo systemctl daemon-reload && sudo systemctl restart docker.service
~~~
> `Dockerfile` : `docker build Image(tag=name+version)` > `push Registry` <br>
  `Registry & Disk` : `Repository` > `Image-Url` | `Image save .tar to-Disk`, `Container export .tar(snapshot)` <br>
  `Docker`     : `pull Image from-Registry` | `load Image .tar from-Disk` <br>
  `Data`       : `docker container run Image` - `--volumes-from Data-Container` - `-v from-Disk:Data-Dir` <br>
  `Cert`       : `C:/ProgramData/DockerDesktop/pki/` ...

~~~shell
# 安装Docker，先切换用户root ~ su   (一般用国内镜像daocloud)
$ curl -sSL https://get.daocloud.io/docker | sh 
$ curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh - #阿里云
$ sudo systemctl status docker #运行状态检查
# 卸载Docker，最后清理 ~ rm -fr /var/lib/docker/
$ apt-get remove docker docker-engine
# 安装 Docker Compose
$ curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose 
$ chmod +x /usr/local/bin/docker-compose   #设置文件为可执行
# 安装 Docker Machine基于virtualBox github.com/docker/machine/releases/download/v0.16.1/docker-machine-Linux-x86_64
$ sudo dpkg -i virtualbox-6.0_6.0.8-130520_Ubuntu_bionic_amd64.deb --fix-missing  # www.virtualbox.org/wiki/Linux_Downloads
$ curl -L https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
$ chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine  # install /tmp/docker-machine /usr/local/bin/docker-machine
$ docker-machine version                   #安装完毕
# 设置 Docker, 不使用sudo执行docker命令，先切换当前用户-user(root~exit)
$ sudo gpasswd -M ${USER} docker && newgrp - docker # 将当前用户加入docker组> sudo usermod -aG docker ${USER}
$ sudo service docker restart              #重启服务
# 本机启动 Docker daemon
$ sudo docker-machine create -d virtualbox default  # 1.下载安装服务 ~/.docker/machine/cache/boot2docker.iso
$ sudo docker-machine env default                   # 2.设置客户端docker-cli的环境变量
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.102:2376"      # 对应> docker-machine ip
export DOCKER_CERT_PATH="/home/yangzhou/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
$ sudo chmod 777 -R ~/.docker && docker info        # 监听> tcp & TLS 允许cli远程访问
$ sudo /usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 --containerd=/run/containerd/containerd.sock
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
  docker network create -o "com.docker.network.bridge.name"="***-net" --subnet 172.18.0.0/16 ***-net #指定子网172.18/255
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
  docker inspect -f "{{.Config.Hostname}} {{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" $(docker ps -aq)
  docker run --name myweb --network=workgroup --link -d -P redis5:redis5 nginx # 容器之间安全互联 myweb连接redis5:redis5别名
  docker run --name myweb --network bridge --ip 172.18.0.2 --network=***-net ... ...  # 指定子网172.18/255+bridge

  # 基础
  docker [COMMAND] --help
  docker images        # 查看镜像
  docker ps -a         # 查看容器 | docker container ls -a
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
  docker kill $(docker ps -a -q)            # 杀死所有运行的容器
  docker container prune                    # 删除所有停止的容器
  docker volume prune                       # 删除未使用volumes
  docker system prune                       # 删除未使用数据
  docker rm [container]                     # 删除1个容器
  docker rm $(docker ps -a -q)              # 删除所有容器
  docker rmi [image]                        # 删除1个镜像
  docker rmi $(docker images -q)            # 删除所有镜像
  docker port [container]                   # 查看端口映射
  docker inspect [container]                # 查看容器详情
  docker rename web [container]             # 容器重命名 > 查看容器 docker ps -a
  docker logs [container]                   # 查看容器日志
  docker update --restart=always [container] # 修改配置: 设置为开机启动 (可在 docker run 时添加此参数)
  
  docker stop 8b49 & docker rm -f mysite    # 停止+删除 :容器[ID前缀3-4位 或 containerName]
  docker stop web & docker commit web myweb & docker run -p 8080:80 -td myweb # commit新容器myweb&端口映射
  docker exec -it redis5 /bin/sh -c "ps aux & /bin/sh"  # 在容器中执行命令: 查看进程详情后,进入工作目录执行sh

  docker run -it --rm -e AUTHOR="Test" alpine /bin/sh #查找镜像alpine+运行容器alpine+终端交互it+停止自动删除+执行命令
  docker run --name mysite -d -p 8080:80 -p 8081:443 dockersamples/static-site #查找镜像&运行容器mysite&服务&端口映射
  
  # 内存KV数据库redis
  docker run --name redis5 --network=workgroup --network-alias=redis5 --restart=always -d -m 512m -p 6379:6379 
    -v d:\docker\app\redis5\redis.conf:/etc/redis/redis.conf -v d:\docker\app\redis5\data:/data 
    redis:5.0.3-alpine redis-server /etc/redis/redis.conf # 执行Sh /usr/local/bin/docker-entrypoint.sh
  docker run -p 6379:6379 -itd redislabs/redistimeseries  # 时序Db https://github.com/RedisLabsModules
  docker run --name ssdb --network=workgroup --network-alias=ssdb -d -m 512m -p 8888:8888 
    -v d:\docker\app\ssdb\ssdb.conf:/ssdb/ssdb.conf leobuskin/ssdb-docker # 替代Redis http://ssdb.io/zh_cn
  
  # 微软开源.netcore 参考 https://docs.docker.com/compose/aspnet-mssql-compose
  # Startup.sh1: docker run -v ${PWD}:/app --workdir /app microsoft/aspnetcore-build:lts dotnet new mvc --auth Individual
  docker run --name dotnet --network=workgroup -it -m 512m -p 8080:80 -v "d:\docker\app\microsoft.net\app:/app" 
    microsoft/dotnet     # 最新版dotnet
    microsoft/dotnet:sdk # 最新版dotnet-sdk 用于开发
    microsoft/dotnet:aspnetcore-runtime #最新版dotnet-runtime 用于生产
  
  # 开源系统 Linux 分支 centos
  docker run --name centos -it --network=workgroup -m 512m -p 8000:80 -v "d:\docker\app\centos\home:/home" -w /home 
    centos /bin/bash # 其它: --workdir /home/ConsoleApp2NewLife centos /bin/sh -c "/bin/bash ./entrypoint.sh"
    $ rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm & yum install -y dotnet-runtime-2.1
    $ dotnet /home/ConsoleApp2NewLife/ConsoleApp2NewLife.dll # 访问tcp://127.0.0.1:8000
  
  # 开源数据库mysql
  docker run --name mysql -itd -p 3306:3306 --network=workgroup --network-alias=mysql --env MYSQL_ROOT_PASSWORD=HGJ766GR767FKJU0 
    mysql:5.7 # mariadb、mongo、mysql/mysql-server、microsoft/mssql-server-linux, (--network-alias)其它容器连此容器
  # 微软数据库mssql
  docker run --name mssql -itd -p 1433:1433 --network=workgroup --network-alias=mssql -v "d:\docker\app\mssql\data:/var/opt/mssql/data" 
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
  
  # 数据库 PostgreSql + 时序数据timescaledb + 云计算
  docker run --name timescaledb -d -p 5432:5432 -e POSTGRES_PASSWORD=123456 timescale/timescaledb:latest-pg11
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
    nsqio/nsq /nsqlookupd  # First Run nsqlookupd for nsqd & nsqadmin 
  docker run --name nsqd --network=workgroup --network-alias=nsqd -p 4150:4150 -p 4151:4151 -v d:\docker\app\nsq\data:/data 
    nsqio/nsq /nsqd --data-path=/data --lookupd-tcp-address=nsqlookupd:4160 # --broadcast-address=<dockerIP>
  docker run --name nsqadmin -d --network=workgroup -p 4171:4171 nsqio/nsq /nsqadmin --lookupd-http-address=nsqlookupd:4161
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
  > minio.exe server d:\docker\app\minio\data  # 本地网盘svr：http://127.0.0.1:9000/ : Access-Key & Secret-Key
  > hidec /w minio.exe server d:\docker\app\minio\data # 隐藏控制台 & 后台运行 & 配置↑ data\.minio.sys\config\config.json
  > nssm install MinIO minio.exe server A:/go/bin/minio/data  # 安装Windows服务[以管理员身份运行]
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
  $ weed master -ip `hostname -i` -mdir="$HOME/.seaweedfs/data" -peers=127.0.0.1:9333 & #启动1个节点n1\文件数据中心c1
  $ weed volume -ip `hostname -i` -dir="$HOME/.seaweedfs/data" -port=8080 -max=15 -mserver=127.0.0.1:9333 & #存储分区v1
  $ weed server -ip `hostname -i` -dir="$HOME/.seaweedfs/data" -master.peers=127.0.0.1:9333 & #数据查询服务c1Api
  $ weed filer -port=8088 -master=127.0.0.1:9333 & #local文件服务Api
  $ weed s3 -domainName=$S3_DOMAIN -cert.file=$S3_CERT -key.file=$S3_KEY -filer=127.0.0.1:8089 & #S3文件服务Api
  #-config>>  $HOME/.seaweedfs/crontab #计划任务配置-文件处理
*/2 * * * * * echo "volume.fix.replication" | weed shell -master=127.0.0.1:9333
*/2 * * * * * echo "volume.balance -c ALL -force" | weed shell -master=127.0.0.1:9333
  $ exec supercronic $HOME/.seaweedfs/crontab & #执行计划任务-使用以上配置文件-依赖master-n1,volume-v1..每2分钟轮训1次
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

# [**Kubernetes**](https://kubernetes.io)

> [`k8s`是一个流行的容器管理编排平台，集中式管理数个服务的容器集群；](https://www.kubernetes.org.cn)<br>
  　文档[project-based-kubernetes](https://github.com/groovemonkey/project-based-kubernetes)、安装[docker-desktop](https://www.docker.com/products/docker-desktop)已集成compose和k8s<br>
  　`Pod`：最小单元、一组容器的集合、同一个Pod内的容器共享网络命名空间、短暂的未存储的(重新发布后会丢失)；<br>
  　`Controllers`： `ReplicaSet`确保预期的Pod副本数量(一般由以下部署产生)，<br>
  　  　`Deployment`无状态的(`website`...)应用部署，<br>
  　  　`StatefulSet`有状态的(网络Id+存储`zk`,`mq`...)应用部署，<br>
  　  　`DaemonSet`确保所有节点运行同一个Pod的(监控`monitor`,计划`schedule`system...)服务部署，<br>
  　  　`Job`一次性任务部署，`CronJob`定时任务部署，其它服务部署... ；<br>
  　`Service`：防止Pod失联、定义一组Pod的访问策略`对外提供访问服务`；<br>
  　`Label`：`标签`，附加到某个资源上，用于关联对象、查询和筛选对象；<br>
  　`Namespace`：`命名空间`，将对象逻辑上隔离。<br>
  　`搭建^6台`：负载均衡`1虚拟IP`高可用`集群` (4核8G;IP1+IP2>>`VIP*`) load-balancer-master,load-balancer-backup<br>
  　  　前后端*`高IO型`的`Web`应用程序 (8核16G;IP3+IP4) k8s-master1,k8s-master2<br>
  　  　长时间*`可水平扩展`的`分布式计算型`任务 (16核64G;IP5+IP6) k8s-node1,k8s-node2 <br>
~~~
# 安装 kubectl client
$ curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubectl 
$ sudo chmod +x kubectl && sudo mv kubectl /usr/local/bin/
# 部署管理程序 kubernetes dashboard
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
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
$ curl -LO https://github.com/kubernetes/minikube/releases/download/v1.3.1/minikube-linux-amd64
$ sudo install minikube-linux-amd64 /usr/local/bin/minikube 
# #安装<推荐方式>使用阿里下载
$ curl -Lo minikube http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v1.3.0/minikube-linux-amd64
$ sudo chmod +x minikube && sudo mv minikube /usr/local/bin/

# 安装虚拟机kvm | https://help.ubuntu.com/community/KVM/Installation
$ kvm-ok && uname -m  #INFO: /dev/kvm exists; x86_64;Ubuntu需升级^18.10 > sudo do-release-upgrade -d
$ sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients libvirt-bin bridge-utils #依赖<ubuntu>
$ curl -LO https://github.com/kubernetes/minikube/releases/download/v1.3.1/docker-machine-driver-kvm2
$ sudo adduser `id -un` libvirt        #添加当前用户到组libvirt
$ sudo chown root:libvirt /dev/kvm     #改变目录kvm的属主 (如果> ll /dev/kvm ;返回root属主)
$ rmmod kvm && modprobe -a kvm         #跳过ERR: Module kvm is in use by: kvmgt kvm_intel
$ sudo apt-get install virt-manager    #可选,安装virt管理应用程序
$ sudo install docker-machine-driver-kvm2 /usr/local/bin/ #安装kvm2
$ libvirtd -d && sudo systemctl start virtlogd.socket #启动kvm2相关服务
# #常用kvm命令
$ cat /var/lib/libvirt/dnsmasq/virbr1.status #通过kvm创建虚拟机的minikube文件记录对应的ip信息等
$ virsh list --all                 #查询安装的虚拟机
$ virsh edit minikube   #配置虚拟机minikube 配置文件
$ virsh setmem minikube 1048576 #设置虚拟机内存限制1G
$ virsh start minikube  #启动已创建的虚拟机
$ virsh suspend|resume minikube #暂停|恢复

# 启动 minikube 集群
$ sudo minikube config set vm-driver virtualbox #默认虚拟机(virtualbox|kvm2)
$ sudo minikube config set memory 4096          #默认内存限制4G(default:2GB-RAM)
$ sudo minikube start --vm-driver=kvm2          #启动+代理;可选--registry-mirror=https://registry.docker-cn.com
  --docker-env HTTP_PROXY=http://f1361db2.m.daocloud.io --docker-env HTTPS_PROXY=http://f1361db2.m.daocloud.io
# #启动<推荐,方式2> 使用阿里的镜像https://registry.cn-hangzhou.aliyuncs.com
$ sudo minikube start --vm-driver=kvm2 --cpus=4 --memory=4096 #推荐kvm2 +限制cpu&memory +日志级别--v=7|3|2|1|0
$ sudo minikube start --vm-driver=virtualbox #Starting local Kubernetes cluster...Starting VM...Downloading
#下载~/.minikube/cache/iso/minikube-v1.3.0.iso < https://storage.googleapis.com/minikube/iso/minikube-v1.3.0.iso

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
~~~
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
~~~
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
~~~
# 版本: 默认API版本为2(修改参数ETCDCTL_API=3)；
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
~~~
  $ sudo docker login --username=angenal@hotmail.com registry.cn-hangzhou.aliyuncs.com
~~~
  2. 从Registry中拉取镜像
~~~
  $ sudo docker pull registry.cn-hangzhou.aliyuncs.com/fp-api/front:[镜像版本号]
~~~
  3. 将镜像推送到Registry
~~~
  # [ImageId]和[镜像版本号]参数(docker images 查询)
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

#### 最常用的工具：find、grep、xargs、sort、uniq、tr、wc、sed、awk、head、tail...
~~~bash
# 文件搜索ls&find----------------------------------------------------------
ls -lhR . |grep -i .key$  # 递归查找文件[后缀名为 .key ; 文件名称排序] --time={atime,ctime} 访问时间, 权限属性改变时间
ls -lhRt . |grep -i .key$  # 递归查找文件[后缀名为 .key ; 文件时间排序] --full-time 输出完整时间ms(默认为内容变更时间)
ls -lhRS . |grep -i .key$  # 递归查找文件[后缀名为 .key ; 文件大小排序] 
ls -lF # 在文件或目录后加上文件类型的指示符号，例如：* 代表可运行文件，/ 为目录，= 为socket文件，| 为FIFO文件等
# 正则查找*.conf              #  ls -lhFRS *.zip  #常用文件查找并按文件大小排序
find . -regex ".*\.conf$" -print0   # -iregex忽略大小写 -print0 使用''作为文件的定界符，就能搜索含空格的文件
# 查找所有非txt文本,  另外还有: -and -or -readable -writable -executable
find . ! -name "*.conf" -print   # ! 非条件 ;排除*.conf ; -print为可选断言
# 指定搜索深度
find . -maxdepth 1 -type f     # -type [ d 只列出目录 l 符号链接 ]
# 最近7天被访问过的所有文件
find . -atime 7 -type f -print # -atime 访问时间(天) -mtime 修改时间 -ctime 变化时间
# 查找大于2k的文件
find . -type f -size + 2k
# 按权限查找
find . -type f -perm 644 -print   # 具有可执行权限的所有文件
find . -type f -user weber -print # 找用户 weber 所拥有的文件
# 找到文件后的后续动作
find . -type f -name "*.tmp" -delete # 删除当前目录下所有的tmp文件; 断言-delete -print0 -printf -prune -quit ...
find . -type f -user root -exec chown weber {} # 将目录下的所有权变更为用户weber [-exec执行动作{}相应文件名]
find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD # 将找到的文件全都copy到另一个目录OLD
find . -type f -name "*.json" -exec ./commands.sh {} # 将找到的文件全都调用可执行脚本

# 文本搜索grep--------------------------------------------------------------
# grep文本搜索 ( -o 只输出匹配的文本行  -v 只输出没有匹配的文本行 )
grep -c "keywords" file.txt  # 统计文件中包含文本的次数
# grep文本搜索 ( -n 打印匹配的行号 -i 搜索时忽略大小写 -l 只打印文件名 )
grep "class" . -R -n  # 在多级目录中对文本递归搜索(程序员搜代码的最爱)
grep -e "class" -e "vitural" file.java  # 匹配多个模式
grep "temp" *file_name* -lZ | xargs -0 rm # 输出以"temp"作为结尾-Z的文件名-l
cat file.txt |xargs   # 将多行输出转化为单行输出(|xargs行转列)
echo "hello world" |xargs -n 1 # 将单行转化为多行输出 -n多行的字段数(-d默认空格拆分)

# 排序sort-------------------------------------------------------------------
# -n 按数字进行排序 VS -d 按字典序进行排序 -r 逆序排序 -k 指定按第N列排序
sort -nrk 1 file.txt # 按第1列逆序排序
sort -bd file.txt    # 忽略像空格之类的前导空白字符
# 消除重复行uniq--------------------------------------------------------------
sort -bd file.txt | uniq
sort -bd file.txt | uniq -c  # 统计各行在文件中出现的次数
sort -bd file.txt | uniq -d  # 找出重复行 -s 开始位置 -w 比较字符数
# 转换tr----------------------------------------------------------------------
echo 123450 | tr '0-9' '9876543210' # 替换对应数字 # 876549
echo abc | tr 'a' '0'               # 0bc
echo i123450 | tr -d '0-9'  # 删除所有数字 # i
echo i123450 | tr -dc '0-9' # 删除所有非数字 -c 求补集
echo file.txt | tr -c '0-9' # 获取文件中所有数字
echo 'as   i' | tr -s ' '   # 压缩字符 -s # as i
cat file.txt | tr [:lower:] [:upper:]    # 小写转大写
# 按列切分文本cut
# 按列拼接文本paste
# 统计行和字符wc---------------------------------------------------------------
find . -type f -name "*.java" -print0 |xargs -0 wc -l # 统计代码行数, wc -w file单词数, wc -c file字符数
# 文本替换利器sed--------------------------------------------------------------
echo 'ABC' | sed 's/[[:upper:]]*/\L&/' # 大写转小写 echo 'ABC' | tr A-Z a-z
sed '/^$/d' file                       # 移除空白行
seg 's/text/replace_text/' file        # 替换每一行的第一处匹配的 text
seg 's/text/replace_text/g' file       # 全局替换
seg -i 's/text/repalce_text/g' file    # -i直接替换原文件
sed -i -e 's,image: vitess/lite,image: yourname/vitess:latest,' *.yaml # 修改所有yaml文件
p=patten && r=replaced && echo "a patten" | sed "s/$p/$r/g" # "双引号"会对表达式求值
# 数据流处理awk----------------------------------------------------------------
#  NR:表示记录数量 NF:表示字段数量 $0:当前行的文本 $1:第一个字段的文本 ...
echo -e "line1 line2" |awk 'BEGIN{print "start"} {print NR" ["NF"]: "$0} END{print "end"}'
echo -e "line1 line2" |awk 'BEGIN{print "start"} {print NR":"$1} END{print "end"}'
echo -e "line1 line2" |awk 'BEGIN{print "start"} {print NR":"$2} END{print "end"}'
awk ' END {print NR}' file  # 统计代码行数 ; 加判断条件[ 行号NR==1,NR==2 ]或 [ /正则表达式/ ]
echo -e "1 2 3 4" |awk 'BEGIN{num=0} NR==1{num+=$1+$2+$3+$4} END {print num}' 
sudo awk -F : '{print $NF}' /etc/passwd   # -F来设置定界符（默认为空格）
awk 'NR<=10 {print}' filename  # 开头10行
awk '{buffer[NR%10]=$0} END {for(i=0;i<11;i++){ print buffer[i %10]} } ' filename # 结尾10行
# 显示文件内容行head&tail------------------------------------------------------
head -n 10 filename # 前10行[默认为10行] head -5 前5行; head -n -10 除最后10行外,显示前面所有内容;
tail -n 10 filename # 后10行[-n默认10] tail -n +10 从开头第10行开始输出; tail -n 2 filename |head -n 1 倒数第2行
~~~

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

