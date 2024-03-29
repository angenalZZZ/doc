# [Nginx](http://nginx.org/en/docs/)  [中文](http://www.nginx.cn/doc/)
# [`腾讯云文档`SSL证书安装部署（Windows、](https://cloud.tencent.com/document/product/400/94492)[Linux）](https://cloud.tencent.com/document/product/400/35244)

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
> nssm install nginx          # <Windows>服务安装，可用 https://nssm.cc
~~~
* [OpenResty](https://openresty.org/cn/)®是一个基于 [Nginx](https://openresty.org/cn/nginx.html) 与 [Lua](https://www.lua.org/) 的高性能 Web 平台，其内部集成了大量精良的 Lua 库、第三方模块以及大多数的依赖项。用于方便地搭建能够处理超高并发、扩展性极高的动态 Web 应用、Web 服务和动态网关。
* [Tengine](http://tengine.taobao.org/index_cn.html)是由淘宝网发起的Web服务器项目。它在Nginx的基础上，针对大访问量网站的需求，添加了很多高级功能和特性。Tengine的性能和稳定性已经在大型的网站如淘宝网，天猫商城等得到了很好的检验。它的最终目标是打造一个高效、稳定、安全、易用的Web平台。

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

* 安全加固
  * 禁止服务信息泄露(禁止目录浏览,隐藏版本信息)
~~~nginx
autoindex off;           # 禁止目录浏览
server_tokens off;       # 隐藏版本信息
~~~
  * 开启 SSL/TLS 加密
~~~nginx
listen               443 ssl;
ssl_certificate      /path/cert.pem;
ssl_certificate_key  /path/key.pem;
~~~
  * 防止 DDOS 攻击
~~~nginx
limit_conn_zone $binary_remote_addr zone=addr:10m;
limit_conn addr 100;
~~~
  * 设置缓冲区，防止缓冲区溢出攻击
~~~nginx
# 在server模块中要限制的location中添加以下参数
client_body_buffer_size  1K;
client_header_buffer_size 1k;
client_max_body_size 1k;
large_client_header_buffers 2 1k;
~~~
  * 日志配置、日志切割
~~~nginx
# 在http模块中添加如下参数
log_format main
'$remote_addr - $remote_user [$time_local] "$request" ' 
'$status $body_bytes_sent "$http_referer" ' 
'"$http_user_agent" "$http_x_forwarded_for"'
access_log logs/host.access.log main;

#日志切割脚本如下
#!/bin/bash
# 设置日志文件存放目录
logspath="/usr/local/nginx/logs/"
# 设置pid文件
pidpath="/usr/local/nginx/nginx.pid"
# 重命名日志文件
mv ${logspath}access.log ${logspath}access$(date -d "yesterday" +"%Y%m%d").log
# 向nginx主进程发信号重新打开日志
kill -USR1 `cat ${pidpath}`
~~~
  * 错误页面重定向
~~~nginx
# 新建错误页面,放到静态目录中;在http模块中添加如下参数
fastcgi_intercept_errors on;
errorpage 401 /401.html;
errorpage 402 /402.html;
errorpage 403 /403.html;
errorpage 404 /404.html;
errorpage 405 /405.html;
errorpage 500 /500.html
~~~
  * 防止 SQL 注入攻击
~~~nginx
# 我们应该对输入进行过滤和验证，并使用参数化查询等安全措施。
~~~
  * 限制 HTTP 请求方法
~~~nginx
if ($request_method !~ ^(GET|HEAD|POST)$) {
  return 444;
}
~~~
  * 限制 IP 访问
~~~nginx
location / {
  deny 192.168.1.1;     # 拒绝IP
  allow 192.168.1.0/24; # 允许IP
  allow 10.1.1.0/16;    # 允许IP
  deny all;             # 拒绝其它所有IP
}
~~~
  * 限制并发速度
~~~nginx
# 限制用户连接数及速度来预防DOS攻击
limit_zone one $binary_remote_addr 10m;
server
{
     listen   80;
     server_name www.test.com;
     index index.htm index.html index.php;
     root  /usr/local/www;
     #Zone limit;
     location / {
         limit_conn one 1;
         limit_rate 20k;
     }
    … … …
}
~~~
  * 控制超时时间
~~~nginx
# 在http模块下，配置如下配置，具体时间根据业务需要进行调整;
client_body_timeout 10;  # 客户端请求主体读取超时时间
client_header_timeout 10;  # 客户端请求头读取超时时间
keepalive_timeout 5 5;  # 第一个参数指客户端连接保持活动的超时时间，第二个参数是可选的，指消息头保持活动的有效时间
send_timeout10;  # 响应客户端的超时时间
~~~
  * Nginx 降权
~~~nginx
user nobody;
~~~
  * Nginx 防盗链
~~~nginx
location ~* ^.+\.(gif|jpg|png|swf|flv|rar|zip)$ {
    valid_referers none blocked server_names *.nsfocus.com http://localhost baidu.com;
    if ($invalid_referer) {
        rewrite ^/ [img]http://www.XXX.com/images/default/logo.gif[/img];
        # return 403;
    }
}
~~~
  * 配置WAF(防火墙)
~~~nginx
# 下载waf模块: wget https://github.com/loveshell/ngx_lua_waf/archive/master.zip
# 配置waf相关Lua、目录、脚本等(nginx需加载nginx_lua_module模块)
# 编辑配置文件，在http模块中添加如下参数:
lua_package_path "/usr/local/nginx/conf/waf/?.lua";
lua_shared_dict limit 10m;
init_by_lua_file /usr/local/nginx/conf/waf/init.lua;
access_by_lua_file /usr/local/nginx/conf/waf/waf.lua;
# 新建攻击日志目录;然后重启nignx服务.
mkdir -p /data/logs/hack/
chown -R nobody:nobody /data/logs/hack/
chmod -R 755 /data/logs/hack/
~~~


* [配置参数说明](https://github.com/digitalocean/nginxconfig.io)与[✨在线编辑器](https://nginxconfig.io/)、[托管 ASP.NET Core](https://docs.microsoft.com/zh-cn/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-5.0#configure-nginx)
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
~~~nginx
# vi /etc/nginx/nginx.conf
# 小程序接口的域名配置，小程序规定要https，填写对应域名，并把https证书上传至服务器
server {
        listen 443;
        server_name api.xx.com;
        ssl on;
        ssl_certificate     /usr/share/nginx/cert/xxxxxxxxxxxxxxxx.pem;
        ssl_certificate_key /usr/share/nginx/cert/xxxxxxxxxxxxxxxx.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
        ssl_prefer_server_ciphers on;
        location / {
            proxy_pass http://127.0.0.1:8082;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

# 后台域名配置，后台vue页面代码上传至 /usr/share/nginx/admin
server {
    listen       80;
    server_name  admin.xx.com;
    root         /usr/share/nginx/admin;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    location / {
    }

    # 跨域配置
    location /apis {
    	rewrite    ^/apis/(.*)$ /$1 break;
    	proxy_pass http://127.0.0.1:8081;
    }
}
~~~

 * 禁用 IP 访问网站
~~~nginx
# vi /usr/local/openresty/nginx/conf/nginx.conf

server {
    listen 80 default_server;
    server_name _; # "_"表示匹配所有域名
    return 444;    # 直接关闭连接
}

# sudo /usr/local/openresty/nginx/sbin/nginx -s reload
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
 * 配置代理-解决跨域问题
~~~nginx
server {
    listen       *:80;
    server_name  localhost company.com www.company.com;
    location / {
        if ($request_method == 'OPTIONS') {
            add_header Access-Control-Allow-Origin 'http://localhost:8080'; # 前端网址
            add_header Access-Control-Allow-Headers '*';
            add_header Access-Control-Allow-Methods '*';
            add_header Access-Control-Allow-Credentials 'true'; # 允许跨域使用Cookies
            return 204;
        }
        if ($request_method != 'OPTIONS') {
            add_header Access-Control-Allow-Origin 'http://localhost:8080' always; # 前端网址
            add_header Access-Control-Allow-Credentials 'true'; # 允许跨域使用Cookies
        }
        proxy_pass  http://localhost:5000; # 后端网址::反向代理::
    }
}
~~~
 * 配置代理[`国密改造`](https://docs.jumpserver.org/zh/v3/installation/gmssl/#12-nginx)
~~~
server {
    listen 80;
    server_name test.domain.localhost;  # 自行修改成你的域名
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name test.domain.localhost;  # 自行修改成你的域名

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECC-SM4-SM3:ECDH:AESGCM:HIGH:MEDIUM:!RC4:!DH:!MD5:!aNULL:!eNULL;  # 算法
    ssl_verify_client off;
    ssl_session_timeout 5m;
    ssl_prefer_server_ciphers on;

    # ssl_certificate sslkey/test.domain.localhost_bundle.crt;             # rsa 证书，过渡使用
    # ssl_certificate_key sslkey/test.domain.localhost_RSA.key;

    ssl_certificate sslkey/test.domain.localhost_sm2_sign_bundle.crt;      # 配置国密签名证书/私钥
    ssl_certificate_key sslkey/test.domain.localhost_SM2.key;

    ssl_certificate sslkey/test.domain.localhost_sm2_encrypt_bundle.crt;   # 配置国密加密证书/私钥
    ssl_certificate_key sslkey/test.domain.localhost_SM2.key;

    client_max_body_size 5000m;  # 上传文件大小限制

    location / {
        proxy_pass http://192.168.100.100;  # 后端 jumpserver 访问地址
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        proxy_set_header X-Forwarded-For $remote_addr;

        proxy_ignore_client_abort on;
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 6000;
    }
}
~~~

 * 配置安全信息`XSS跨站攻击漏洞`
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


# **115配置HTTPS和HTTP使用同一个端口**
### 115配置原理
NGINX 1.15.2版本中新增了一个关键功能，`stream_ssl_preread`模块允许在协议握手阶段，从消息中提取协议类型或域名信息，根据不同的协议或域名进行转发。

在使用TCP(stream)代理转发流量时,可以使用`ssl_preread_protocol`变量区分SSL/TLS和其他协议。

`ssl_preread_protocol`变量从消息字段中提取SSL/TLS 版本号。如果不是 SSL 或 TLS 连接，则变量将为空，表示连接使用的是 SSL/TLS 以外的协议。
`ssl_preread_protocol`变量值：
- TLSv1
- TLSv1.1
- TLSv1.2
- TLSv1.3
- **""    非**SSL/TLS协议
### 115配置示例
`/etc/nginx/nginx.conf`
```nginx
# 新增配置
stream {
    upstream web {
        server 192.168.56.114:8080;
    }

    upstream https {
        server 192.168.56.114:8443;
    }

    log_format basic 'ssl_version: $ssl_preread_protocol | upstream: $upstream';
    access_log /var/log/nginx/nginx-access.log basic ;
    
    map $ssl_preread_protocol $upstream {
        "" web;
        "TLSv1.3" https;
        default https;
    }

    # HTTPS and HTTP on the same port
    server {
        listen 80;
        
        proxy_pass $upstream;
        ssl_preread on;
    }
}
```
`/etc/nginx/conf.d/default.conf`
```nginx
server {
    listen       8080;
    listen       8443  ssl;
    server_name  localhost;

    ssl_certificate     /home/ssl/server.crt;
    ssl_certificate_key /home/ssl/server.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_password_file   /home/ssl/cert.pass;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
如果要通过（例如）在同一端口上运行** SSL/TLS **和 其他TCP服务(例如SSH或数据库)来避免防火墙限制，这将非常有用。
除了`ssl_preread_protocol`变量，还支持以下变量：

- `ssl_preread_server_name`	获取请求的服务器名称
- `ssl_preread_alpn_protocols`获取**ALPN** 协议列表,这些值用逗号分隔(例如`h2,http/1.1`）
### 115配置测试
开启防火墙，只放行80端口
```bash
systemctl start firewalld
# 放行80端口
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --reload
```
### 115配置将http重定向到https
`/etc/nginx/conf.d/default.conf`
```nginx
server {
    listen       8080; 
    server_name  localhost;
    return 301 https://192.168.56.109:80$request_uri;
}

server {
    listen       8443  ssl;
    server_name  localhost;

    ssl_certificate     /home/ssl/server.crt;
    ssl_certificate_key /home/ssl/server.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_password_file   /home/ssl/cert.pass;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
   
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
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


