# **系统命令**

# [**windows-cmd**](https://github.com/Awesome-Windows/awesome-windows-command-line) | [windows-tool](https://github.com/Awesome-Windows/Awesome) | [shell](https://github.com/fengyuhetao/shell) | [**linux**](https://wangchujiang.com/linux-command/hot.html) 
> [`All Linux Command`](https://ss64.com/bash/)、[`All Windows CMD`](https://ss64.com/nt/)<br>
> [`《Linux就该这么学》pdf`](https://www.linuxprobe.com/docs/LinuxProbe.pdf)、
  [`《Linux基础课程》video`](https://www.linuxprobe.com/chapter-01.html)<br>

 * [Linux开发环境及常用安装zsh-ssh-git-redis-mysql-mongodb-pilosa-influxdb-grafana-nsq.kafka.rabbitmq..](#linux开发环境及常用安装)
 * [Linux常用命令ls-find-grep-xargs-sort-uniq-tr-wc-sed-awk-head-tail..](#Linux常用命令)
 * [`BASH中文速查表`](https://github.com/angenalZZZ/doc/blob/master/sh/bash.sh)、[`常见命令图解`](#Linux常见命令图解)、[`windows10安装linux(WSL)`](https://www.cnblogs.com/xiaoliangge/p/9124089.html)

~~~bash
  # 帮助
  > help cmd
  $ info       # 系统菜单信息: Basics,Compression,Editors,Screen.…… 菜单导航&帮助文档;
  # 系统菜单信息: GNU Utilities,Individual utilities,Libraries,Math,Network applications,Text manipulation
  $ man        # 在线帮助说明
  $ whatis id  # 查找命令id的帮助说明 print real and effective user and group IDs
  $ history    # 历史命令列表
  $ sudo !!    # 以sudo方式, 执行上一次执行的命令
  $ cd -       # 上次访问目录, 可用于来回切换目录
  $ cd ~       # 用户目录 = $HOME = /home/$(whoami) # root用户 cd ~  = /root 
  
  # 清屏
  > cls
  $ clear      # 快捷命令: alias cls='clear'
  
  # 系统
  > ver              # 系统  修复 > sfc/scannow
  > net config workstation
  > shell:startup    # [开始]菜单/启动/添加*.vbs
  $ uname -a         # 系统信息: $(uname -s)=系统'Linux'; $(uname -m)=CPU架构'x86_64';
  $ egrep -c ' lm ' /proc/cpuinfo  &&  egrep -c '(vmx|svm)' /proc/cpuinfo
  # 系统版本号'发行版本'*** Linux-redhat > cat /etc/redhat-release
  $ cat /etc/os-release # 系统完整信息
  $ cat /etc/issue && lsb_release -cs ; lsb_release -a #Linux发行版本信息+支持的体系结构[amd64,x86_64,arm64]
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
  # 分布式id生成器, 推荐以下6种方式:
  $ guid -n=1 # len(s)=9    boqC5uQ5K                    //(推荐) 生成浏览器请求URL参数 teris-io/shortid
  $ guid -n=2 # len(s)=20   -LwqiJUclrFXp8OsJro9                  生成全局唯一标识符 kjk/betterguid
  $ guid -n=3 # len(s)=36   c195090f-261b-11ea-a869-00155d14724d  生成全局唯一标识符 google/uuid
  $ guid -n=4 # len(s)=36   ab6d20ca-2321-4e6a-ab5b-4879e4d07154  生成全局唯一标识符 satori/go.uuid
  $ guid -n=5 # len(s)=19   1209369639956516864 bb1rme6zhyryy 1577171165824 1 0 //Twitter/snowflake算法: bwmarrin/snowflake
  $ guid -n=6 # len(s)=20   bo0rhq9n39b4430gg1l0 1577171177000000000 1081450 16908 7V //(推荐) github.com/rs/xid
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
  
  # 用户
  > mkdir -p %USERPROFILE% # 用户目录
  > mkdir to/path # 创建目录 $ mkdir -p to/path  [-p递归创建目录]
  > quser         # 当前用户状态
  $ whoami && w && id  # 当前用户信息
  $ echo -e "$USER\n$HOME\n$SHELL\n$PATH\n$LOGNAME\n$MAIL" # 当前用户环境 [-e允许反斜杠转义字符]
  $ id            # 返回 uid=0(root) gid=0(root) groups=0(root)  ; root登录:  su root ; su - ;目录不变
  $ id -u         # 返回 uid          添加用户(-d=$home)      (-G=附加用户组)       例如(用户名=admin)
  $ mkdir -p /home/admin & chmod 777 /home/admin 
  # 新建用户-默认值: useradd -D  |  cat /etc/default/useradd ;修改默认shell: useradd -D -s /bin/zsh
  $ useradd -m -d /home/admin -G adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare,libvirt admin # -m管理员
  $ useradd -d /home/test  -s /bin/bash test # 新建普通用户test
  $ man newusers    # 批量更新和创建新用户
  $ userdel -r test # 删除用户
  $ cat /etc/passwd # 查看所有用户 ; 统计用户数 cat /etc/passwd | wc -l
  $ cat /etc/passwd |grep `id -un` # 查看当前登录用户
  $ cat /etc/shadow # 用户列表
  $ cat /etc/group  # 用户组列表
  $ groups          # 用户所在组
  $ groupadd        # 添加用户组
  $ passwd admin    # 修改密码
  $ login           # 用户登录
  # 修改用户多选组-G=groups   # 查用户组${id -g 用户名} $ groups yangzhou
  $ id -gn && id -Gn         # 返回用户组: sudo grep $USER /etc/group /etc/gshadow
  $ usermod -G yangzhou,adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare,docker,mysql,mongodb,libvirt,rabbitmq yangzhou
  $ usermod -aG rabbitmq yangzhou # 添加组给用户,方便操作.
  # 查询用户更多信息
  $ sudo grep $USER /etc/passwd /etc/shadow /etc/group /etc/gshadow
  $ su - root      # 切换用户至root (并切换到用户主目录/root；超级用户提示符结尾 # 普通用户$ 主目录/home/*)
  $ su - admin     # 切换用户至admin
  $ exit           # 退出登录
  
  # 网络端口
  > netstat -anT                              # tcp端口(本地地址,外部地址,状态)
  > netstat -anp tcp|findstr -i "listening"   # tcp端口-监听列表; [p传输协议]
  $ netstat -tupln (TCP+UDP);  netstat -tpln (TCP);  netstat -upln (UDP);  sudo !!  (以sudo方式, 执行netstat)
  $ netstat -anp|grep 3306                    # 1.通过端口查看进程; 2.通过进程id查看占用端口; [p显示进程]
  $ sudo netstat -anpW |grep -i "grafana-server" # 网络端口资源查找; [端口tcp+udp]
  $ sudo netstat -anptW|grep -i "listen"         # 网络端口资源列表; [端口tcp] 本机所有tcp网络应用程序列表
  $ netstat -atW |grep -i "listen"            # tcp端口-centos $ yum install -y net-tools traceroute
  $ netstat -tulnp | grep -i "time_wait"      # tcp超时-ubuntu $ apt-get update & apt install -y net-tools
  $ ss -t4 state time-wait                    # tcp超时-ubuntu $ apt install -y iproute2 iproute2-doc
  $ ss -at '( dport = :ssh or sport = :ssh )' # 端口为 ssh 的套接字
  $ ss -lntp '( dst :443 or dst :80 )'        # 目的端口为 80,443 的套接字
  $ ss -lntp  # tcp端口+users进程name-pid-fd   # 常用ss(iproute工具)比netstat(net-tools工具)更强大
  $ ss -nt state connected dport = :80
  $ ss -nt dport lt :100  # 端口小于100
  $ ss -nt dport gt :1024 # 端口大于1024
  $ ss -aup   # udp端口
  # sudo apt -y install netcat-traditional # 手动安装netcat(nc)网络调试和探测工具，被誉为网络安全界的“瑞士军刀”
  $ sudo update-alternatives --config nc   # 替换默认安装的 netcat-OpenBSD < ubuntu >
  $ nc -help # 开启服务器监听> nc -lnvp 4488 -w 2 ; netstat -anT|grep 4488 < windows >
  $ nc -vz www.baidu.com 443         # 查询DNS记录
  $ mtr --curses 8.8.8.8             # 跟踪DNS记录+路由地址
  # 域名解析
  $ host localhost
  $ nslookup www.baidu.com           # 查询DNS记录，查看域名解析是否正常
  $ dig -h                           # 查询DNS包括A记录，MX记录，NS记录等信息
  $ dig @server [解析域名] 
  $ dig -x [反向解析IP地址] @server
  $ dig baidu.com +nssearch          # 查找一个域的授权 dns 服务器
  $ dig www.baidu.com +trace         # 从根服务器开始追踪一个域名的解析过程
  $ dig yahoo.com A +noall +answer   # A记录
  $ dig yahoo.com MX +noall +answer  # MX记录
  $ dig yahoo.com NS +noall +answer  # NS记录
  $ dig yahoo.com ANY +noall +answer # 查询上面所有的记录
  $ dig www.baidu.com +short         # 查询快速回答
  $ dig baidu.com ANY +noall +answer +nocmd +multiline # 查询详细回答
  
  # 进程详情
  > tasklist
  > wmic process where "caption = 'java.exe' and commandline like '%server-1.properties%'" get processid
  > netstat -ano | findstr :3000 # 杀死进程使用, 指定占用的端口号
  # taskkill /F /PID <<PID>>     # PowerShell杀死进程
  $ ps aux                       # 进程列表: USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
  $ ps -ef                       # 进程列表: UID  PID  PPID  C STIME TTY TIME CMD
  $ ps -eo pid,cmd | grep uuid   # [o输出字段,e依赖的系统环境]
  $ ps -u $USER -o pid,%cpu,tty,cputime,cmd
  $ ps -ef | grep dotnet         # 查看dotnet进程id
  $ top -Hp [进程id]             # 进程列表: 内存&CPU占用            # 快捷键：k 杀死进程
  $ htop                        # 进程管理:  sudo apt-get install htop
  $ dotnet-dump collect -p [进程id] ; dotnet-dump analyze core_***  # 查找.NET Core 占用CPU 100% 的原因
    > clrthreads ; setthread [线程DBG] ; clrstack ; clrstack -a ; dumpobj 0x00*** # 分析线程/堆栈/内存数据
  $ ps aux | head -1; ps aux | sort -rn -k3 | head -10 # 占用CPU最高的前10个进程
  $ ps -e -o stat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}' | xargs kill -9 # 批量删除(Z开头)僵尸进程
  $ killall -I NAME... # 杀死进程,指定进程名称NAME...
  $ killall -I -s 15 -u `id -un` NAME... # -s 15=TERM结束程序(可以被捕获-阻塞-忽略)+程序内可监听该信号SIG
  $ kill -l            # 查看软件中断SIG [Linux标准信号1~31] (实时信号:32~64) +打印所有支持的信号名称
  # kill -9 <<PID>>    # -9=KILL无条件结束程序(不能被捕获-阻塞-忽略) 
  # 参考: https://gist.github.com/biezhi/74bfe20f9758210c1be18c64e6992a37
  # -1=HUP终端控制进程结束(终端连接断开) -2=INT用户发送INTR字符(Ctrl+C)触发进程结束 -3=QUIT用户发送QUIT字符(Ctrl+/)
  # -18=TSTP暂停进程 -19=CONT继续进程 -17=STOP停止进程(不能被捕获) 
  # -21=TTIN读数据时 -22=TTOU写数据时 -20=CHLD子进程结束(由父进程接收)
  $ lsof | tail        # 系统最近打开的文件(list open files)
  # lsof -p <<PID>>    # 进程打开的文件(包括网络端口等)
  $ lsof -u root       # root最近打开的文件
  $ lsof -i tcp        # tcp网络端口打开的文件
  $ lsof -i :22        # 查看端口号22(sshd)连接情况 lsof 列出当前系统打开的文件
  # lsof -i @localhost:3000 && kill -9 <<PID>> # 杀死进程(指定占用端口号的程序)
  $ smem -k -s USS     # 进程的内存使用情况
  # < ubuntu > apt update & apt install smem
  # < centos > yum install epel-release & yum install smem python-matplotlib python-tk
  
  # 文件系统
  > dir /d /S [目录]     # 默认当前目录(命令pwd)
  > tree /f [目录]
  > devmgmt.msc          # 系统硬件驱动
  $ df -ah               # 文件系统  容量  已用  可用  已用%  挂载点
  $ lsblk                # 文件系统  分区  挂载点
  $ fdisk -l             # 文件系统  硬件  挂载点
  $ ls -al [目录]        # 查看目录及文件读写权限 alias ll='ls -alF' ; alias la='ls -A' ; alias l='ls -CF'
  $ lsof -h              # 查看打开的文件、进程、网络资源等，功能强大。
  $ touch main.js        # 新建文件
  $ mktemp && mktemp -d  # 新建临时文件和临时目录
  $ mv main.js main.cs   # 重命名文件,移动文件位置
  $ cat main.cs          # 输出文件内容
  $ namo|vi main.cs      # 编辑文件内容
  $ file main.js && ls -an main.js # 查看文件类型-信息 & 查看文件读写权限&更新时间
  $ for n in {1..10000}; do echo content > "__${n}.tmp"; done # 创建10000个临时文件
  # linux硬件设备-挂载点  # fdisk 
  /dev/char
  /dev/cdrom                        # 光驱
  /dev/console
  /dev/core -> /proc/kcore
  /dev/cpu
  /dev/disk
  /dev/fd -> /proc/self/fd          # 软驱 /dev/fd[0-1] | dockerd -H fd://
  /dev/input
  /dev/initctl -> /run/systemd/initctl/fifo
  /dev/log -> /run/systemd/journal/dev-log
  /dev/lp                           # 打印机 /dev/lp[0-15] 
  /dev/mem
  /dev/memory_bandwidth
  /dev/mouse                        # 鼠标
  /dev/sda{sda1-3,sdb,sdc,$sdd~sdp} # 硬盘 (a~p 代表 16 块不同的硬盘; 数字代表分区数)
  /dev/snapshot
  /dev/stdin -> /proc/self/fd/0
  /dev/stdout -> /proc/self/fd/1
  /dev/stderr -> /proc/self/fd/2
  /dev/tty
  /dev/usb
  /dev/zero
  
  # 文件查找
  > for /r C:\windows\addins\ %i in (explorer.exe) do @echo %i # 在指定目录下查找匹配文件
  $ locate /bin/ps                  # 遍历文件系统/路径包含/bin/ps所有匹配文件
  $ find / -name [filename]         # 查找在根目录下/所有匹配文件
  $ find /etc -type f -name passwd  # 如下，修改root用户的文件"拥有者"为当前用户:文件占位符{}
  $ find . -type f -user root -exec chown `id -un` {} \; # find文件后-exec执行操作(注意:必须以 \; 结尾)
  
  # 目录访问权限
  > cd [目录]
  $ sudo chown -R 1000 [目录]   # 改变[目录](-R递归修改文件和目录)的"拥有者"为uid:1000 = $(id -u)
  $ sudo chown root:root [目录] # 修改目录的"拥有者"
  $ sudo chgrp –R users [目录]  # 改变[目录]的"所属用户组"为G:users = $(id -g)
  $ sudo chmod 744 [目录]      # 修改当前目录(.)权限为可读写及执行(-R递归修改文件和目录)
  $ sudo chmod 777 to/path    # 每个人都有读和写以及执行的权限(约定的三个数字owner=7;group=7;others=7)
  $ sudo chmod 666 to/path    # 每个人都有读和写的权限(常用于文件上传下载)
  $ sudo chmod 700 to/path    # 只有所有者有读和写以及执行的权限
  $ sudo chmod 600 to/path    # 只有所有者有读和写的权限
  $ sudo chmod 644 to/path    # 所有者有读和写的权限，组用户只有读的权限
  $ [ -d /temp ] ||  sudo mkdir /temp && sudo chmod -vR 1777 /temp # 创建共享临时目录 drwxrwxrwt
  $ sudo chmod -vR +t /temp   # 添加目录[文件删除+重命名]的权限 ...rwt
   #0 : None  #1 : Execute Only  #2 : Write Only  #3 : Write & Execute  #4 : Read Only
   #5 : Read & Execute  #6 : Read & Write  #7 : Read, Write & Execute
  
  # 文件复制
  > xcopy "来源目录" "目标目录" /E /H /K /X /Y
  > xcopy /isy C:\...\bin\Release\netcoreapp2.1\* F:\app\dotnetcore\centos\a
  > robocopy /e source destination [file [file]...] # Windows的可靠文件复制/备份  帮助: robocopy /?
  $ cp -if /mnt/floppy/* ~/floppy                   # [~/floppy 指向 /root/floppy 或 /home/floppy]
  $ cp -if /mnt/d/Docker/App/ubuntu/usr/local/bin/* /usr/local/bin # [i覆盖文件时,询问?]
  $ cp -fr /usr/local/bin/* /mnt/d/Docker/App/ubuntu/usr/local/bin # [r复制文件目录!]
  
  > mklink /d "来源目录" "目标目录"  # 创建目录的`符号链接(软链接)`
  $ ln -s '来源目录' '目标目录'
  > mklink /j "来源目录" "目标目录"  # 创建目录的`目录联接(硬链接)`
  $ ln -f '来源文件' '目标文件'      #-f强制(可选参数)
  
  # 系统备份和还原
  $ tar -czpvf /media/yangzhou/Software/Software/ubuntu/backup@`date +%Y`.tar.gz 
    --exclude=/proc --exclude=/tmp --exclude=/boot --exclude=/home --exclude=/lost+found 
    --exclude=/media --exclude=/mnt --exclude=/run / # -c备份文档 -z用gzip压缩 -p保存权限 -v显示详细 -f输出文件
  $ tar -xzpvf /media/yangzhou/Software/Software/ubuntu/backup@`date +%Y`.tar.gz -C /
  # linux-live-U盘+启动盘制作       df -h # 查找U盘位置<假如为sdb>
  $ sudo ntfs-3g /dev/sda1 /mnt/windows  # 挂载硬盘分区<假如为sda1:第1块硬盘分区1>
  $ sudo /sbin/mount.ntfs /dev/sdc2 /40g -o rw,nosuid,nodev
  $ sudo /sbin/mount.ntfs /dev/sdc3 /20g -o rw,nosuid,nodev
  $ sudo umount /dev/sdb*                # 手动卸载 U盘
  $ sudo mkfs.vfat /dev/sdb -I           # 格式化 U盘
  $ sudo dd if=~/ubuntu.iso of=/dev/sdb  # 制作 U盘启动盘
  
  # 文件删除
  > del /f /s /q [目录|文件]
  > rd /s /q %windir%\temp & md %windir%\temp [删除临时文件]
  $ rm -f -r [r删除目录,否则删除文件] [f强制]
  $ rmdir   [移除空目录]
  
  # 网络地址 - inet&inet6
  > ipconfig /?
  > hostname     # `主机名`
  $ hostname -i  # 127.0.1.1
  $ ifconfig |grep inet
  $ ifconfig |grep 'inet ' |head -5  # 获取前5条ipV4
  $ ifconfig |grep 'inet6' |head -5  # 获取前5条ipV6
  # 科学上网 - 代理设置 (解决网络问题)  蓝灯: https://github.com/getlantern/lantern
  $ sudo vim /etc/profile [全局|用户配置：~/.profile] # 填写如下VPN转发PORT
  export FTP_PROXY=http://<proxy hostname:port>      # 临时使用
  export HTTP_PROXY=http://<proxy hostname:port>
  export HTTPS_PROXY=https://<proxy hostname:port>
  export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24
  # 主机环境 - 解析设置 github.com/googlehosts/hosts
  > notepad C:\Windows\System32\drivers\etc\hosts
  > set                 # 查看系统环境变量windows
  $ export              # 查看系统环境变量linux
  $ cat /etc/hosts      # 一次显示整个文件
  $ cat > /etc/hosts    # 从键盘创建一个文件
  > ipconfig /flushdns  # 刷新dns缓存
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
  
  # 系统硬件信息
  > wmic memorychip list brief        # 内存条列表  # 参数可选 list [brief|full|writeable]
  > wmic bios|cpu|desktopmonitor|diskdrive|environment|logicaldisk
        |os|process|product|service|share|useraccout... /?    # 查看命令列表/?
  > wmic process where name="qq.exe" delete # 删除进程 # 参数可选 process [create|delete|list]
  > wmic cdrom where drive='G:' get SerialNumber # 光驱序列号
  > wmic memorychip get serialnumber  # 内存序列号
  > wmic diskdrive get serialnumber   # 磁盘序列号
  > wmic baseboard get serialnumber   # 主板序列号
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
  
  # Let’s Encrypt 免费证书 https://go-acme.github.io/lego/usage/cli/examples/
  $ lego --email="foo@bar.com" --domains="example.com" --http run   # 获取证书 ACME v2 版本支持申请通配符证书了
  $ AWS_REGION=us-east-1 AWS_ACCESS_KEY_ID=my_id AWS_SECRET_ACCESS_KEY=my_key \
  $ lego --email="foo@bar.com" --domains="example.com" --dns="route53" run # 获取证书时使用AWS/DNS
  $ lego --email="foo@bar.com" --http --csr=/path/to/csr.pem run # 获取给定由其他内容生成的证书签名请求(CSR)的证书
  $ lego --email="foo@bar.com" --domains="example.com" --http renew # 续订证书
  $ lego --email="foo@bar.com" --domains="example.com" --http renew --days 45 # 证书在45天内过期时续订证书
  $ lego --email="foo@bar.com" --domains="example.com" --http renew --renew-hook="./myscript.sh" # 续订证书(钩子)
  
  # Let’s Encrypt 免费证书/自动化脚本 https://github.com/srvrco/getssl
  $ curl --silent https://raw.githubusercontent.com/srvrco/getssl/master/getssl > getssl ; chmod 700 getssl
  $ ./getssl -c yourdomain.com  # config, set email account.
  $ getssl yourdomain.com       # run
  $ crontab
  23  5 * * * /root/scripts/getssl -u -a -q  # auto updates
  
  # Let’s Encrypt 免费证书/自动化工具 https://certbot.eff.org
  $ sudo add-apt-repository universe
  $ sudo add-apt-repository ppa:certbot/certbot
  $ sudo apt-get update
  $ sudo apt-get install certbot
  # certbot-auto -V  # update client version for certbot^0.22.0 # 1.登录域名管理给域名添一个 DNS TXT 记录
  $ tree /etc/letsencrypt/accounts  # 如何使用 ACME v2 版本?  https://www.jianshu.com/p/c5c9d071e395
  $ certbot-auto certonly -d *.newyingyong.cn --manual --preferred-challenges dns \
    --server https://acme-v02.api.letsencrypt.org/directory # 2.没有获得 DNS TXT 记录生效前不要回车执行确认
  $ dig -t txt _acme-challenge.newyingyong.cn @8.8.8.8      # 2.1确认获得 DNS TXT 记录是否生效的命令
  $ tree /etc/letsencrypt/archive/newyingyong.cn            # 2.2证书申请成功
  $ openssl x509 -in /etc/letsencrypt/archive/newyingyong.cn/cert1.pem -noout -text # 2.3校验证书
  $ certbot-auto certificates                               # 2.4查看机器上有多少证书
  # 自动续期证书参考 https://github.com/ywdblog/certbot-letencrypt-wildcardcertificates-alydns-au
  
  # openssl 管理证书 https://www.openssl.org/docs/manmaster/man1/
  #1.创建openssl数字签名认证
  ## 快捷方式 openssl req -new -nodes -x509 -out server.crt -keyout server.key -days 3650 \
    -subj "/C=DE/ST=NRW/L=Earth/O=Company-Name/OU=IT/CN=127.0.0.1/emailAddress=***@example.com"

  ## 本机开发证书 localhost.crt & localhost.key  # hosts可指定子域名www等: 127.0.0.1 www.localhost
  openssl req -x509 -out localhost.crt -keyout localhost.key -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' -extensions EXT -config <( printf "[dn]\nCN=localhost\n[req]\ndistinguished_name \
    = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

  ## 单个域名 [sv.key sv.crt ci.key ci.crt] -一般用于本地开发(无密码验证-pass*)
openssl genrsa -out sv.key 2048    # genrsa生成server端密钥文件
openssl req -new -x509 -days 3650 -key sv.key -out sv.crt -subj "/C=GB/L=China/O=grpc-server/CN=server.grpc.io"
openssl genrsa -out ci.key 2048    # genrsa生成client端密钥文件
openssl req -new -x509 -days 3650 -key ci.key -out ci.crt -subj "/C=GB/L=China/O=grpc-client/CN=client.grpc.io"
  ## 单个域名+CA [ca.key ca.crt sv.key sv.crt ci.key ci.crt] -一般用于服务器生产
openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj "/C=GB/L=China/O=gobook/CN=github.com"
 // 生成server端`证书签名请求文件`sv.csr,然后根证书重新对server端签名,获得sv.crt
openssl req -new -key sv.key -out sv.csr -subj "/C=GB/L=China/O=server/CN=server.io"
openssl x509 -req -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in sv.csr -out sv.crt
 // 生成client端`证书签名请求文件`ci.csr,然后根证书重新对client端签名,获得ci.crt
openssl req -new -key ci.key -out ci.csr -subj "/C=GB/L=China/O=client/CN=client.io"
openssl x509 -req -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in ci.csr -out ci.crt

  ## 多IP+多域名+CA [ca.key ca.crt server.key server.crt server.pem]
openssl rand -out ~/.rnd $(date +%s)   # rand生成随机数文件
mkdir -p ./demoCA/newcerts && touch demoCA/index.txt demoCA/index.txt.attr && echo 01 |tee demoCA/serial 
openssl genrsa -passout pass:123456 -des3 -out ca.key 1024
openssl req -passin pass:123456 -new -x509 -days 3650 -key ca.key -out ca.crt \
    -subj "/C=CN/ST=SiChuan/CN=www.fpapi.cn" -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))
openssl genrsa -passout pass:123456 -des3 -out server.key 1024
openssl req -passin pass:123456 -new -key server.key -out server.csr \
    -subj "/C=CN/ST=SiChuan/CN=www.fpapi.cn" -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))
openssl ca -passin pass:123456 -days 3650 -in server.csr -keyfile ca.key -cert ca.crt -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))
openssl rsa -passin pass:123456 -in server.key -out server.key
openssl pkcs8 -topk8 -nocrypt -in server.key -out server.pem

  #1.1使用openssl加密解密
  openssl list -help            # 帮助
  openssl list -commands        # 命令列表
  openssl list -cipher-commands # 加密方式列表
  # 加密签名 hmac+sha256
  SIGNATURE="$(printf "${TIMESTAMP}${TOKEN}"|openssl dgst -sha256 -hmac "${SECRET}" -binary|openssl enc -base64)"
  # 编码解码 base64
  openssl base64 -in file.bin -out file.b64
  openssl base64 -d -in file.b64 -out file.bin
  # AES128加密 (CBC模式&PBKDF2密钥)密码+Salt 可选模式:aes-[128|192|256]-[cbc|cfb|cfb1|cfb8|ctr|ecb|ofb]
  openssl enc -aes128 -pbkdf2 -in file.txt -out file.aes128    # 需输入密码<password>
  openssl enc -aes128 -pbkdf2 -d -in file.aes128 -out file.txt -pass pass:<password>
  # AES256加密 (CTR模式&PBKDF2密钥)密码+Salt + base64
  openssl enc -aes-256-ctr -pbkdf2 -a -in file.txt -out file.aes256  # 需输入密码<password>
  openssl enc -aes-256-ctr -pbkdf2 -d -a -in file.aes256 -out file.txt -pass file:<passfile> #提供密钥文件
  
  #2.安装mkcert数字签名工具 github.com/FiloSottile/mkcert *22k
  $ sudo apt install libnss3-tools  #or: sudo yum install nss-tools #or: sudo pacman -S nss
  $ git clone github.com/FiloSottile/mkcert && go build -ldflags "-X main.Version=$(git describe --tags)"
  $ mkcert -help    #.用于搭建本地CA数字签名认证: CA, Digital Signature, Key Encipherment, Certificate Signing.
  $ mkcert -CAROOT  #1.查看证书存储路径"${HOME}/.local/share/mkcert": rootCA.pem,rootCA-key.pem
  $ mkcert -install      #2.安装本地CA证书,为下面创建证书作准备↑↑
  $ mkcert example.com "*.example.com" localhost 127.0.0.1 ::1 #3.创建证书,指定域名或IP
  #3.1修改PowerShell脚本执行策略 windows
  > Get-ExecutionPolicy
  > Set-ExecutionPolicy RemoteSigned [RemoteSigned,AllSigned,Bypass,Restricted] # 全选 A (以管理员身份执行)
  #3.2创建PowerShell数字签名认证 windows 10
  > cd "C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64" # 签名工具makecert [-eku设为代码签名]
  > makecert -n "CN=Api Cert" -a sha1 -eku 1.3.6.1.5.5.7.3.1 -r -sv api-root.pvk api-root.cer -ss Root -sr LocalMachine
  #3.3打开PowerShell查询数字签名证书
  > ls Cert:\CurrentUser\Root | where {$_.Subject -eq "CN=Api Cert"}

  # 请求Http资源的工具curl
  $ curl https://www.baidu.com/ |tee baidu.index.html  # 下载并保存html
  $ for i in {1..100}; do curl https://postman-echo.com/time/now?i=$i; done # 循环执行100次请求http
  $ curl -XGET https://127.0.0.1:8080/v1/user -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1MjgwMTY5MjIsImlkIjowLCJuYmYiOjE1MjgwMTY5MjIsInVzZXJuYW1lIjoiYWRtaW4ifQ.LjxrK9DuAwAzUD8-9v43NzWBN7HXsSLfebw92DKd1JQ" \
    --cacert ca.crt --cert sv.crt --key sv.key  # 开发环境 自签名证书(结合 √ #1.创建openssl → ## 单个域名+CA)
  $ curl -XPOST --header 'Accept: application/json' --header 'Content-Type: application/json;charset=UTF-8' \
    -d '{"Params":{"NodeId":"212","Title":""},"PageIndex":1,"Order":"DESC","PageSize":10,"SortName":"AddDate"}'\
    'http://api.xxx.com/xxx/xxx' | jq

  # 请求Http资源的工具postwoman > postman
  $ git clone https://github.com/postwoman-io/postwoman-proxy.git
  $ ./build.sh windows|linux|darwin [server]       # To build the desktop or server application
  $ ./server --host="localhost:9159" --token=""    # server token: blank= allowing anyone to access
  > nssm install PostwomanProxyWSLubuntu1804 bash.exe -c postwoman-proxy-server # 启动前设置Windows服务登录账户为Administrator
  
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
  ##安装zsh(1)
  $ sudo apt-get -y install zsh
  # 设置`用户终端`shell默认为zsh, 输入命令chsh后>选择>重启终端 [sudo修改root的默认shell]
  $ chsh -s `which zsh`  # 修改默认$BASH [可选项]Login Shell: [/bin/bash] -> [/usr/bin/zsh]
  # 个性化Vim配置 [可忽略该选项] github.com/skywind3000/vim
  $ i=https://raw.githubusercontent.com/skywind3000/vim/30b702725847bac4708de34664bb68454b54e0c0/etc/zshrc.zsh
  # 下载zshrc (执行zsh时,会加载.zshrc) github.com/zsh-users
  $ i=https://raw.githubusercontent.com/angenalZZZ/doc/master/sh/zshrc.zsh # 个人备份zshrc
  $ curl -L $i > ~/.zshrc
  
  ##配置zsh(2)为一般用户 
  #1->config shell init: ~/.zshrc
  # antigen theme +> 添加[主题ys]
  antigen theme ys   # 参考 github.com/robbyrussell/oh-my-zsh/wiki/themes
  # shell login   +> 加载个性化用户设置
  [ -f "$HOME/.profile" ] && source "$HOME/.profile"
  [ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
  #2->config shell login: ~/.profile
  # load aliases  +> 加载个性化命令设置
  [ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"
  # 或者使用; if [ -f "$HOME/.bash_aliases" ]; then . "$HOME/.bash_aliases"; fi
  ##启动zsh(3) 输入命令zsh; 如果出现权限问题compinit解决如下:
  $ sudo chmod -R 755 /usr/local/share/zsh/site-functions
  $ source ~/.zshrc  # 执行脚本,使配置生效.
  
  ##配置zsh(2)为系统用户root 
  $ su - root
  $ cp /home/*/.zshrc /root/.zshrc
  #2->config shell login: ~/.zshrc
  [ -f "$HOME/.profile" ] && source "$HOME/.profile"
  [ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"
  # [ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
  ##启动zsh(3) 输入命令zsh
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
  $ sudo apt install build-essential  # 安装gcc/g++/gdb/make工具链
  $ sudo apt install autoconf automake libgtk2.0-dev pkg-config gnome-core # 桌面开发gtk/glib/gnome
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
  # runuser -l yangzhou -s /bin/sh -m -c "/usr/local/nginx/sbin/nginx" # 启动(可用 su+目标用户的密码; sudo+自己的密码)
  
  $ sudo systemctl disable nginx && sudo systemctl stop nginx # 安装OpenResty > cd /tmp
  $ sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates software-properties-common
  $ wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -  # 导入GPG密钥
  $ sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" # 添加官方APT仓库
  $ sudo apt-get update  # 更新APT索引
  $ sudo apt-get -y install openresty # 安装OpenResty 参考 openresty.org/cn/linux-packages.html
  $ sudo apt-get -y install --no-install-recommends openresty # 最小化安装,不装推荐的openresty-opm,openresty-restydoc
  #-config>>  /usr/local/openresty/nginx/conf/nginx.conf
  $ sudo systemctl restart openresty  # 重启; 开始HelloWorld  openresty.org/cn/getting-started.html
  
  $ sudo apt install nodejs # 安装Nodejs(此安装方式版本太低; 推荐wget安装方式-如下)
  $ wget https://npm.taobao.org/mirrors/node/v13.6.0/node-v13.6.0-linux-x64.tar.gz
  $ sudo tar -zxf node-v13.6.0-linux-x64.tar.gz -C /usr/local/
  $ sudo mv /usr/local/node-v13.6.0-linux-x64 /usr/local/node
  $ sudo chown `id -un`:`id -gn` /usr/local/node -R  # 设置目录
  $ export PATH=/usr/local/node/bin:$PATH # 配置环境变量,如下 01-locale-profile.sh (替代选项)设置软链接 ln
  $ sudo ln -sf /usr/local/node/bin/node /usr/local/bin/node
  $ sudo ln -sf /usr/local/node/bin/npm /usr/local/bin/npm
  
  # 通讯协议: thrift.apache.org
  #1.Thrift是一种接口描述语言和二进制通讯协议，它被用来定义和创建跨语言的服务。它被当作一个远程过程调用（RPC）框架来使用，是由Facebook为“大规模跨语言服务开发”而开发的。
  $ sudo apt-get install automake bison flex g++ git libboost-all-dev libevent-dev libssl-dev libtool make pkg-config
  
  # 安装ffmpeg视频编码/解码libraries: avcodec,avformat,avutil,avfilter,avdevice,swresample,swscale
  sudo apt-get -y install autoconf automake build-essential  # 先安装gcc/g++/gdb/make工具链
  sudo apt-get -y install libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev \
    libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev \
    libavdevice-dev libavfilter-dev libswscale-dev libavcodec-dev libavformat-dev libswresample-dev libavutil-dev
  sudo apt-get install yasm
  
  # 环境变量: https://github.com/angenalZZZ/doc/blob/master/sh/01-locale-profile.sh
  # path 系统目录;SHELL搜索目录;
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  # java 开发环境;java,javaw,javaws,jdb,jps,jrunscript,keytool等
  export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre # export JAVA_HOME=/usr/local/java/jdk1.8.0_221
  export JAVA_BIN=$JAVA_HOME/bin
  export JRE_HOME=$JAVA_HOME/jre
  export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
  export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
  export JAVA_VERSION=8u212
  export SCALA_VERSION=2.12
  export GLIBC_VERSION=2.29-r0
  # ffmpeg 视频编码/解码/开发环境
  export FFMPEG_ROOT=$HOME/ffmpeg
  export CGO_LDFLAGS="-L$FFMPEG_ROOT/lib/ -lavcodec -lavformat -lavutil -lswscale -lswresample -lavdevice -lavfilter"
  export CGO_CFLAGS="-I$FFMPEG_ROOT/include"
  export LD_LIBRARY_PATH=$HOME/ffmpeg/lib
  # go get -u github.com/giorgisio/goav  # 提供开发 go sdk
  # https://github.com/shimberger/gohls  # 提供点播 gohls -h ?目录中自动转码> HTTP Live Streaming (HLS)
  # https://github.com/MattMcManis/Axiom # 提供视频转码/格式转换 c# gui windows
  
  # 快捷命令: https://github.com/angenalZZZ/doc/blob/master/sh/02-bash_aliases.sh
  alias lht='ls -lht'  # 文件列表-按时间倒序
  alias lhs='ls -lhS'  # 文件列表-按大小倒序
  alias start-pg='sudo service postgresql start'
  alias run-pg='sudo -u postgres psql'
~~~

> `Git` 代码版本管理
~~~shell
  $ sudo add-apt-repository ppa:git-core/ppa
  $ sudo apt-get update
  $ sudo apt install git
  $ git --version                                        # git config --local -l       # 本地配置
  $ git config --global user.name "yangzhou"             # git config --local user.name "用户名"
  $ git config --global user.email "angenal@hotmail.com" # git config --local user.email "用户邮箱地址"
  $ git config --global http.postBuffer 524288000        # set more buffer
  $ git config --global http.sslVerify "false"           # set cancel ssl of https
  $ git init [Git项目所在目录-默认当前目录]                # git init app && ls app/.git/
  $ git status ; git stash list ; git diff      # 状态repos
  $ git add [file]                              # 新增file
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
  > Gitea 版本管理文档 docs.gitea.io/zh-cn  下载 dl.gitea.io  源码 github.com/go-gitea/gitea
  # adduser --system --shell /bin/bash --gecos 'Git版本控制' --group --disabled-password --home /home/git git
  # Gitea 注册Windows服务               (可选项)环境变量 GITEA_WORK_DIR 
  > sc create gitea start= auto binPath= "D:\Program\Git\Server\gitea\gitea.exe web --config \"D:\Program\Git\Server\gitea\custom\conf\app.ini\""
~~~

> [`Redis`](http://www.redis.cn) 内存数据库
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
  $ sudo systemctl status mysql        # 检查状态
  $ sudo systemctl enable mysql        # 开机启动
  $ ps aux |grep mysqld　　　　　       # 查看进程 /usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid
  $ cat /etc/mysql/debian.cnf          # 查看系统密码
  $ mysql -u debian-sys-maint -p       # 准备修改密码
  > use mysql;
  > update mysql.user set authentication_string=password('root') where user='root' and Host ='localhost';
  > update user set plugin="mysql_native_password";
  > flush privileges; quit;
  $ sudo service mysql restart          # 重启 systemctl restart mysql
  $ mysql -P3306 -uroot -p < init.sql   # 以root身份登录并执行脚本> source init.sql
  # 配置远程访问 (@'localhost'本机访问; @'%'所有主机都可连接)
  > CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
  > select * from user where user='root' \G;  # 查询当前用户: SELECT USER();
  > grant select,insert,update,delete,create,drop,index,alter on dbname.* to newuser@192.168.1.* identified by 'root';
  > GRANT ALL PRIVILEGES ON dbname.* TO 'newuser'@'%' IDENTIFIED BY 'root'; # 授权newuser
  > GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root'; # 默认授权
  > SET PASSWORD FOR 'root'@'%' = PASSWORD('root');    # 设置密码为root
  > mysqladmin -u root password 123456                  # 初始化密码
  > mysqladmin -u root -p 123456 password HGJ766GR767FKJU0 # 修改密码
  > mysqladmin -u root -p shutdown                      # 关闭mysql
  
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

> [`PostgreSQL`](https://www.postgresql.org) 关系型数据库
~~~shell
  $ sudo apt-get update
  $ sudo apt-get -y install postgresql postgresql-contrib # 安装 psql --version
  $ sudo systemctl enable postgresql.service              # 开机启动,WSL将为 sudo /etc/inid.d/postgresql enable
  $ sudo service postgresql status,start,stop             # 状态,启动,停止
  $ sudo passwd postgres                                  # 分配密码后连接到数据库
  $ sudo -u postgres psql -c "\du"                        # 执行psql命令(以用户postgres身份)
  $ sudo apt-get purge postgre*                           # 卸载
~~~

> [`Mongodb`](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu) NoSql数据库
~~~shell
  $ wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
  $ sudo apt-get install gnupg
  $ echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" \
    | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
  $ sudo apt-get update
  $ sudo apt-get install -y mongodb-org                                  # 安装最新版
  $ sudo apt-get install -y mongodb-org=4.2.2 mongodb-org-server=4.2.2 \ # 安装指定的版本(推荐)
    mongodb-org-shell=4.2.2 mongodb-org-mongos=4.2.2 mongodb-org-tools=4.2.2
  $ echo "mongodb-org hold" | sudo dpkg --set-selections         # 阻止升级，将包固定在当前版本
  $ echo "mongodb-org-server hold" | sudo dpkg --set-selections  # 包含mongod守护程序, 初始化脚本和配置文件
  $ echo "mongodb-org-shell hold" | sudo dpkg --set-selections   # 包含mongo外壳shell
  $ echo "mongodb-org-mongos hold" | sudo dpkg --set-selections  # 包含mongos守护进程
  $ echo "mongodb-org-tools hold" | sudo dpkg --set-selections   # 工具: mongoimport bsondump, mongodump 等
  $ sudo service mongod status,start,stop,restart         # 查服务状态,启动,停止等
  $ sudo systemctl enable mongod.service                  # 开机启动,WSL> sudo /etc/init.d/mongodb status,start..
  > mongo --eval 'db.runCommand({ connectionStatus: 1 })' # 诊断服务,正在运行
  $ sudo apt-get purge mongodb-org*                       # 卸载 rm -rf /var/log/mongodb /var/lib/mongodb
~~~

> [`Elasticsearch`](https://www.elastic.co/guide/cn/elasticsearch/guide/current/index.html) 你知道的, 为了搜索。[中文社区](https://elasticsearch.cn)、[下载](https://www.elastic.co/downloads/elasticsearch)
~~~shell
  $ sudo dpkg -i elasticsearch-7.5.1-amd64.deb   # 安装Es,WSL> sudo /etc/init.d/elasticsearch status,start..
  $ cd /usr/share/elasticsearch/                 # 进入Es目录
  $ bin/elasticsearch --help
  $ bin/elasticsearch -d # 手动启动Es,后台运行-d,检查> curl localhost:9200 -H "Content-Type: application/json"
  $ sudo usermod -aG elasticsearch yangzhou # 添加组给用户,方便操作. id -Gn
  # su -l elasticsearch -m -s /bin/sh -c "/usr/share/elasticsearch/bin/elasticsearch" # 为解压安装方式时启动
  # dpkg --remove elasticsearch && dpkg --purge --force-all elasticsearch       # 卸载
  # rm -rf /etc/elasticsearch /var/lib/elasticsearch /usr/share/elasticsearch   # 清理
  
  # 安装Es插件 ik 中文分词
  $ bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download
    /v7.5.1/elasticsearch-analysis-ik-7.5.1.zip
  # 安装Es插件 pinyin 中文拼音
  $ bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download
    /v7.5.1/elasticsearch-analysis-pinyin-7.5.1.zip
  $ bin/elasticsearch-plugin install analysis-kuromoji
  # 搭建集群 -> 配置: /etc/elasticsearch/elasticsearch.yaml > Cluster ...
  # cluster.name: c1         集群名称;             //*-配置部落节点/跨集群调用时设置tribe;
  # node.name: node-1        节点名称-对应一台主机; //*-不配置node.master&node.data时默认true;
  # node.master: true        节点选举-可为master; //1-master节点管理&添加索引&分片分配(索引主分片数不允许再改);
  # node.data: true          节点选举-可为data; //2-data节点CRUD //3-客户端节点/路由节点/负载均衡master&data=false
  # node.attr.rack: r1       节点属性[选填]; 前缀 r 指数据备份节点data, m 指集群主节点master;
  # network.host: 0.0.0.0    当前宿主机ip地址; 非127.0.0.1时表示正式部署;
  # http.port: 9200          绑定端口号;
  # discovery.seed_hosts: ["host1_ip","host2_ip","host3_ip"] 集群中每台宿主机的ip地址;
  # cluster.initial_master_nodes: ["node-1"]  启动前 选举节点策略;
  # gateway.recover_after_nodes: 2            启动后 选举节点策略(master_eligible_nodes/2)+1 [轻集群3个节点时>=2]
  # http.cors.enabled: true                   客户端 请求允许跨域;
  # http.cors.allow-origin: "*"
  
  # 安装数据采集Beats  Go语言开发 github.com/elastic/beats  下载 www.elastic.co/cn/downloads/beats
  # 指标采集Metricbeat 日志收集Filebeat  审计日志Auditbeat     系统事件日志采集Winlogbeat
  # 网络流量Packetbeat 系统监控Heartbeat 云服务监控Functionbeat
  
  # 安装Kibana可视化工具
  $ sudo dpkg -i kibana-7.5.1-amd64.deb          # 安装Kibana
  $ cd /usr/share/kibana/                        # 进入Kibana目录
  $ bin/kibana --help [--allow-root]             # 配置config/kibana.yml "elasticsearch.hosts"指向ES
  # 启动Kibana   /plugins(安装时可设代理http_proxy): bin/kibana-plugin install elastic/sense
  $ bin/kibana -H 127.0.0.1 -p 5601 # 参数可设置kibana.yml,访问: http://localhost:5601
  
  # 使用Docker安装Elastic Stack (ELK)
  # 使用可选项：github.com/sherifabdlnaby/elastdocker
  # https://github.com/angenalZZZ/doc/blob/master/sh/elasticsearch-7-docker-compose.yml
  > docker network create -d bridge elk7         # 网络 elk7 - created
  > docker run --name elasticsearch7 --network elk7 --network-alias elasticsearch \
      -v "d:/docker/app/elasticsearch7/data:/usr/share/elasticsearch/data" \  # 数据盘映射
      -e "discovery.type=single-node" -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
      --restart=always -itd -m 512m -p 19200:9200 -p 19300:9300 \ # 网址 http://localhost:19200/?pretty
      elasticsearch:7.5.1                        # 安装 elasticsearch-v7.x.x + Es插件 ik 中文分词
       sh -c "bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases
       /download/v7.5.1/elasticsearch-analysis-ik-7.5.1.zip" 
  > docker run --name kibana7 --network elk7 --network-alias kibana -e "I18N_LOCALE=zh-CN" \
      --restart=always -itd -p 15601:5601 \        # 网址 http://localhost:15601 < http://elasticsearch:9200
      docker.elastic.co/kibana/kibana:7.5.1      # 安装 kibana-v7.x.x with xpack
    # neemuchaordic/kibana-without-xpack         # 安装 kibana-v7.x.x without xpack
  > docker run --name cerebro --network elk7 --network-alias cerebro \
      --restart=always -itd -p 19201:9000 \      # 网址 http://localhost:19201 < http://elasticsearch:9200
      lmenezes/cerebro:0.8.5                     # 安装 elasticsearch 管理工具 cerebro
~~~

> [`Pilosa`](https://www.pilosa.com) 分布式位图索引数据库
~~~shell
  $ curl -LO https://github.com/pilosa/pilosa/releases/download/v1.4.0/pilosa-v1.4.0-linux-amd64.tar.gz
  $ tar xfz pilosa-v1.4.0-linux-amd64.tar.gz 
  $ sudo cp -i pilosa-v1.4.0-linux-amd64/pilosa /usr/local/bin
  $ pilosa server --data-dir ~/.pilosa --bind :10101 --handler.allowed-origins "*" & #启动后> curl localhost:10101
  $ go get github.com/pilosa/console && cd $GOPATH/src/github.com/pilosa/console \
    && make install && pilosa-console -bind :10102  # 指定origins: http://localhost:10102
~~~

> [`InfluxDB`](https://portal.influxdata.com) 时间序列数据库
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

> [`Grafana`](https://grafana.com/docs/) 一个开源的度量分析与可视化套件  漂亮的监测、报警、指标分析、图表工具<br>
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

> `系统服务` 计划任务管理<br>
    Ⅰ.[uber/cadence](https://cadenceworkflow.io) [分布式的、可扩展的、高可用的任务编排引擎，异步执行长时间运行的业务逻辑](https://github.com/uber/cadence)
~~~bash
#Ⅰ.<linux> crontab
> less /etc/crontab # 系统服务 > crontab [-u user] file # 参考file先设置环境变量再添任务:
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,>
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
  17 *  *  *  * root    cd / && run-parts --report /etc/cron.hourly
# 特定字符的含义如下：
# * 表示匹配该域的任意值，假如在minute域使用*, 即表示每分钟都会触发事件。
# ? 字符仅被用于“日”和“周”两个子表达式，表示不指定值，当两个子表达式其中之一被指定了值以后，为了避免冲突，需要将另一个子表达式的值设为“?”。
# - 表示范围，例如在minute域使用5-20，表示从5分到20分每分钟触发一次。
# / 表示起始时间开始触发，然后每隔固定时间触发一次，例如在minute域使用5/20,则意味着在5分的时候开始触发一次，而25，45等分别触发一次。
# , 表示列出枚举值。例如：在minute域使用5,20，则意味着在5和20分每分钟触发一次。

#Ⅰ.<windows&linux> gocron（替代Linux-crontab）& gocron-node & mysql
> nssm install Gocron %gopath%\bin\gocron\gocron.exe web -p 5920 -e prod  # 默认端口5920
> nssm install GocronNode %gopath%\bin\gocron\gocron-node.exe             # 默认端口5921

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
  $ service sshd start,stop # 启动sshd,WSL> /etc/init.d/ssh {start|stop|reload|force-reload|restart|try-restart|status}
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
    > sudo service ssh restart    # 重启ssh, <WSL> /etc/init.d/ssh restart
  # 宿主机通过ssh访问虚拟机 (免密设置:虚拟机默认不允许root用户通过ssh远程访问)
    # 分别在每台虚拟机上修改/etc/ssh/sshd_config 参考上面
    # 宿主机生成秘钥对后,将公钥传输给虚拟机,需要输入root密码
    > ssh-keygen > ssh-copy-id root@192.*.*.*   # 在虚拟上安装docker时会使用
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

> `supervisor`[守护进程工具](http://supervisord.org)
~~~shell
  $ sudo apt-get -y autoremove python-setuptools # 卸载
  $ sudo apt-get -y install python-setuptools    # 重装
  $ cd ~/.local/bin/ && su root                  # 切换目录及账号
  $ ./easy_install supervisor                    # 安装supervisor (以root身份)
  $ mkdir -p /etc/supervisor/conf.d && cd /etc/supervisor
  $ echo_supervisord_conf > supervisord.conf
#-config>>  /etc/supervisor/supervisord.conf     # 配置 
;conf.d 守护应用程序的配置文件夹，需要手动创建
[include]
files = conf.d/*.conf
#-为你的程序创建一个.conf文件，放在目录"/etc/supervisor/conf.d/"下
[program:MGToastServer]                       ; 程序名称-终端-控制台的标识<application-name>
user=root                                     ; 执行用户身份
autorestart=true                              ; 程序意外退出-是否自动重启
command=dotnet MGToastServer.dll              ; 运行程序的完整命令
directory=/root/app/toastServer/              ; 程序执行的工作目录
environment=ASPNETCORE_ENVIRONMENT=Production ; 程序运行的环境变量
stderr_logfile=/var/log/MGToastServer.err.log ; 错误日志文件
stdout_logfile=/var/log/MGToastServer.out.log ; 输出日志文件
stopsignal=INT                                ; 结束进程信号`Ctrl+C`
  $ supervisord -c /etc/supervisor/supervisord.conf # 运行supervisor
  $ ps -ef | grep MGToastServer                     # 检查你的程序的进程
  $ supervisorctl reload                            # 重启supervisor (修改配置后)
#-config>>  /usr/lib/systemd/system/supervisord.service # 配置supervisor开机启动 (参考其它*.service)
*** ***
ExecStart=/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
ExecStop=/usr/bin/supervisorctl shutdown
ExecReload=/usr/bin/supervisorctl reload
*** ***
  $ systemctl enable supervisord && systemctl is-enabled supervisord # 查看系统服务状态
  $ supervisorctl restart|stop|start <application-name>  # 重启|停止|启动指定应用
  $ supervisorctl restart|stop|start all     # 重启|停止|启动所有应用
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

> `Ansible` [配置管理和IT自动化工具-(系统运维)一个强大的配置管理解决方案(由Python编写)](https://www.jianshu.com/c/67d13df667ba)
~~~shell
  $ sudo apt update  # < ubuntu >
  $ sudo apt install software-properties-common
  $ sudo apt-add-repository --yes --update ppa:ansible/ansible
  $ sudo apt install ansible
~~~

> `Airflow` [任务调度(由Python编写)](https://www.jianshu.com/p/9bed1e3ab93b)
~~~shell
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


## Linux常用命令

    Shell连接符：
      && <中间> 连接两条命令并按顺序执行;
      &  <结尾> 使命令程序脱离终端进程在后台执行;

#### 最常用的工具：find、grep、xargs、sort、uniq、tr、wc、sed、awk、head、tail...
~~~bash
# 文件搜索ls&find----------------------------------------------------------
ls -lhR . | grep -i .key$  # 递归查找文件[后缀名为 .key ; 文件名称排序] --time={atime,ctime} 访问时间,权限属性
ls -lhRt . |grep -i .key$  # 递归查找文件[后缀名为 .key ; 文件时间排序] --full-time 输出完整时间ms默认为变更时间
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
find . -type f -user root -exec chown weber {} \; # 将目录下的所有权变更为用户weber [-exec执行动作{}相应文件名]
find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD \; # 将找到的文件全都copy到另一个目录OLD
find . -type f -name "*.json" -exec ./commands.sh {} \; # 将找到的文件全都调用可执行脚本

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
# 按列切分文本cut 按列拼接文本paste
# 统计行和字符wc---------------------------------------------------------------
find . -type f -name "*.java" -print0 |xargs -0 wc -l # 统计代码行数, wc -w file单词数, wc -c file字符数
# 文本替换利器sed--------------------------------------------------------------
echo 'ABC' | sed 's/[[:upper:]]*/\L&/' # 大写转小写 echo 'ABC' | tr A-Z a-z
PATH=`echo $PATH |sed 's#/mnt/d#/mnt/x#g'` # 批量替换-环境变量PATH-> sed 's#原始值#替换值#g'
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
tail -f /var/log/auth.log # 跟踪后10行 tail -10f /var/log/auth.log
less +F /var/log/syslog  # 跟踪文件新增内容 类似tail
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
busybox: 并行执行多条指令；合并多条命令为一条进行执行。
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
sysctl：运行时修改内核参数；加载并应用所有设置的系统内核参数：sysctl -f --system
$ grep -rin vm /etc/sysctl*         # 查找所有vm-内存使用限制
$ cat /proc/sys/vm/max_map_count    # 查看用户进程-最大内存限制(默认 65530
$ sysctl -w vm.max_map_count=262144 # 修改用户进程-最大内存限制(可以改成 655360
$ limit                             # 显示系统底层对shell资源的访问限制
$ ulimit -a                         # 显示系统用户对shell资源的访问限制
$ ulimit -u 7823 && ulimit -n 65536 # 修改访问限制
$ grep -rin hard /etc/security/limits* # 查找所有hard-硬件使用限制
$ grep -rin soft /etc/security/limits* # 查找所有soft-软件使用限制
$ vi /etc/security/limits.conf >    # 修改安全限制：ulimit -a
# nofile:可打开的最大文件数; nproc:进程数限制-即Linux线程数(LWP)
*   hard    nofile      131072
*   soft    nofile      65536
*   hard    nproc       7820
*   soft    nproc       3910
$ vi /etc/security/limits.d/90-nproc.conf > ulimit -u
*   soft    nproc       7820

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

----

#### Linux常见命令图解
![](https://github.com/angenalZZZ/doc/blob/master/screenshots/fwunixref.jpg)
![](https://github.com/angenalZZZ/doc/blob/master/screenshots/db53464b7746.png)
![](https://github.com/angenalZZZ/doc/blob/master/screenshots/gnulinuxfiles.webp)

----

