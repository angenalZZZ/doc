# Windows注册表

#### 管理服务

> Windows Update 禁用
~~~cmd
# Windows Update 服务名 wuauserv & UsoSvc
REG add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v Start /t REG_DWORD /d 4 /f
REG add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v Start /t REG_DWORD /d 4 /f
# Windows Update Medic Service 服务名 WaaSMedicSvc
REG add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f
~~~

