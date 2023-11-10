# Windows系统环境变量


- 用户变量/Path
```
# $HOME = %USERPROFILE% = C:\Users\Administrator
%USERPROFILE%\AppData\Local\Microsoft\WindowsApps
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
D:\Program\Python\Python39-32\
D:\Program\Python\Python39-32\Scripts\
D:\Program\msys64\mingw64\bin
D:\Program\MongoDB\mongosh\
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
A:\deno\bin
A:\go\bin
A:\rust\bin
A:\rust\.cargo\bin
C:\tools\lxrunoffline
C:\Program Files\Git\cmd
C:\ProgramData\chocolatey\bin
D:\Tool\Decompile\Dotfuscator\
D:\Tool\SysinternalsSuite\platform-tools
D:\Tool\SysinternalsSuite
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
C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common
C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.6\bin
C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.6\libnvvp
C:\Program Files\NVIDIA Corporation\Nsight Compute 2022.1.0\
C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR
C:\Program Files\dotnet\
```

- 系统变量
```
android       D:\Program\Android\sdk\platform-tools
ANT_HOME      D:\Program\Android\apache-ant-1.10.5

CARGO_HOME    A:\rust\.cargo   # 在运行Rust安装`rustup-init`之前设置CARGO_HOME
RUSTUP_HOME   A:\rust\.rustup  # 同上,设置RUSTUP_HOME

ChocolateyInstall C:\ProgramData\chocolatey
ChocolateyToolsLocation C:\tools

CATALINA_HOME D:\Program\apache-tomcat-8.5.65

CUDA_PATH			C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.6
CUDA_PATH_V11_6 C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.6
NVTOOLSEXT_PATH C:\Program Files\NVIDIA Corporation\NvToolsExt\

DENO_DIR          A:\deno
DENO_INSTALL_ROOT A:\deno\bin

DOCKER_HOST   tcp://localhost:2375

DOTFUSCATOR_HOME D:\Tool\Decompile\Dotfuscator\
DOTNET_REACTOR D:\Tool\Decompile\Reactor\

ERLANG_HOME   D:\Program\erl10.5

GO111MODULE   auto
GOCACHE       D:\Users\Administrator\AppData\Local\go-build
GOENV         A:\go\env
GOPATH        A:\go
GOPROXY       https://goproxy.io,direct
GOROOT        D:\Program\Go
GOTOOLS       %GOROOT%/pkg/tool

IPFS_PATH     A:\database\ipfs\.ipfs

CLASSPATH     .;%JAVA_HOME%\lib\dt.jar:%JAVA_HOME%\lib\tools.jar;%CATALINA_HOME%\lib\servlet-api.jar;
Include       .;%JAVA_HOME%\lib;
JAVA_BIN      %JAVA_HOME%\bin
JAVA_HOME     C:\Program Files\Java\jdk-11.0.16.1         #// Java系统开发环境
JAVA_OPTS     -Xms512m -Xmx1024m -XX:PermSize=256M -Dfile.encoding=utf-8  #// _JAVA_OPTIONS -Xms512m -Xmx512m
JRE_HOME      %JAVA_HOME%\jre

M2_HOME       D:\Program\apache-maven-3.8.1
MAVEN_HOME    D:\Program\apache-maven-3.8.1

JMETER_HOME   D:\Program\JMeter

KUBECONFIG    C:\Users\Administrator\.kube\config

LUA_DEV       D:\Program\Lua\5.1
LUA_PATH      ;;D:\Program\Lua\5.1\lua\?.luac

NN_STATIC_LIB   D:\Program\nanomsg\lib

NODE_PATH       D:\Program\nodejs\node_global\node_modules #// nodejs系统开发环境

PKG_CONFIG_PATH D:\Program\msys64\mingw64\lib\pkgconfig    #// mingw系统linux开发环境

VBOX_MSI_INSTALL_PATH D:\Program Files\Oracle\VirtualBox\

TNS_ADMIN     C:\Windows\System32\OraHomeX64\network\admin #// Oracle客户端连接别名
NLS_LANG      AMERICAN_AMERICA.US7ASCII                    #// Oracle客户端字符编码

SOLR_INSTALL  D:\Program\solr

ZONEINFO      A:\go\bin\zoneinfo.zip
```

