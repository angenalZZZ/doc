# [Nginx](http://www.nginx.cn/doc/)

* [配置文件的检查与分析工具gixy](https://github.com/yandex/gixy)

* 基本配置与参数说明
~~~
#进程用户
user nobody;

#进程数量(通常设置成与cpu数量相等)
worker_processes  1;

#进程pid
#pid        logs/nginx.pid;

#错误日志
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#工作模式及连接数上限
events {
    use  epoll; # 多路复用IO(I/O-Multiplexing)的一种方式epoll,仅用于linux2.6以上内核;用于提高nginx性能
    
    worker_connections  4096; # 单个进程(worker_process)最大并发链接数

    #1.Nginx并发总数(max_clients) = 进程数量(worker_processes) * 进程最大并发链接数(worker_connections)
    #2.在设置了反向代理的情况下，max_clients = worker_processes * worker_connections / 4
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
    #设定mime类型,类型由mime.type文件定义
    include    mime.types;
    default_type  application/octet-stream;
    #设定日志格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log  main;

    #sendfile 指令指定 nginx 是否调用 sendfile 函数（zero copy 方式）来输出文件，
    #对于普通应用，必须设为 on,
    #如果用来进行下载等应用磁盘IO重负载应用，可设置为 off，
    #以平衡磁盘与网络I/O处理速度，降低系统的uptime.
    sendfile     on;
    #tcp_nopush     on;

    #连接超时时间
    #keepalive_timeout  0;
    keepalive_timeout  65;
    tcp_nodelay     on;

    #开启gzip压缩
    gzip  on;
    gzip_disable "MSIE [1-6].";

    #设定请求缓冲
    client_header_buffer_size    128k;
    large_client_header_buffers  4 128k;

    #设定虚拟主机配置
    server {
        #侦听80端口
        listen    80;
        #定义使用 www.nginx.cn访问
        server_name  www.nginx.cn;

        #定义服务器的默认网站根目录位置
        root html;

        #设定本虚拟主机的访问日志
        access_log  logs/nginx.access.log  main;
        
        #添加请求头
        #1.CSP安全:避免`XSS`攻击,`iframe`漏洞
        add_header Content-Security-Policy "default-src 'self'";
        add_header X-Frame-Options DENY;

        #默认请求(首页)
        location / {
            #定义首页索引文件的名称
            index index.php index.html index.htm;
        }
        
        #跳转页面(301,302)
        location / {
          return 302 https://$host$request_uri; #HTTP转HTTPS
        }
        
        #覆盖父块中添加的请求头(测试+rewrite)
        location /viarus {
          add_header X-Content-Type-Options nosniff; #覆盖后此块内可再添加add_header
          rewrite ^(.*)$ /xss.html break;
        }

        #定义错误提示页面
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
        
        #虚拟目录(alias:注意后缀保持一致`有或无/`,避免`目录穿越漏洞`)
        location /public {
          alias /var/www/app/public;
        }
        
        #静态文件，nginx自己处理
        location ~ ^/(images|javascript|js|css|flash|media|static)/ {
            #过期30天，静态文件不怎么更新，过期可以设大一点，如果频繁更新，则可以设置得小一点。
            expires 30d;
        }

        #PHP 脚本请求全部转发到 FastCGI处理. 使用FastCGI默认配置.
        location ~ .php$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

        #禁止访问 .htxxx 文件
        location ~ /.ht {
            deny all;
        }

    }
}
~~~

 * 配置 https & ws
~~~
 #代理https
 upstream web {
    server 0.0.0.0:3000;      
 }
 #websocket 代理
 upstream websocket {
    server 0.0.0.0:3000;
 }
 server { 
    listen       443;
    server_name  localhost;
    ssl          on;
    ssl_certificate     /cert/cert.crt;  # 配置证书
    ssl_certificate_key  /cert/cert.key; # 配置密钥
    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  50m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 SSLv2 SSLv3;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    #charset koi8-r;
    #access_log  logs/host.access.log  main;

  #wss 反向代理  
  location /wss {
     proxy_pass http://websocket/;  # 代理到上面的地址去
     proxy_read_timeout 60s;
     proxy_set_header Host $host;
     proxy_set_header X-Real_IP $remote_addr;
     proxy_set_header X-Forwarded-for $remote_addr;
     proxy_set_header Upgrade $http_upgrade;
     proxy_set_header Connection 'Upgrade';	
  }
  #https 反向代理
  location / {
     proxy_pass         http://web/;
     proxy_set_header   Host             $host;
     proxy_set_header   X-Real-IP        $remote_addr;
     proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
  }
}
~~~
