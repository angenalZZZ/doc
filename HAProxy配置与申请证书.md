# [HAProxy](https://www.haproxy.org)
[The Reliable, High Performance TCP/HTTP Load Balancer](https://docs.haproxy.org)

#### [Starter Guide and Summary](https://docs.haproxy.org/2.8/intro.html)

#### Demo Application
    `haproxy [-f <cfgfile|cfgdir>]`
- `demo.cfg`
~~~
defaults
  mode http # 默认模式=tcp:第4层代理 http:第7层代理
  timeout client 15s
  timeout connect 5s
  timeout server 15s
  timeout http-request 15s

frontend http_and_https
  bind :80,:8080
  bind :443 ssl crt /app/cert/haproxy/demo.ddns.net.pem alpn h2,http/1.1 # 可关闭http/1.1
  http-request deny deny_status 402 if { path -i -m beg /admin }
  acl app_rule1 path_beg -i /app1
  acl app_rule2 path_beg -i /app2
  use_backend app1_servers if app_rule1
  use_backend app2_servers if app_rule2
  #use_backend ***_servers if { dst_port 8001 }
  default_backend apps_servers

backend apps_servers
  balance roundrobin # Every Request Rotation Load Balancing
  #balance source    # IP Hash Load Balancing
  server server1 127.0.0.1:8001
  server server2 127.0.0.1:8002
  server server3 127.0.0.1:8003
  server server4 127.0.0.1:8004

backend app1_servers
  balance roundrobin
  server server1 127.0.0.1:8001
  server server2 127.0.0.1:8002

backend app2_servers
  balance roundrobin
  server server3 127.0.0.1:8003
  server server4 127.0.0.1:8004

~~~
