# [Nginx](http://nginx.org/en/docs/)  [中文](http://www.nginx.cn/doc/)

* 安装
~~~
$ yum -y install nginx          # <CentOS>
$ sudo apt-get -y install nginx # <Ubuntu>
$ sudo ufw allow 'Nginx Full'   # 配置防火墙
$ sudo ufw status               # 验证更改
$ sudo systemctl enable nginx   # 设置开机启动
$ sudo systemctl status nginx   # 检查服务状态，Nginx 默认监听 80 端口(确保没被占用)
$ sudo systemctl restart nginx  # 重启服务
$ sudo systemctl reload nginx   # 修改配置后，需要重新加载服务
$ sudo systemctl disable nginx && sudo systemctl stop nginx #禁止开机启动，停止服务
$ ls /etc/nginx/sites-available # 设置Nginx服务器模块(类似Apache虚拟主机) www.linuxidc.com/Linux/2018-05/152258.htm
$ sudo apt install certbot      # 使用Let's Encrypt保护Nginx  www.linuxidc.com/Linux/2018-05/152259.htm
~~~
* 常用命令
~~~
which nginx         # 查找 Nginx 命令所在路径
nginx -s stop       # 快速关闭 Nginx，可能不保存相关信息，并迅速终止 Web 服务
nginx -s quit       # 平稳关闭 Nginx，保存相关信息，有安排的结束 Web 服务
nginx -s reload     # 因改变了 Nginx 相关配置，需要重新加载配置而重载
nginx -s reopen     # 重新打开日志文件
nginx -c filename   # 为 Nginx 指定一个配置文件，来代替默认的
nginx -t            # 不运行，而仅仅测试配置文件。Nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件
nginx -v            # 显示 Nginx 的版本
nginx -V            # 显示 Nginx 的版本、编译器版本和配置参数
~~~
* 检查与分析工具[gixy](https://github.com/yandex/gixy)
~~~
# 检查
cd /etc/nginx
nginx -t
# 分析
pip install gixy
gixy nginx.conf
~~~
* [配置参数说明](https://github.com/digitalocean/nginxconfig.io)与[✨在线编辑器](https://nginxconfig.io/)
~~~
# 进程用户
user nginx; # <linux>

# 进程数量(通常设置成与cpu数量相等) #auto: nginx -v > ^1.9.10
worker_processes auto;
worker_cpu_affinity auto;

# 进程文件
pid        /var/run/nginx.pid; # <linux>

# 错误日志
error_log  /var/log/nginx/error.log warn; # <linux>
# error_log  /var/log/nginx/error.log notice;
# error_log  /var/log/nginx/error.log info;
# error_log  logs/error.log; # <windows>

# 工作模式及连接数上限
events {
    use  epoll; # 多路复用IO(I/O-Multiplexing)的一种方式,仅用于linux2.6以上内核;用于提高nginx性能;
    
    worker_connections 4096; # 单个进程worker_process中最大并发链接数上限(线程数)

    # 1.Nginx并发总数max_clients = 进程数量worker_processes * 进程最大并发链接数worker_connections
    # 2.在设置了反向代理的情况下，max_clients = worker_processes * worker_connections / 4
    #  为什么反向代理要除以4：正常情况下Nginx能应付的最大连接数为 8000 * 4 = 32000
    #  设置worker_connections与物理内存有关：因为并发受IO约束，max_clients须小于系统能打开的最大文件数
    #  系统能打开的最大文件句柄数和内存大小成正比：一般`1GB内存`的机器上能打开的文件数大约是`10万`左右；
    #  系统能打开的最大文件句柄数为：
    #  > cat /proc/sys/fs/file-max # 输出 34336 ( ?文件不存在> ll /proc/sys/fs )
    #  32000 < 34336 即并发连接总数小于系统可以打开的文件句柄总数，这样就在操作系统可以承受的范围之内；
    #  所以，worker_connections需根据(worker_processes)进程数和系统能打开的最大文件数进行适当地调整；
    #  > ulimit -SHn 65535  # 临时修改限制提高连接数上限?永久修改限制> cat /etc/security/limits.conf
    #  当然，理论上的并发总数(max_clients)会与实际有所偏差，因为主机还有其它工作进程需要消耗系统资源。
}

http {
    # 设定mime
    include       /etc/nginx/mime.types; # <linux>
    # include     mime.types; # <windows>
    default_type  application/octet-stream;
    
    # 设定日志
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main; # <linux>
    # access_log  logs/access.log; # <windows>

    # sendfile 指令指定 nginx 是否调用 sendfile 函数（zero copy 方式）来输出文件
    # 对于普通应用，必须设为 on
    # 如果用来进行下载等应用磁盘IO重负载应用，可设置为 off 以平衡磁盘与网络I/O处理速度，降低系统的uptime
    sendfile     on;
    # tcp_nopush     on;

    # 设定KA连接超时
    keepalive_timeout  65;
    # tcp_nodelay   on;

    # 开启gzip压缩
    gzip  on;
    gzip_disable "MSIE [1-6].";

    # 设定请求缓冲
    # client_header_buffer_size    128k;
    # large_client_header_buffers  4096k;
    
    # 包含自定义配置
    include /etc/nginx/conf.d/*.conf; # <linux>

    # 设定主机配置
    server {
        # 主机端口 检查: sudo netstat -anptW|grep -i "listen" # <windows> netstat -anp tcp|findstr -i "listening"
        listen  80;
        # 主机域名
        server_name  localhost;
        # server_name  apiserver.com;
        # server_name  www.nginx.cn;
        # 主机http请求限制
        client_max_body_size 1024M;

        # 定义服务器默认网站根目录
        # root html; # <windows> wwwroot

        # 设定本主机的访问日志
        # access_log  logs/access.80.log; # <windows>
        
        # 添加请求响应头 # CSP安全: 避免XSS攻击,iframe漏洞等
        add_header Content-Security-Policy "default-src 'self'";
        add_header X-Frame-Options DENY;

        # 默认页(首页)
        location / {
            # index index.php index.html index.htm;
        }
        
        # 跳转页(301,302)
        location / {
          # return 302 https://$host$request_uri; # HTTP转HTTPS
        }
        
        # 覆盖父块中或上面添加的请求头 rewrite
        location /viarus {
          add_header X-Content-Type-Options nosniff; # 覆盖添加add_header
          rewrite ^(.*)$ /xss.html break;
        }

        # 错误页
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
          # 
        }
        
        # 虚拟目录(alias:注意后缀保持一致`有或无/`,避免`目录穿越漏洞`)
        location /public {
          # alias /var/www/app/public;
        }
        
        # 静态文件优化
        location ~ ^/(images|javascript|js|css|flash|media|static)/ {
            expires 30d; # 过期时间，文件不怎么更新，可以设大点；如果频繁更新，则设小一点。
        }

        # PHP 脚本请求全部转发到 FastCGI处理. 使用FastCGI默认配置.
        location ~ .php$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

        # PHP 禁止访问 .ht* 文件
        location ~ /.ht {
            deny all;
        }
        
    }
}
~~~

 * 配置代理 https & ws
~~~
 # 负载均衡 http web
 upstream web {
    server 127.0.0.1:8080; # 转发策略(默认:轮询)
    server 127.0.0.1:8081;
 }
 # 负载均衡 websocket
 upstream websocket {
    server 0.0.0.0:3001;
    server 0.0.0.0:3002;
 }
 
 server { 
    #listen       80;
    listen       443;
    server_name  localhost;
    ssl          on;
    ssl_certificate      /cert/cert.crt; # 证书
    ssl_certificate_key  /cert/cert.key; # 密钥
    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  50m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 SSLv2 SSLv3;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    # wss 反向代理  
    location /ws {
        proxy_pass       http://websocket/;  # 代理到上面的地址 upstream websocket
        proxy_set_header Connection Upgrade;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 60s;
    }
    # http web 反向代理
    location / {
        proxy_pass       http://web/;  # 代理到上面的地址 upstream web
        proxy_http_version 1.1;
        proxy_set_header Connection keep-alive;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 600s; # 下载超时-限制
        client_max_body_size 5m; # 上传文件-限制
    }
}
~~~

 * 配置（HA）高可用 Nginx + Keepalived
        <br>Keepalived 以 VRRP 协议为基础来实现高可用性。VRRP（Virtual Router Redundancy Protocol 虚拟路由冗余协议）是用于实现路由器冗余的协议，它将两台或多台路由器设备虚拟成一个设备，对外提供虚拟路由器 IP（一个或多个VIP）<br>
        ![](https://github.com/angenalZZZ/doc/raw/master/screenshots/1115091513.png)
        在上图中，将 Nginx + Keepalived 部署在两台服务器上，拥有两个真实的 IP（IP1 和 IP2），通过一定的技术（如 LVS）虚拟出一个虚拟 IP（VIP），外界请求通过访问 VIP 来访问服务。在两台 Nginx + Keepalived 的服务器上，同一时间只有一台会接管 VIP（叫做 Master）提供服务，另一台（叫做 Slave）会检测 Master 的心跳，当发现 Master 停止心跳后，Slave 会自动接管 VIP 以提供服务（此时，Slave 变成 Master）。通过这种方式来实现 Nginx 的高可用，通过第 19 节可以知道，Nginx 可以对后台 API 服务器做高可用，这样通过 Nginx + Keepalived 的组合方案就实现了整个 API 集群的高可用。 部署参考[Keepalived+Nginx实现高可用（HA）](https://blog.csdn.net/xyang81/article/details/52556886)


