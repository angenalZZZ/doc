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

> `手动添加静态资源文件类型`
~~~xml
<configuration>
  <system.webServer>
    <staticContent>
      <remove fileExtension=".apk" />
      <mimeMap fileExtension=".apk" mimeType="application/octet-stream" />
      <remove fileExtension=".woff" />
      <mimeMap fileExtension=".woff" mimeType="application/x-font-woff"/>
      <remove fileExtension=".svg" />
      <mimeMap fileExtension=".svg" mimeType="image/svg+xml" />
    </staticContent>
  </system.webServer>
</configuration>
~~~

> `默认文档` 添加到`网站`配置 ... +应用程序池`.NET v4.5` +[发布 ClickOnce 应用程序](https://docs.microsoft.com/zh-cn/visualstudio/deployment/publishing-clickonce-applications?view=vs-2019)
```xml
  <system.webServer>
    <defaultDocument>
      <files>
        <!-- 可以先清除IIS默认的配置项 -->
        <clear/>
        <!-- 发布 ClickOnce 应用程序后 -->
        <add value="WPF.application" />
      </files>
    </defaultDocument>
  </system.webServer>
```

> `上传限制` [Upload Large Files to IIS / .NET](https://www.webdavsystem.com/server/documentation/large_files_iis_asp_net)
~~~xml
  <system.webServer>
    <directoryBrowse enabled="false" />
    <security>
      <requestFiltering>
        <!-- 当前限制：2147483648 (2GB) ; 默认值：30000000 (28.6MB), 最大限制：4294967295 (4GB) -->
        <requestLimits maxAllowedContentLength="2147483648" maxQueryString="32768" maxUrl="4096" />
      </requestFiltering>
    </security>
  </system.webServer>
  <system.web>
    <!-- 仅当服务器 ASP.NET 运行时版本小于 4.5 时，设置当前限制：2097152 (2GB) ; 默认值：4096 (4MB) -->
    <httpRuntime maxRequestLength="2097152"/>
  </system.web>
  <!-- 可以指定访问地址后限制 -->
  <location path="file/upload">
    <system.webServer>
      <directoryBrowse enabled="false" />
      <security>
        <requestFiltering>
          <!-- 当前限制：2147483648 (2GB) ; 默认值：30000000 (28.6MB), 最大限制：4294967295 (4GB) -->
          <requestLimits maxAllowedContentLength="2147483648" maxQueryString="32768" maxUrl="4096" />
        </requestFiltering>
      </security>
    </system.webServer>
  </location>
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
          <!-- eg. https://www.demo.com/swagger [to] https://www.demo.com/web -->
          <match url="^swagger" />
          <action type="Redirect" url="https://{HTTP_HOST}/web" />
        </rule>
      </rules>
    </rewrite>
  </system.webServer>
<!-- 301重定向www. http://demo.com/ [to] http://www.demo.com/ -->
<!-- 添加网站 > 指定一个`空目录` > 填写名称并绑定 `demo.com` > 设置`Http重定向`=`http://www.demo.com/` > 重新启动。 -->
<!-- HTML代码实现重定向 index.html -->
<!DOCTYPE html><html><head><meta http-equiv="Refresh" content="0; URL=https://www.demo.com/" /></head><body></body></html>
<!DOCTYPE HTML><html><head><meta http-equiv="Refresh" content="0; URL=/web" /><script>window.location='/web'</script></head><body></body></html>
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


> `无法验证强名称签名` [`1.引用dll错误 ASP.Net Projects must disable shadow copy`](https://blog.csdn.net/aoshilang2249/article/details/78111409) `2.修改Web.config`
~~~xml
<configuration>
  <system.web>
    <!--不需要验证强名称签名-->
    <hostingEnvironment shadowCopyBinAssemblies="false" />
  </system.web>
</configuration>
~~~

> [`防止ASP.NET版本泄露`](https://docs.microsoft.com/en-us/dotnet/api/system.web.configuration.httpruntimesection.enableversionheader?redirectedfrom=MSDN&view=netframework-4.8#System_Web_Configuration_HttpRuntimeSection_EnableVersionHeader)
~~~xml
<configuration>
  <system.web>
    <!--防止ASP.NET版本泄露X-AspNet-Version-->
    <httpRuntime targetFramework="4.6.1" enableVersionHeader="false" />
  </system.web>
</configuration>
~~~

> `XSS跨站攻击漏洞`
~~~xml
<configuration>
  <system.webServer>
    <httpProtocol>
      <customHeaders>
        <!--XSS跨站漏洞-->
        <!--<remove name="Server" />--><!--https://learn.microsoft.com/zh-cn/archive/blogs/varunm/remove-unwanted-http-response-headers-->
        <remove name="X-Powered-By" />
        <remove name="X-AspNet-Version" />
        <add name="X-Frame-Options" value="SAMEORIGIN" />
        <add name="X-XSS-Protection" value="1; mode=block" />
        <add name="X-Content-Type-Options" value="nosniff" />
        <!--跨域访问漏洞[建议禁用]主要用于前后端分离的项目-->
        <!--<add name="Access-Control-Allow-Origin" value="http://www.example.com,https://www.example.com"/>-->
        <!--允许客户端携带跨域请求凭据Credentials例如Cookie,TLS客户端证书,授权标头-->
        <!--<add name="Access-Control-Allow-Credentials" value="false"/>-->
        <!--<add name="Access-Control-Allow-Headers" value="*, Accept, Access-Control-Allow-Origin, Content-Type, Content-Encoding, X-Powered-By" />-->
        <!--<add name="Access-Control-Allow-Methods" value="GET, POST, PUT, DELETE, OPTIONS" />-->
        <!--预检请求凭据有效期(秒)42天＝42×86400(天)防止过量的OPTIONS预检请求;-Expose-Headers让前端js可访问-->
        <!--<add name="Access-Control-Max-Age" value="86400" />-->
        <!--<add name="Access-Control-Expose-Headers" value="Expires,Last-Modified,X-Auth-Token,X-Request-Id" />-->

        <!--启用CSP后,不符合的外部资源就会被阻止加载-->
        <add name="Content-Security-Policy" value="script-src 'self' cdn.bootcdn.net cdnjs.cloudflare.com; style-src 'self' https: cdn.bootcdn.net cdnjs.cloudflare.com; img-src 'self' https:; media-src 'self' https:; connect-src https:; font-src https:; frame-src 'self'; object-src 'none';" />
      </customHeaders>
    </httpProtocol>
  </system.webServer>
</configuration>
~~~

> `程序集需要完全信任时`
~~~xml
<configuration>
  <system.web>
    <!-- 当在共享Web主机上时 -->
    <trust level="Full" />
  </system.web>
</configuration>
~~~

> `注册COM服务/ActiveX控件/互操作程序集`
~~~shell
cd /d %~dp0                 # 进入当前目录
RegSvr32 /s pZemsdkDemo.ocx # 注册COM服务/ActiveX控件
RegSvr32 /u pZemsdkDemo.ocx # 卸载ActiveX控件
~~~

> `IIS锁定是默认配置overrideModeDefault="Deny"`
~~~shell
C:\Windows\system32> inetsrv\appcmd unlock config -section:system.webServer/modules
C:\Windows\system32> inetsrv\appcmd unlock config -section:system.webServer/handlers
~~~

----

