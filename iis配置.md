# iis配置

> `应用程序池`可用线程数(优化) 50×4 ~ 200×4 (CPUv4) <br>
    notepad "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
```
  <system.web>
    <!--<processModel autoConfig="true" />-->
    <processModel autoConfig="false" maxWorkerThreads="200" minWorkerThreads="50" />
```

