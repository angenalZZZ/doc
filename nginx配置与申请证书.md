# [Nginx](http://nginx.org/en/docs/)  [中文](http://www.nginx.cn/doc/)

* 安装
~~~shell
yum -y install nginx          # <CentOS>
sudo apt-get -y install nginx # <Ubuntu>
sudo ufw allow 'Nginx Full'   # 配置防火墙
sudo ufw status               # 验证更改
sudo systemctl enable nginx   # 设置开机启动
sudo systemctl status nginx   # 检查服务状态，Nginx 默认监听 80 端口(确保没被占用)
sudo systemctl restart nginx  # 重启服务
sudo systemctl reload nginx   # 修改配置后，需要重新加载服务
sudo systemctl disable nginx && sudo systemctl stop nginx #禁止开机启动，停止服务
ls /etc/nginx/sites-available # 设置Nginx服务器模块(类似Apache虚拟主机) www.linuxidc.com/Linux/2018-05/152258.htm
sudo apt install certbot      # 使用Let's Encrypt保护Nginx  www.linuxidc.com/Linux/2018-05/152259.htm
~~~
* 常用命令
~~~shell
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
* 检查分析与[✨工具gixy](https://github.com/yandex/gixy)、[Lua-Anti-DDoS-Script](https://github.com/C0nw0nk/Nginx-Lua-Anti-DDoS)
~~~shell
# 检查
cd /etc/nginx
nginx -t
# 分析
pip install gixy
gixy nginx.conf
~~~

* 使用let's encrypt免费证书与[✨工具certbot](https://certbot.eff.org) [工具acme.sh](https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E)
~~~shell
# 安装certbot
cd /data/certificate
wget -O /sbin/certbot --no-check-certificate https://dl.eff.org/certbot-auto
chmod a+x /sbin/certbot
certbot -n  # 安装依赖 (建议先修改为国内的pip源)
# 生成证书 >> /etc/letsencrypt/live/*.com/*.pem
## 单域名生成证书
certbot certonly --email *@*.com --agree-tos --no-eff-email --webroot \
  -w /data/web/www* -d www.*.cn
## 多域名单目录生成单证书：(即一个网站多个域名使用同一个证书)
certbot certonly --email *@*.com --agree-tos --no-eff-email --webroot \
  -w /data/web/www* -d www.*.cn -d api.*.cn
## 多域名多目录生成一个证书：(即一次生成多个域名的一个证书)
certbot certonly --email *@*.com --agree-tos --no-eff-email --webroot \
  -w /data/web/www* -d www.*.cn -d api.*.cn \
  -w /data/web/www* -d www.*.cn -d api.*.cn \
## 配置nginx
  #参考下面 * 配置代理 https & ws
  #注意事项：因为默认环境是不允许访问以"."开头的隐藏文件及目录，
  #所以访问http://abc.com/.well-known/acme-challenge/* 这个链接会返回403错误，必须修改虚拟主机vhost配置文件
  #在配置 location ~ /\. { deny all; } 前面添加，最后重启nginx
  location ~ /.well-known { allow all; } #或加下面两行
  location ^~ /.well-known/acme-challenge/ { default_type "text/plain"; root /path/website/; }
  location = /.well-known/acme-challenge/ { return 404; }
## 配置crontab `把证书更新添加到计划任务` 由于只有90天就得更新证书，而且只有在7天内的过期的才能更新
## * * * */1 * /data/certificate/certbot-auto renew --disable-hook-validation
00 00 00 */3 * /sbin/certbot renew --renew-hook "service nginx reload" --quiet > /dev/null 2>&1 &
## 回收证书
certbot revoke --cert-path /etc/letsencrypt/live/example.com/cert.pem
certbot delete --cert-name example.com
## 在阿里云上，OSS和CDN的配置上，选择直接输入证书内容替换原来直接选择的阿里云证书。
~~~

* [配置参数说明](https://github.com/digitalocean/nginxconfig.io)与[✨在线编辑器](https://nginxconfig.io/)
~~~nginx
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
        listen  80;  # 唯一性: listen+server_name
        # 主机域名
        server_name  localhost;
        # server_name  www.x.cn;
        # server_name  api.x.cn;
        # server_name  static.x.cn;
        # server_name     *.x.com; # 一般会结合反向代理 location / { proxy_pass...
        # 主机http请求限制
        client_max_body_size 1024M;

        # 定义服务器默认网站根目录
        root  /html/static; # <windows> C:/inetpub/wwwroot

        # 设定本主机的访问日志
        # access_log  logs/access.80.log; # <windows>
        
        # 添加请求响应头 # CSP安全: 避免XSS攻击,iframe漏洞等
        add_header Content-Security-Policy "default-src 'self'";
        add_header X-Frame-Options DENY;

        # 默认页(首页)
        location / {
            # index index.php index.html index.htm start.htm;
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
 * 配置代理 http
~~~nginx
server {
    listen *:80; # 绑定ip端口
    server_name company.com www.company.com; # 绑定域名

    # 反向代理: cloudreve 云存储的云盘系统 https://docs.cloudreve.org/getting-started/install
    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:5212;
        # client_max_body_size 2000m; # 上传文件-限制
    }

    return 301 https://$host$request_uri;
}
~~~
 * 配置代理 https
~~~nginx
server {
    listen *:80;
    server_name company.com www.company.com;

    return 301 https://$host$request_uri;
}
server {
    listen *:443 ssl;
    server_name company.com www.company.com;
    ssl on;
    ssl_certificate /etc/nginx/ssl/company-cert.pem;
    ssl_certificate_key /etc/nginx/ssl/company-key.pem;

    # 静态资源: html
    location /  {
      root    /var/www/html;
      expires 1d;
    }

    # 反向代理: api
    location /api {
        proxy_pass http://127.0.0.1:8080; // proxy pass a real host.
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
~~~
 * 配置代理 https & 负载均衡 upstream & ws
~~~nginx
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
    #ssl_certificate         /cert/cert.crt; # 证书
    ssl_certificate          /etc/letsencrypt/live/*.com/fullchain.pem;
    #ssl_certificate_key     /cert/cert.key; # 密钥
    ssl_certificate_key      /etc/letsencrypt/live/*.com/privkey.pem;
    #ssl_trusted_certificate /cert/cert.pem; # 授信
    ssl_trusted_certificate  /etc/letsencrypt/live/*.com/chain.pem;
    #ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    #ssl_protocols TLSv1 TLSv1.1 TLSv1.2 SSLv2 SSLv3;
    #ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_ciphers  ALL:!DH:!EXPORT:!RC4:+HICH:+MEDIUM:!LOW:!aNULL:!eNULL;
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
        proxy_http_version 1.1;
        proxy_set_header Connection keep-alive;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        # proxy_redirect off;   # 禁止反转url
        proxy_pass       http://web/;  # 代理到上面的地址 upstream 负载均衡 http web
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 600s; # 下载超时-限制
        client_max_body_size 2m; # 上传文件-限制
    }
}
~~~
```
//-配置Nginx响应`头信息`：http.server.add_header, http.server.location.proxy_set_header
{
    "server": "nginx",
    "date": "Thu, 12 Dec 2019 06:09:32 GMT", // 时间戳
    "content-type": "application/json", // default: api request
    "transfer-encoding": "chunked",
    "connection": "close", // default: keep-alive
    "vary": "Cookie", // default: Accept-Encoding // 允许编码
    "allow": "GET, PUT, PATCH, DELETE, HEAD, OPTIONS",  // 允许跨站加载方式
    "strict-transport-security": "max-age=31536000",
    "x-frame-options": "deny",  // 拒绝跨站加载iframe
    "x-content-type-options": "nosniff", // 拒绝跨站跟踪
    "x-xss-protection": "1; mode=block", // 拒绝跨站攻击
    "x-rate-limit-limit": "300", // request: limited times of a minute 请求限制
    "x-rate-limit-remaining": "299", // request: remaining times
    "x-rate-limit-reset": "18"   // request: reset times after 18 seconds
}
```

> [聊天平台 Rocket.Chat](https://docs.rocket.chat/installation/manual-installation) : /etc/nginx/conf.d/rocketchat.conf
~~~nginx
# Configure Nginx Reverse Proxy
upstream rocket_backend {
  server 127.0.0.1:3000;
}

server {
    listen 80;
    server_name chat.hirebestengineers.com;
    access_log /var/log/nginx/rocketchat-access.log;
    error_log /var/log/nginx/rocketchat-error.log;

    location / {
        proxy_pass http://rocket_backend/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}
~~~
~~~bash
# Check if Nginx configuration is ok
sudo nginx -t 
sudo systemctl restart nginx
sudo systemctl enable nginx

# Setup Let’s Encrypt SSL
sudo apt install certbot python3-certbot-nginx
certbot --nginx  # Then run certbot to acquire SSL certificate
~~~
> After `Setup Let’s Encrypt SSL` 
~~~nginx
upstream rocket_backend {
  server 127.0.0.1:3000;
}

server {
    server_name chat.hirebestengineers.com;
    access_log /var/log/nginx/rocketchat-access.log;
    error_log /var/log/nginx/rocketchat-error.log;

    location / {
        proxy_pass http://rocket_backend/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/chat.hirebestengineers.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/chat.hirebestengineers.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    if ($host = chat.hirebestengineers.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    server_name chat.hirebestengineers.com;
    return 404; # managed by Certbot
}
~~~


 * 配置（HA）高可用 Nginx + Keepalived
        <br>Keepalived 以 VRRP 协议为基础来实现高可用性。VRRP（Virtual Router Redundancy Protocol 虚拟路由冗余协议）是用于实现路由器冗余的协议，它将两台或多台路由器设备虚拟成一个设备，对外提供虚拟路由器 IP（一个或多个VIP）<br>
        ![](https://github.com/angenalZZZ/doc/raw/master/screenshots/1115091513.png)
        在上图中，将 Nginx + Keepalived 部署在两台服务器上，拥有两个真实的 IP（IP1 和 IP2），通过一定的技术（如 LVS）虚拟出一个虚拟 IP（VIP），外界请求通过访问 VIP 来访问服务。在两台 Nginx + Keepalived 的服务器上，同一时间只有一台会接管 VIP（叫做 Master）提供服务，另一台（叫做 Slave）会检测 Master 的心跳，当发现 Master 停止心跳后，Slave 会自动接管 VIP 以提供服务（此时，Slave 变成 Master）。通过这种方式来实现 Nginx 的高可用，通过第 19 节可以知道，Nginx 可以对后台 API 服务器做高可用，这样通过 Nginx + Keepalived 的组合方案就实现了整个 API 集群的高可用。 部署参考[Keepalived+Nginx实现高可用（HA）](https://blog.csdn.net/xyang81/article/details/52556886)


