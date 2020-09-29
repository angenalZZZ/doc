# iis配置

> `应用程序池` 可用线程数 (优化✔并发200~800) 50×4 ~ 200×4 (CPUv4) + 最大连接数 (优化✔并发10万)
```cmd
:: 1.设置-最小可用线程数: minWorkerThreads=50 .NET最大请求队列数限制: requestQueueLimit=10万
> notepad "%windir%\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
::         C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config
::         C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config
:: 2.设置-最大并发请求限制: appConcurrentRequestLimit=10万
> "C:\Windows\System32\inetsrv\appcmd.exe" set config /section:serverRuntime /appConcurrentRequestLimit:100000
> notepad "%systemroot%\System32\inetsrv\config\applicationHost.config"
:: 3.调整-TCP/IP最大连接数: MaxConnections=10万
> reg add HKLM\System\CurrentControlSet\Services\HTTP\Parameters /v MaxConnections /t REG_DWORD /d 100000
:: 4.调整-应用程序池-高级设置
::     常规/队列长度: 65535 (单个进程最大值)
::     回收/固定时间间隔(分钟): 0 (禁用定期自动回收) 
::     进程模型/空闲超时操作：Suspend (挂起)
::     进程模型/启用 Ping: False (禁用Ping)
::     进程模型/闲置超时(分钟): 0 (不让应用程序池因为没有请求而回收)
::     进程模型/最大工作进程数: 5 (1GB内存消耗)多进程模式下,可提升服务器性能; 但是,依赖进程的Session和Cache等对象不再适用
:: 5.重启-设置生效
> net stop http & net start http & iisreset
```
~~~xml
<!-- 1.设置 C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config -->
  <system.web>
    <!-- <processModel autoConfig="true" /> -->
    <processModel autoConfig="false" enable="true" minWorkerThreads="50" maxWorkerThreads="200" requestQueueLimit="100000" />
~~~

> `MIME类型` 添加 svg woff ...
```
.svg    image/svg+xml
.woff   application/x-font-woff
.woff2  application/x-font-woff
```

> `反向代理` `url重写` [`Install url-rewrite`](https://www.iis.net/downloads/microsoft/url-rewrite) [`Download samples`](https://download.microsoft.com/download/3/9/E/39E30671-7AD2-4902-B56B-C300D862595E/RewriteExtensibility.msi) `修改Web.config`
~~~xml
  <system.webServer>
    <rewrite>
      <rules>
        <rule name="HTTP to HTTPS redirect" stopProcessing="true">
          <!-- eg. http://www.demo.com/web [to] https://www.demo.com/web -->
          <match url="(^web.*)" />
          <conditions>
            <add input="{HTTPS}" pattern="off" ignoreCase="true" />
          </conditions>
          <action type="Redirect" redirectType="Found" url="https://{HTTP_HOST}/{R:1}" />
        </rule>
      </rules>
    </rewrite>
  </system.webServer>
~~~

----

