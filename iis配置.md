# iis配置

> `应用程序池` 可用线程数 (优化✔并发200~800) 50×4 ~ 200×4 (CPUv4) + 最大连接数 (优化✔并发10万)
```cmd
:: 1.设置-最小可用线程数: minWorkerThreads=50 .NET最大请求队列数限制: requestQueueLimit=10万
> notepad "%systemroot%\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
:: 2.设置-最大并发请求限制: appConcurrentRequestLimit=10万
> "%systemroot%\System32\inetsrv\appcmd.exe" set config /section:serverRuntime /appConcurrentRequestLimit:100000
> notepad "%systemroot%\System32\inetsrv\config\applicationHost.config"
:: 3.调整-TCP/IP最大连接数: MaxConnections=10万
> reg add HKLM\System\CurrentControlSet\Services\HTTP\Parameters /v MaxConnections /t REG_DWORD /d 100000
:: 4.调整-应用程序池/队列长度: 65535 (单个进程最大值)
:: 5.选项-应用程序池/最大工作进程数: 多进程(5=1GB内存消耗)模式下,可提升服务器性能; 但是,依赖进程的Session和Cache等对象不再适用
```
~~~xml
  <system.web>
    <!--<processModel autoConfig="true" />-->
    <processModel autoConfig="false" enable="true" minWorkerThreads="50" maxWorkerThreads="200" requestQueueLimit="100000" />
~~~

> `MIME类型` 添加 svg woff ...
```
.svg    image/svg+xml
.woff   application/x-font-woff
.woff2  application/x-font-woff
```

