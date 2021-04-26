# apache-tomcat配置 for jsp

> [`安装`](https://projects.apache.org/project.html?tomcat)


> `配置`
* 设置开发环境的字符集编码和虚拟机内存
~~~cmd
:: 系统环境变量
:: CATALINA_HOME D:\Program\apache-tomcat-8.5.65  ## https://projects.apache.org/project.html?tomcat
:: CLASSPATH     .;%JAVA_HOME%\lib\dt.jar:%JAVA_HOME%\lib\tools.jar;%CATALINA_HOME%\lib\servlet-api.jar;
:: JAVA_HOME     C:\Program Files (x86)\Java\jdk1.8.0_271
:: JAVA_BIN      %JAVA_HOME%\bin
:: JRE_HOME      %JAVA_HOME%\jre
:: JAVA_OPTS     -Xms512m -Xmx1024m -XX:PermSize=256M -Dfile.encoding=utf-8
:: M2_HOME       D:\Program\apache-maven-3.8.1
:: MAVEN_HOME    D:\Program\apache-maven-3.8.1
set JAVA_OPTS="-Xms512m -Xmx1024m -XX:PermSize=256M -Dfile.encoding=utf-8"
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

