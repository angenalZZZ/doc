# 进程守护

#### Systemd

~~~bash
# 编辑配置文件
vim /usr/lib/systemd/system/cloudreve.service
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
systemctl start cloudreve  # 启动服务
systemctl enable cloudreve # 设置开机启动
~~~

#### Supervisor
~~~bash
# 安装 supervisor
sudo yum install python-setuptools
sudo easy_install supervisor

# 初始化全局配置文件
sudo touch /etc/supervisord.conf
sudo echo_supervisord_conf > /etc/supervisord.conf
~~~
> 编辑全局配置文件
~~~bash
sudo vim /etc/supervisord.conf
~~~
> 加入新的配置
```
[include]
files = /etc/supervisor/conf/*.conf
```
> 创建 Cloudreve 应用配置所在文件目录，并创建打开配置文件
~~~bash
sudo mkdir -p /etc/supervisor/conf
sudo vim /etc/supervisor/conf/cloudreve.conf
~~~
```
[program:cloudreve]
directory=/home/cloudreve
command=/home/cloudreve/cloudreve
autostart=true
autorestart=true
stderr_logfile=/var/log/cloudreve.err
stdout_logfile=/var/log/cloudreve.log
environment=CODENATION_ENV=prod
```
> 通过全局配置文件启动supervisor
~~~bash
supervisord -c /etc/supervisord.conf
~~~
> 管理进程 
~~~bash
sudo supervisorctl start cloudreve   # 启动
sudo supervisorctl stop cloudreve    # 停止
sudo supervisorctl status cloudreve  # 查看状态
~~~

