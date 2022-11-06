# Windows系统环境变量


- 用户变量/Path
```
# $HOME = %USERPROFILE% = C:\Users\Administrator
%USERPROFILE%\AppData\Local\Microsoft\WindowsApps
%USERPROFILE%\AppData\Local\Programs\Python\Python37-32
%USERPROFILE%\AppData\Local\Programs\Python\Python37-32\Scripts
%USERPROFILE%\scoop\shims
%USERPROFILE%\.dotnet\tools
```

- 系统变量/Path
```
C:\Windows
C:\Windows\system32
C:\Windows\System32\wbem
C:\Windows\System32\OpenSSH\
C:\Windows\System32\WindowsPowerShell\v1.0\
C:\Program Files\Common Files\Oracle\Java\javapath
D:\Program\CMake\bin
D:\Program\D-Bus\bin
D:\Program\Go\bin
D:\Program\erl10.5\bin
D:\Program\Lua\5.1
D:\Program\Lua\5.1\clibs
D:\Program\nng\bin
D:\Program\nanomsg\bin
D:\Program\NSIS\bin
D:\Program\nodejs
D:\Program\nodejs\node_global
D:\Program\msys64\mingw64\bin
D:\Program\MongoDB\mongosh\
D:\Program\Python\Python39-32\Scripts\
D:\Program\Python\Python39-32\
D:\Program\R\R-3.6.1\bin
D:\Program\Redis
D:\Program\v\.bin
D:\Program\zstd
D:\Program\rocksdb
D:\Program\JMeter\bin
D:\Program\swigwin-3.0.12
D:\Program\apache-maven-3.8.1\bin
D:\Program\Strawberry\c\bin
D:\Program\Strawberry\perl\bin
D:\Program\Strawberry\perl\site\bin
D:\Program\Android\apache-ant-1.10.5\bin
D:\Program\Android\sdk\platform-tools
D:\Tool\Decompile\Dotfuscator\
D:\Tool\SysinternalsSuite\platform-tools
D:\Tool\SysinternalsSuite
A:\deno\bin
A:\go\bin
A:\rust\bin
A:\rust\.cargo\bin
C:\tools\lxrunoffline
C:\Program Files\Git\cmd
C:\ProgramData\chocolatey\bin
C:\Windows\System32\OraHomeX64
C:\Windows\System32\OraHomeX64\bin
C:\Program Files\Microsoft VS Code\bin
C:\Program Files\Microsoft\Web Platform Installer
C:\Program Files\Microsoft SQL Server\130\Tools\Binn\
C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\
C:\Program Files\Microsoft SQL Server\150\Tools\Binn\
C:\Program Files\Microsoft SQL Server\150\DTS\Binn\
C:\Program Files (x86)\Microsoft SQL Server\150\DTS\Binn\
C:\Program Files (x86)\Microsoft SQL Server\150\Tools\Binn\
D:\Program Files\Devart\EntityDeveloper\Console
C:\Program Files\dotnet\
```

- 系统变量
```
android       D:\Program\Android\sdk\platform-tools
ANT_HOME      D:\Program\Android\apache-ant-1.10.5
ChocolateyInstall C:\ProgramData\chocolatey
ChocolateyToolsLocation C:\tools
CATALINA_HOME D:\Program\apache-tomcat-8.5.65
CLASSPATH     .;%JAVA_HOME%\lib\dt.jar:%JAVA_HOME%\lib\tools.jar;%CATALINA_HOME%\lib\servlet-api.jar;
CARGO_HOME    A:\rust\.cargo   # 在运行Rust安装`rustup-init`之前设置CARGO_HOME
RUSTUP_HOME   A:\rust\.rustup  # 同上,设置RUSTUP_HOME
DENO_DIR          A:\deno
DENO_INSTALL_ROOT A:\deno\bin
DOCKER_HOST   tcp://localhost:2375
DOTFUSCATOR_HOME D:\Tool\Decompile\Dotfuscator\
DOTNET_REACTOR D:\Program Files (x86)\Eziriz\.NET Reactor
ERLANG_HOME   D:\Program\erl10.5
GO111MODULE   auto
GOENV         A:\go\env
GOPATH        A:\go
GOROOT        D:\Program\Go
GOTOOLS       %GOROOT%/pkg/tool
GOPROXY       https://goproxy.io,direct
GOCACHE       D:\Users\Administrator\AppData\Local\go-build
IPFS_PATH     A:\database\ipfs\.ipfs
Include       .;%JAVA_HOME%\lib;
JAVA_BIN      %JAVA_HOME%\bin
JAVA_HOME     C:\Program Files\Java\jdk-11.0.16.1
JAVA_OPTS     -Xms512m -Xmx1024m -XX:PermSize=256M -Dfile.encoding=utf-8  #// _JAVA_OPTIONS -Xms512m -Xmx512m
JRE_HOME      %JAVA_HOME%\jre
M2_HOME       D:\Program\apache-maven-3.8.1
MAVEN_HOME    D:\Program\apache-maven-3.8.1
JMETER_HOME   D:\Program\JMeter
KUBECONFIG    C:\Users\Administrator\.kube\config
LUA_DEV       D:\Program\Lua\5.1
LUA_PATH      ;;D:\Program\Lua\5.1\lua\?.luac
NN_STATIC_LIB   D:\Program\nanomsg\lib
NODE_PATH       D:\Program\nodejs\node_global\node_modules
PKG_CONFIG_PATH D:\Program\msys64\mingw64\lib\pkgconfig
VBOX_MSI_INSTALL_PATH D:\Program Files\Oracle\VirtualBox\
TNS_ADMIN     C:\Windows\System32\OraHomeX64\network\admin #// Oracle客户端连接别名
NLS_LANG      AMERICAN_AMERICA.US7ASCII                    #// Oracle客户端字符编码
SOLR_INSTALL  D:\Program\solr
ZONEINFO      A:\go\bin\zoneinfo.zip
```

----

