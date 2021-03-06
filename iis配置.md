# iis配置

> `应用程序池` 可用线程数 (优化✔并发400~2000) 100×4 ~ 500×4 (CPUv4) + 最大连接数 (优化✔并发10万)
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
:: 6.最后-压测-benchmark-工具 github.com/rakyll/hey #支持HTTP2 完全可替代ApacheBench(ab) (强力推荐)
> hey -c 200 -z 10s http://10.0.0.11:80/api/test
```
~~~xml
<!-- 1.设置(优化✔并发 CPUv4 => Requests/sec: 6000 以上) -->
<!-- C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config -->
<!-- C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config -->
<system.web>
  <!-- <processModel autoConfig="true" /> -->
  <processModel autoConfig="false" enable="true" maxWorkerThreads="500" maxIoThreads="500" minWorkerThreads="100" minIoThreads="100" requestQueueLimit="100000" />
~~~

> `MIME类型` 添加 svg woff ...
```
.svg    image/svg+xml
.woff   application/x-font-woff
.woff2  application/x-font-woff
```

> `上传限制` [Upload Large Files to IIS / .NET](https://www.webdavsystem.com/server/documentation/large_files_iis_asp_net)
~~~xml
  <system.webServer>
    <directoryBrowse enabled="false" />
    <security>
      <requestFiltering>
        <!-- 请求限制：2GB -->
        <requestLimits maxAllowedContentLength="2147483648" />
      </requestFiltering>
    </security>
  </system.webServer>
~~~

> `URL重定向` [`1.Install IIS URL Rewrite`](https://www.iis.net/downloads/microsoft/url-rewrite) [`Download samples`](https://download.microsoft.com/download/3/9/E/39E30671-7AD2-4902-B56B-C300D862595E/RewriteExtensibility.msi) `2.修改Web.config`
~~~xml
  <!-- <appSettings configSource="config\appSetting.config" /> -->
  <!-- ... ... -->
  <system.webServer>
    <directoryBrowse enabled="false" />
    <rewrite>
      <rules>
        <rule name="HTTP to HTTPS redirect" stopProcessing="true">
          <!-- eg. http://www.demo.com/ [to] https://www.demo.com/ -->
          <match url="(.*)" />
          <conditions>
            <add input="{HTTPS}" pattern="off" ignoreCase="true" />
          </conditions>
          <action type="Redirect" redirectType="Found" url="https://{HTTP_HOST}/{R:1}" />
        </rule>
        <rule name="Swagger to Web redirect" patternSyntax="ECMAScript" stopProcessing="true">
          <!-- eg. https://www.demo.com/swagger/ui/index [to] https://www.demo.com/web -->
          <match url="swagger/ui/index$" />
          <action type="Redirect" url="https://{HTTP_HOST}/web" />
        </rule>
      </rules>
    </rewrite>
  </system.webServer>
<!-- 重定向www. http://demo.com/ [to] http://www.demo.com/ -->
<!-- 添加网站 > 指定一个`空目录` > 填写名称并绑定 `demo.com` > 设置`Http重定向`=`http://www.demo.com/` > 重新启动。 -->
~~~

> `反向代理` [`1.Install IIS Application Request Routing`](https://www.iis.net/downloads/microsoft/application-request-routing) [`2.Enable proxy`](https://techcommunity.microsoft.com/t5/iis-support-blog/application-request-routing-part-2-reverse-proxy-and/ba-p/347937) `3.修改Web.config`
~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <directoryBrowse enabled="false" />
        <security>
            <requestFiltering>
                <requestLimits maxAllowedContentLength="2147483648" />
            </requestFiltering>
        </security>
        <rewrite>
            <!-- eg. http://www.demo.com/ [to] http://127.0.0.1:{3000,8080}/ -->
            <rules>
                <rule name="ReverseProxyInboundRule1" stopProcessing="true">
                    <match url="^api/(.*)" />
                    <action type="Rewrite" url="http://127.0.0.1:3000/api/{R:1}" />
                </rule>
                <rule name="ReverseProxyInboundRule2" stopProcessing="true">
                    <match url="(.*)" />
                    <conditions>
                        <add input="{CACHE_URL}" pattern="^(https?)://" />
                    </conditions>
                    <action type="Rewrite" url="{C:1}://127.0.0.1:8080/{R:1}" />
                </rule>
            </rules>
            <!-- (可选)替换输出内容 -->
            <outboundRules>
                <rule name="ReverseProxyOutboundRule1" preCondition="ResponseIsHtml1" stopProcessing="true">
                    <match filterByTags="A, Form, Img" pattern="^http(s)?://127.0.0.1:8080/(.*)" />
                    <action type="Rewrite" value="http{R:1}://www.demo.com/{R:2}" />
                <!-- <action type="Rewrite" value="http{R:1}://{HTTP_HOST}/{R:2}" /> -->
                </rule>
                <preConditions>
                    <preCondition name="ResponseIsHtml1">
                        <add input="{RESPONSE_CONTENT_TYPE}" pattern="^text/html" />
                    </preCondition>
                </preConditions>
            </outboundRules>
        </rewrite>
    </system.webServer>
</configuration>
~~~


> `**无法验证强名称签名**` [`1.引用dll错误 ASP.Net Projects must disable shadow copy`](https://blog.csdn.net/aoshilang2249/article/details/78111409) `2.修改Web.config`
~~~xml
  <system.web>
    <hostingEnvironment shadowCopyBinAssemblies="false" />
  </system.web>
~~~


----