- [专用dns服务器工具`Acrylic`与`sni`反向代理服务解锁网络](https://bulianglin.com/archives/netflix4.html)
  * [获取`sni`反向代理服务](https://fofa.info/result?qbase64=Ym9keT0iQmFja2VuZCBub3QgYXZhaWxhYmxlIg%3D%3D)
  * [获取`Acrylic`本地DNS代理服务](https://sourceforge.net/projects/acrylic/files/Acrylic/2.1.1/Acrylic.exe/download)
  * Acrylic hosts
```
6.6.6.6   /^(.+\.)*akadns\.net$
6.6.6.6   /^(.+\.)*akam\.net$
6.6.6.6   /^(.+\.)*akamai\.com$
6.6.6.6   /^(.+\.)*akamai\.net$
6.6.6.6   /^(.+\.)*akamaiedge\.net$
6.6.6.6   /^(.+\.)*akamaihd\.net$
6.6.6.6   /^(.+\.)*akamaistream\.net$
6.6.6.6   /^(.+\.)*akamaitech\.net$
6.6.6.6   /^(.+\.)*akamaitechnologies\.com$
6.6.6.6   /^(.+\.)*akamaitechnologies\.fr$
6.6.6.6   /^(.+\.)*akamaized\.net$
6.6.6.6   /^(.+\.)*edgekey\.net$
6.6.6.6   /^(.+\.)*edgesuite\.net$
6.6.6.6   /^(.+\.)*srip\.net$
6.6.6.6   /^(.+\.)*footprint\.net$
6.6.6.6   /^(.+\.)*level3\.net$
6.6.6.6   /^(.+\.)*llnwd\.net$
6.6.6.6   /^(.+\.)*edgecastcdn\.net$
6.6.6.6   /^(.+\.)*cloudfront\.net$
6.6.6.6   /^(.+\.)*netflix\.com$
6.6.6.6   /^(.+\.)*netflix\.net$
6.6.6.6   /^(.+\.)*nflximg\.com$
6.6.6.6   /^(.+\.)*nflximg\.net$
6.6.6.6   /^(.+\.)*nflxvideo\.net$
6.6.6.6   /^(.+\.)*nflxso\.net$
6.6.6.6   /^(.+\.)*nflxext\.com$
6.6.6.6   /^(.+\.)*hulu\.com$
6.6.6.6   /^(.+\.)*huluim\.com$
6.6.6.6   /^(.+\.)*hbonow\.com$
6.6.6.6   /^(.+\.)*hbogo\.com$
6.6.6.6   /^(.+\.)*hbo\.com$
6.6.6.6   /^(.+\.)*amazon\.com$
6.6.6.6   /^(.+\.)*amazon\.co\.uk$
6.6.6.6   /^(.+\.)*amazonvideo\.com$
6.6.6.6   /^(.+\.)*crackle\.com$
6.6.6.6   /^(.+\.)*pandora\.com$
6.6.6.6   /^(.+\.)*vudu\.com$
6.6.6.6   /^(.+\.)*blinkbox\.com$
6.6.6.6   /^(.+\.)*abc\.com$
6.6.6.6   /^(.+\.)*fox\.com$
6.6.6.6   /^(.+\.)*theplatform\.com$
6.6.6.6   /^(.+\.)*nbc\.com$
6.6.6.6   /^(.+\.)*nbcuni\.com$
6.6.6.6   /^(.+\.)*ip2location\.com$
6.6.6.6   /^(.+\.)*pbs\.org$
6.6.6.6   /^(.+\.)*warnerbros\.com$
6.6.6.6   /^(.+\.)*southpark\.cc\.com$
6.6.6.6   /^(.+\.)*cbs\.com$
6.6.6.6   /^(.+\.)*brightcove\.com$
6.6.6.6   /^(.+\.)*cwtv\.com$
6.6.6.6   /^(.+\.)*spike\.com$
6.6.6.6   /^(.+\.)*go\.com$
6.6.6.6   /^(.+\.)*mtv\.com$
6.6.6.6   /^(.+\.)*mtvnservices\.com$
6.6.6.6   /^(.+\.)*playstation\.net$
6.6.6.6   /^(.+\.)*uplynk\.com$
6.6.6.6   /^(.+\.)*maxmind\.com$
6.6.6.6   /^(.+\.)*disney\.com$
6.6.6.6   /^(.+\.)*disneyjunior\.com$
6.6.6.6   /^(.+\.)*adobedtm\.com$
6.6.6.6   /^(.+\.)*bam\.nr-data\.net$
6.6.6.6   /^(.+\.)*bamgrid\.com$
6.6.6.6   /^(.+\.)*braze\.com$
6.6.6.6   /^(.+\.)*cdn\.optimizely\.com$
6.6.6.6   /^(.+\.)*cdn\.registerdisney\.go\.com$
6.6.6.6   /^(.+\.)*cws\.conviva\.com$
6.6.6.6   /^(.+\.)*d9\.flashtalking\.com$
6.6.6.6   /^(.+\.)*disney-plus\.net$
6.6.6.6   /^(.+\.)*disney-portal\.my\.onetrust\.com$
6.6.6.6   /^(.+\.)*disney\.demdex\.net$
6.6.6.6   /^(.+\.)*disney\.my\.sentry\.io$
6.6.6.6   /^(.+\.)*disneyplus\.bn5x\.net$
6.6.6.6   /^(.+\.)*disneyplus\.com$
6.6.6.6   /^(.+\.)*disneyplus\.com\.ssl\.sc\.omtrdc\.net$
6.6.6.6   /^(.+\.)*disneystreaming\.com$
6.6.6.6   /^(.+\.)*dssott\.com$
6.6.6.6   /^(.+\.)*execute-api\.us-east-1\.amazonaws\.com$
6.6.6.6   /^(.+\.)*js-agent\.newrelic\.com$
6.6.6.6   /^(.+\.)*xboxlive\.com$
6.6.6.6   /^(.+\.)*lovefilm\.com$
6.6.6.6   /^(.+\.)*turner\.com$
6.6.6.6   /^(.+\.)*amctv\.com$
6.6.6.6   /^(.+\.)*sho\.com$
6.6.6.6   /^(.+\.)*mog\.com$
6.6.6.6   /^(.+\.)*wdtvlive\.com$
6.6.6.6   /^(.+\.)*beinsportsconnect\.tv$
6.6.6.6   /^(.+\.)*beinsportsconnect\.net$
6.6.6.6   /^(.+\.)*fig\.bbc\.co\.uk$
6.6.6.6   /^(.+\.)*open\.live\.bbc\.co\.uk$
6.6.6.6   /^(.+\.)*sa\.bbc\.co\.uk$
6.6.6.6   /^(.+\.)*www\.bbc\.co\.uk$
6.6.6.6   /^(.+\.)*crunchyroll\.com$
6.6.6.6   /^(.+\.)*ifconfig\.co$
6.6.6.6   /^(.+\.)*omtrdc\.net$
6.6.6.6   /^(.+\.)*sling\.com$
6.6.6.6   /^(.+\.)*movetv\.com$
6.6.6.6   /^(.+\.)*happyon\.jp$
6.6.6.6   /^(.+\.)*abema\.tv$
6.6.6.6   /^(.+\.)*hulu\.jp$
6.6.6.6   /^(.+\.)*optus\.com\.au$
6.6.6.6   /^(.+\.)*optusnet\.com\.au$
6.6.6.6   /^(.+\.)*gamer\.com\.tw$
6.6.6.6   /^(.+\.)*bahamut\.com\.tw$
6.6.6.6   /^(.+\.)*hinet\.net$
6.6.6.6   /^(.+\.)*dmm\.com$
6.6.6.6   /^(.+\.)*dmm\.co\.jp$
6.6.6.6   /^(.+\.)*dmm-extension\.com$
6.6.6.6   /^(.+\.)*dmmapis\.com$
6.6.6.6   /^(.+\.)*api-p\.videomarket\.jp$
6.6.6.6   /^(.+\.)*saima\.zlzd\.xyz$
6.6.6.6   /^(.+\.)*challenges\.cloudflare\.com$
6.6.6.6   /^(.+\.)*ai\.com$
6.6.6.6   /^(.+\.)*openai\.com$
6.6.6.6   /^(.+\.)*fast\.com$
```
  * x-ui模板
```
{
"dns": {
    "hosts": {
      "geosite:netflix": "6.6.6.6",
      "geosite:disney": "6.6.6.6"
    },
     "servers": [
      "8.8.8.8",
      "1.1.1.1"
    ]
  },
  "api": {
    "services": [
      "HandlerService",
      "LoggerService",
      "StatsService"
    ],
    "tag": "api"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 62789,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {"domainStrategy": "UseIP"}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "policy": {
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    }
  },
  "routing": {
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "blocked",
        "type": "field"
      },
      {
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ],
        "type": "field"
      }
    ]
  },
  "stats": {}
}
```


----

