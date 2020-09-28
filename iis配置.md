# iis配置

> `应用程序池`可用线程数 (优化✔并发200~800) 50×4 ~ 200×4 (CPUv4)
```cmd
# 1.提升-最小可用线程数-minWorkerThreads
> notepad "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
# 2.设置-最大工作进程数-在多进程模式下(5=1GB内存消耗),可提升服务器性能;但是,依赖进程的Session和Cache等对象不再适用
```
~~~xml
  <system.web>
    <!--<processModel autoConfig="true" />-->
    <processModel autoConfig="false" minWorkerThreads="50" maxWorkerThreads="200" />
~~~

