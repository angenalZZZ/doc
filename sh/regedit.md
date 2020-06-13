# Windows注册表

#### 管理服务

> Windows Update 禁用
~~~
REG add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v Start /t REG_DWORD /d 4 /f
REG add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v Start /t REG_DWORD /d 4 /f
~~~
> Windows Update Medic Service 禁用 WaaSMedicSvc
~~~cmd
REG add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f
~~~

