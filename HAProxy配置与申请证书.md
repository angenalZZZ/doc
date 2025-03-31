# [HAProxy](https://www.haproxy.org)
[The Reliable, High Performance TCP/HTTP Load Balancer](https://docs.haproxy.org)

#### [Starter Guide](https://docs.haproxy.org/2.8/intro.html) and [Configuration](https://docs.haproxy.org/2.8/configuration.html)

#### Demo
    haproxy [-f <cfgfile|cfgdir>]
- `demo.cfg`
~~~
global
  maxconn 4096 # 最大连接数 < 65500 < 100000

defaults
  mode http # 模式=tcp:第4层代理  模式=http:第7层代理(支持http-request)
  log  global
  timeout client 15s
  timeout connect 5s
  timeout server 15s
  timeout http-request 15s

frontend http_and_https
  # my.noip.com For free domain hosting and DDNS Dynamic IP address
  bind :80,:8080
  # SNI 'Server Name Indication' For shared hosting
  # ALPN 'Application-Layer Protocol Negotiation' is a TLS extension (defined in RFC 7301)
  # H2 'HTTP2' For good measures
  # TLS 1.3 For great security and a single round trip
  # SNI/ALPN/H2/TLS 1.3  多域名证书: crt /cert/1.pem crt /cert/2.pem 扩展: alpn *接受协议* 可关闭: http/1.1
  bind :443 ssl crt /app/cert/haproxy/demo.ddns.net.pem alpn h2,http/1.1
  http-request deny deny_status 402 if { path -i -m beg /admin }
  acl app_rule1 path_beg -i /app1
  acl app_rule2 path_beg -i /app2
  use_backend app1_servers if app_rule1
  use_backend app2_servers if app_rule2
  #use_backend ***_servers if { dst_port 8001 }
  #use_backend ***_servers if { hdr(host) -i ***.ddns.net }
  default_backend apps_servers # Load: balance roundrobin

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

---

### [Keepalived](https://www.keepalived.org)
[运行在`lvs`上，是一个用于做双机热备（HA）的软件，实现真实机的故障隔离及负载均衡器间的失败切换，提高系统的可用性。](https://github.com/acassen/keepalived)
* [参考文章](https://www.keepalived.org/doc/)
* [运行原理](https://wsgzao.github.io/post/keepalived/)
~~~
  keepalived通过选举（看服务器设置的权重）挑选出一台热备服务器做MASTER机器，MASTER机器会被分配到一个指定的虚拟ip，
  外部程序可通过该ip访问这台服务器，如果这台服务器出现故障（断网，重启，或者本机器上的keepalived crash等），
  keepalived会从其他的备份机器上重选（还是看服务器设置的权重）一台机器做MASTER并分配同样的虚拟IP，充当前一台MASTER的角色。
~~~

- LB (Load Balancer) 负载均衡
- HA (High Available) 高可用
- Failover 失败切换
- Cluster 集群
- LVS (Linux Virtual Server) `Linux`虚拟服务器
- DS (Director Server) 前端负载均衡器节点
- RS (Real Server) 后端真实的工作服务器
- VIP (Virtual IP) 虚拟的IP地址，向外部直接面向用户请求，作为用户请求的目标 IP 地址
- DIP (Director IP) 主要用于和内部主机通讯的 IP 地址
- RIP (Real Server IP) 后端服务器的 IP 地址
- CIP (Client IP) 访问客户端的 IP 地址

- `/etc/keepalived/keepalived.conf`
~~~
vrrp_instance host1 {
    state MASTER
    priority 100
    interface eth0
    virtual_router_id 101
    virtual_ipaddress {
        192.168.1.101
    }
    authentication {
        auth_type PASS
        auth_pass HGJ766GR767FKJU0
    }
}
~~~
~~~
vrrp_instance host2 {
    state BACKUP
    priority 200
    interface wlan0
    virtual_router_id 102
    virtual_ipaddress {
        192.168.1.102
    }
    authentication {
        auth_type PASS
        auth_pass HGJ766GR767FKJU0
    }
}
~~~

---

