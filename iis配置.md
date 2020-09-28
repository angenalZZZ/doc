# iis配置

> `应用程序池`可用线程数 (优化✔并发200~800) 50×4 ~ 200×4 (CPUv4)
```cmd
> notepad "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
```
~~~xml
  <system.web>
    <!--<processModel autoConfig="true" />-->
    <processModel autoConfig="false" maxWorkerThreads="200" minWorkerThreads="50" />
~~~

