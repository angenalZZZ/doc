# Windows系统


#### 系统升级

> Windows 10 最新版激活方式，免费升级到20H2 [Download MediaCreationTool20H2](https://go.microsoft.com/fwlink/?LinkId=691209)
~~~bash
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX  # 专业版 or 企业版: 96YNV-9X4RP-2YYKB-RMQH4-6Q72D
slmgr /skms kms.03k.org
slmgr /ato
~~~
> Windows 10 重装 Microsoft Store
~~~bash
# PowerShell 以管理员方式运行
Get-AppxPackage *store* | Remove-AppxPackage # 删除原来的 Microsoft Store
Get-AppxPackage -AllUsers | Select Name, PackageFullName | Select-String "WindowsStore" # 查询并复制<包全名>
Add-AppxPackage -Register "C:\Program Files\WindowsApps\<包全名>\AppxManifest.xml" -DisableDevelopmentMode #安装
~~~
> Windows 10 系统问题排查
~~~bash
sfc /SCANNOW                                    # 检查系统组件是否有问题？
DISM.exe /Online /Cleanup-image /Scanhealth     # 扫描系统组件问题
DISM.exe /Online /Cleanup-image /Checkhealth    # 检查系统组件问题
DISM.exe /Online /Cleanup-image /Restorehealth  # 恢复系统组件
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
C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps
C:\Users\Administrator\AppData\Local\Programs\Microsoft VS Code\bin
C:\Users\Administrator\AppData\Local\Programs\Python\Python37-32
C:\Users\Administrator\AppData\Local\Programs\Python\Python37-32\Scripts
C:\Users\Administrator\.dotnet\tools
D:\Program\nodejs\node_global
A:\Go\bin
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
C:\Program Files (x86)\Lua\5.1
C:\Program Files (x86)\Lua\5.1\clibs
C:\Program Files\dotnet\
C:\Program Files\R\R-3.6.1\bin\
C:\Program Files\Git\cmd
C:\Program Files\Docker\Docker\resources\bin
C:\ProgramData\DockerDesktop\version-bin
D:\Program Files\erl10.5\bin
D:\Tool\SysinternalsSuite\
D:\Program\mingw64\bin\
D:\Program\CMake\bin
D:\Program\D-Bus\bin
D:\Program\Go\bin
D:\Program\nng\bin
D:\Program\nanomsg\bin
D:\Program\nodejs\
D:\Program\v\.bin
D:\Program\Redis
D:\Program\zstd\
D:\Program\rocksdb\
```

- 系统变量
```
_JAVA_OPTIONS -Xms512m -Xmx512m
android       F:\Program\Android\sdk\platform-tools
ANT_HOME      F:\Program\Android\apache-ant-1.10.5
CLASSPATH     .;%JAVA_HOME%\lib;
DOCKER_HOST   tcp://localhost:2375
ERLANG_HOME   D:\Program Files\erl10.5
GO111MODULE   auto
Include       .;%JAVA_HOME%\lib;
JAVA_HOME     C:\Program Files (x86)\Java\jdk1.8.0_211
JMETER_HOME   D:\Program\JMeter
KUBECONFIG    C:\Users\Administrator\.kube\config
LUA_DEV       C:\Program Files (x86)\Lua\5.1
LUA_PATH      ;;C:\Program Files (x86)\Lua\5.1\lua\?.luac
NN_STATIC_LIB   D:\Program\nanomsg\lib
NODE_PATH       D:\Program\nodejs\node_global\node_modules
PKG_CONFIG_PATH D:\Program\mingw64\lib\pkgconfig
SOLR_INSTALL  A:\database\solr
ZONEINFO      A:\go\bin\zoneinfo.zip
```

----


