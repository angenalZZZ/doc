# Windows系统


#### 系统升级

> Windows 10 最新版激活方式，免费升级到20H2
~~~
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms.03k.org
slmgr /ato
~~~


#### 注册表

> 系统服务管理

- Windows Update 禁用::服务名 wuauserv & WaaSMedicSvc & UsoSvc
~~~cmd
REG add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v Start /t REG_DWORD /d 4 /f
REG add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f
REG add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v Start /t REG_DWORD /d 4 /f
~~~

