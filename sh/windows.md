# Windows系统


#### 系统升级

> Windows 10 最新版激活方式，免费升级到20H2 [Download MediaCreationTool20H2](https://go.microsoft.com/fwlink/?LinkId=691209)
~~~bash
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX  # 专业版 or 企业版: 96YNV-9X4RP-2YYKB-RMQH4-6Q72D
slmgr /skms kms.03k.org                   # 修改kms源
slmgr /ato                                # 执行激活
slmgr /upk                                # 卸载密钥(当无法激活时) www.win7zhijia.cn/win10jc
~~~
> Windows 10 Microsoft Store
~~~bash
# PowerShell 以管理员方式运行
Get-AppxPackage *store* | Remove-AppxPackage # 删除原来的 Microsoft Store
Get-AppxPackage -AllUsers | Select Name, PackageFullName | Select-String "WindowsStore" # 查询并复制<包名>
Add-AppxPackage -Register "C:\Program Files\WindowsApps\<包全名>\AppxManifest.xml" -DisableDevelopmentMode #安装
~~~
> Windows 10 WSL & Chocolatey & Centos
~~~bash
# PowerShell 以管理员方式运行, 打开 WSL 程序和功能
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# 安装 Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# 安装 LxRunOffline for run centos7
choco install lxrunoffline
# 部署 centos7 到 WSL (下载Docker镜像) https://github.com/RoliSoft/WSL-Distribution-Switcher
LxRunOffline install -n centos7 -d A:\centos7 -f A:\centos7\centos-7-docker.tar.xz
# 开启 centos7
LxRunOffline run -n centos7
# 设置 WSL 默认版本为 2
wsl --set-default-version 2 # Update to WSL 2
wsl -l -v                   # 查看<linux>是否为 WSL 2
wsl --set-version <linux> 2 # 修改<linux>为 WSL 2
# 设置root用户的密码
sudo passwd root
# 安装K8s集成到Ubuntu 参考 https://blog.csdn.net/weixin_43168190/article/details/107179715
~~~
> Windows 10 [WSL - Ubuntu 20.04](https://docs.microsoft.com/en-au/windows/wsl/install-manual)、[Update to WSL 2](https://docs.microsoft.com/en-au/windows/wsl/install-win10#step-2---update-to-wsl-2)、[Ubuntu开发环境及常用安装](https://github.com/angenalZZZ/doc/blob/master/cmd_bash_shell.md#linux开发环境及常用安装)
~~~bash
# PowerShell 以管理员方式运行, 安装 WSL - Ubuntu 20.04
Get-AppxPackage -AllUsers | Select Name, PackageFullName | Select-String "Ubuntu" # 查询并复制<包名>
Get-AppxPackage CanonicalGroupLimited.UbuntuonWindows | Remove-AppxPackage # 卸载
curl.exe -L -o ubuntu-2004.appx https://aka.ms/wslubuntu2004 # 下载
Add-AppxPackage .\ubuntu-2004.appx # 安装 WSL - Ubuntu 20.04
# 进入 Ubuntu 为root账户设置密码
$ sudo passwd
# 更新软件源
$ sudo vi /etc/apt/sources.list    # ubuntu`20.04``focal` 阿里云源 (按 :wq! 保存)
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
$ sudo apt-get update && sudo apt-get upgrade # 更新软件源-操作完毕!
# Python 安装配置 python3为默认终端
sudo apt-get install python-pip    # 安装python2和pip
sudo apt-get install python3-pip   # 安装适用于python3的pip
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150
pip3 install ipython
# MySQL 安装配置
sudo apt-get install mysql-server
sudo apt-get isntall mysql-client
sudo apt-get install libmysqlclient-dev
sudo pip3 install PyMySQL          # 使用python操作MySQL
mysql>                             # 连接mysql
set password =password('密码');
flush privileges;                  # 刷新系统权限表, 或重启mysql服务 service MySQL restart
mysql -uroot -p                    # 输入密码(-p)
~~~
> Windows 后台服务管理工具
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

> 系统环境变量

- 用户变量/Path
```
%USERPROFILE%\AppData\Local\Microsoft\WindowsApps
C:\Users\Administrator\AppData\Local\Programs\Microsoft VS Code\bin
C:\Users\Administrator\AppData\Local\Programs\Python\Python37-32
C:\Users\Administrator\AppData\Local\Programs\Python\Python37-32\Scripts
C:\Users\Administrator\.dotnet\tools
```

- 系统变量/Path
```
%SystemRoot%
%SystemRoot%\system32
%SystemRoot%\System32\Wbem
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\
%SYSTEMROOT%\System32\OpenSSH\
%android%
%ANT_HOME%\bin
%JAVA_HOME%\bin
%JMETER_HOME%\bin
C:\Program Files (x86)\Common Files\Oracle\Java\javapath
C:\Program Files (x86)\Graphviz2.38\bin
C:\Program Files\dotnet\
C:\Program Files\Git\cmd
C:\Program Files\Docker\Docker\resources\bin
C:\ProgramData\DockerDesktop\version-bin
D:\Tool\SysinternalsSuite\
A:\go\bin
D:\Program\Go\bin
D:\Program\mingw64\bin\
D:\Program\CMake\bin
D:\Program\D-Bus\bin
D:\Program\erl10.5\bin
D:\Program\Lua\5.1
D:\Program\Lua\5.1\clibs
D:\Program\nng\bin
D:\Program\nanomsg\bin
D:\Program\nodejs\
D:\Program\nodejs\node_global
D:\Program\R\R-3.6.1\bin\
D:\Program\v\.bin
D:\Program\zstd\
D:\Program\rocksdb\
D:\Program\Redis
D:\Program Files (x86)\NetSarang\Xshell 7\
D:\Program Files (x86)\NetSarang\Xftp 7\
```

- 系统变量
```
_JAVA_OPTIONS -Xms512m -Xmx512m
android       F:\Program\Android\sdk\platform-tools
ANT_HOME      F:\Program\Android\apache-ant-1.10.5
CLASSPATH     .;%JAVA_HOME%\lib;
DOCKER_HOST   tcp://localhost:2375
ERLANG_HOME   D:\Program\erl10.5
GO111MODULE   auto
GOPATH        A:\go
GOPROXY       https://goproxy.io
Include       .;%JAVA_HOME%\lib;
JAVA_BIN      %JAVA_HOME%/bin
JRE_HOME      %JAVA_HOME%/jre
JAVA_HOME     C:\Program Files (x86)\Java\jdk1.8.0_211
JMETER_HOME   D:\Program\JMeter
KUBECONFIG    C:\Users\Administrator\.kube\config
LUA_DEV       D:\Program\Lua\5.1
LUA_PATH      ;;D:\Program\Lua\5.1\lua\?.luac
NN_STATIC_LIB   D:\Program\nanomsg\lib
NODE_PATH       D:\Program\nodejs\node_global\node_modules
PKG_CONFIG_PATH D:\Program\mingw64\lib\pkgconfig
SOLR_INSTALL  A:\database\solr
ZONEINFO      A:\go\bin\zoneinfo.zip
```

----


