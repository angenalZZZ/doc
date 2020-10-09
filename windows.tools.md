# Windows 工具集

#### [win10激活密钥](http://www.win7zhijia.cn/win10jc/win10_29118.html)
~~~bash
cd cd %windir%/system32
slmgr -upk                                 # 卸载密钥
slmgr -ipk NPPR9-FWDCX-D2C8J-H872K-2YT43   # 安装密钥(win10企业版)
slmgr -skms kms.03k.org                    # 修改kms源
slmgr -ato                                 # 执行激活
~~~

