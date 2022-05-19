# 进程守护

- [Systemd](https://systemd.io/)、[Supervisor](http://supervisord.org/)

#### Systemd

~~~bash
vim /usr/lib/systemd/system/cloudreve.service # 创建应用配置文件
~~~
```
[Unit]
Description=Cloudreve
Documentation=https://docs.cloudreve.org
After=network.target
Wants=network.target

[Service]
WorkingDirectory=/PATH_TO_CLOUDREVE
ExecStart=/PATH_TO_CLOUDREVE/cloudreve
Restart=on-abnormal
RestartSec=5s
KillMode=mixed

StandardOutput=null
StandardError=syslog

[Install]
WantedBy=multi-user.target
```
~~~bash
systemctl daemon-reload    # 更新配置
systemctl start cloudreve  # 启动应用
systemctl enable cloudreve # 设置开机启动
~~~

#### Supervisor
> 安装 supervisor
~~~bash
# yum install supervisor # 默认安装方式
sudo yum install python-setuptools
sudo easy_install supervisor
supervisord --version

# 初始化全局配置文件(可选)
sudo ls /etc/supervisord.conf
sudo touch /etc/supervisord.conf
sudo echo_supervisord_conf > /etc/supervisord.conf
~~~
> 编辑全局配置文件(可选)
~~~bash
sudo vim /etc/supervisord.conf
~~~
> 加入新的配置目录(可选)
```
# 应用默认配置文件 /etc/supervisord.d/*.ini
[include]
files = /etc/supervisor/conf/*.ini
```
> 创建 Cloudreve 应用配置所在目录，并创建配置文件
~~~bash
sudo mkdir -p /etc/supervisor/conf
sudo vim /etc/supervisor/conf/cloudreve.ini # 新增程序配置
# vim /etc/supervisord.d/cloudreve.ini # 放到默认配置目录中
~~~
```
[program:cloudreve]
environment=CODENATION_ENV=prod
directory=/home/cloudreve
command=/home/cloudreve/cloudreve
autostart=true
autorestart=true
stderr_logfile=/var/log/cloudreve.err
stdout_logfile=/var/log/cloudreve.log
```
~~~bash
# vim /etc/supervisord.d/WebApi.ini    # 新增程序配置 WebApi 放到默认配置目录中
~~~
```
[program:WebApi]
user=centos
environment=ASPNETCORE_ENVIRONMENT=Development,ASPNETCORE_URLS=http://localhost:35000
directory=/home/centos/App/WebApi/
command=dotnet WebApi.dll
stopsignal=INT
autostart=true
autorestart=true
startsecs=1
loglevel=warn
logfile_maxbytes=2097152
stdout_logfile_maxbytes=2097152
stderr_logfile_maxbytes=2097152
stderr_logfile=/home/centos/App/WebApi/logs/stderr.supervisor.log
stdout_logfile=/home/centos/App/WebApi/logs/stdout.supervisor.log
```
> 启动 supervisor (通过全局配置文件)
~~~bash
supervisord -c /etc/supervisord.conf   # 按全局配置[启动服务]supervisord
# 当新增或修改应用配置文件 /etc/supervisord.d/*.ini 后 reload [重新加载全局配置]
supervisorctl -c /etc/supervisord.conf # 指定全局配置文件[进入supervisor命令控制台]
supervisor> reload
supervisor> status [start,stop,restart] [程序名称,如WebApi]
supervisor> exit
~~~
> 管理 supervisor 应用程序
~~~bash
supervisorctl status            # 查看应用列表及状态
supervisorctl status cloudreve  # 查看某个程序的状态
supervisorctl start cloudreve   # 启动程序
supervisorctl stop cloudreve    # 停止程序
supervisorctl restart cloudreve # 重启程序
~~~

----
