# iis配置

> `应用程序池`可用线程数 (优化✔并发200~800) 50×4 ~ 200×4 (CPUv4)
```cmd
:: 1.修改-最小可用线程数: minWorkerThreads=50 .NET最大请求队列数限制: requestQueueLimit=10万
> notepad "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
:: 2.修改-最大并发请求限制: appConcurrentRequestLimit=100000
> "%systemroot%\System32\inetsrv\appcmd.exe" set config /section:serverRuntime /appConcurrentRequestLimit:100000
> notepad "%systemroot%\System32\inetsrv\config\applicationHost.config"
:: 3.选项-最大工作进程数-在多进程(5=1GB内存消耗)模式下,可提升服务器性能; 但是,依赖进程的Session和Cache等对象不再适用
```
~~~xml
  <system.web>
    <!--<processModel autoConfig="true" />-->
    <processModel autoConfig="false" enable="true" minWorkerThreads="50" maxWorkerThreads="200" requestQueueLimit="100000" />
~~~

> `MIME类型`添加 svg, woff ...
```
.svg    image/svg+xml
.woff   application/x-font-woff
.woff2  application/x-font-woff
```

