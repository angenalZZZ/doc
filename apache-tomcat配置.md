# apache-tomcat配置 for jsp

> [`安装`](https://projects.apache.org/project.html?tomcat)


> `配置`
* 设置开发环境的字符集编码和虚拟机内存
~~~cmd
:: 系统环境变量
set JAVA_OPTS="-Dfile.encoding=utf-8 -Xms512m -Xmx1024m -XX:PermSize=256M -XX:MaxPermSize=2"
:: 或修改 bin/catalina.bat
set "JAVA_OPTS=%JAVA_OPTS% %JSSE_OPTS% -Dfile.encoding=utf-8 -Xms512m -Xmx1024m -XX:PermSize=256M -XX:MaxPermSize=2"
~~~
* 启动时隐藏CMD窗口
~~~cmd
:: 修改 bin/setclasspath.bat
set _RUNJAVA="%JRE_HOME%\bin\javaw.exe"
~~~
* 启动tomcat服务
~~~cmd
%CATALINA_HOME%\bin\startup.bat
%CATALINA_HOME%\bin\shutdown.bat
~~~
* 安装tomcat服务
~~~cmd
CD %CATALINA_HOME%\bin
service.bat install
:: service.bat uninstall
~~~

