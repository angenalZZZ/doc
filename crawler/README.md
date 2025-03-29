# 抓取工具 crawler

#### 1. [`ejs`](https://github.com/angenalZZZ/doc-zip/blob/master/crawler-ejs.zip) based on [miniblink c++](https://github.com/weolar/miniblink49)、[miniblink c#](https://gitee.com/angenal/NetMiniblink)、[gowebui](https://github.com/selfplan/gowebui)、[blink-demo](https://github.com/raintean/blink-demo)
- [爬虫案例](https://scrape.center/)
- [Browse AI's powerful web scraping API](https://www.browse.ai/)
- [pip install requests scrapy](https://scrapy.org/)


#### 2. [`PhantomJS`](https://phantomjs.org/) is a headless web browser scriptable with [JavaScript](http://phantomjs.org/api/)
~~~bash
> phantomjs [options] example.js [arg1 [arg2 [...]]]
~~~
~~~js
phantom.outputEncoding = "gbk"; // 设置网页编码 (防止输出中文时出现乱码)

// webpage模块: PhantomJs的核心模块，用于网页操作，获取操作DOM或者web网页的对象，
// 通过它可以打开网页、接收网页内容、request、response参数等。
// 提供了一套可以访问和操作web文档的核心方法，包括操作DOM、事件捕获、用户事件模拟等。
var webPage = require('webpage'); // 加载模块
var page = webPage.create();  // 创建实例
page.settings.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537 (KHTML, like Gecko) Chrome/96 Safari/537 Edg/96';
page.open(url, settings, callback) // 访问网页
// url：访问的网页网址
// callback：网页被打开完时的回调函数
// method：默认为GET,也可指定为POST等方法
// data：HTTP请求-提交的数据
// settings：HTTP请求的配置对象
page.open(url, function (status) {
    if (status !== 'success') {
        console.log('Unable to access network');
    } else {
        var hello = page.evaluate(function () {
            return document.getElementById('hello').innerText;
        });
        console.log(hello);
    }
    phantom.exit();
}) 
page.open(url, method, callback) 
page.open(url, method, data, callback) 
page.onLoadStarted = function() {           // page.open开始事件callback
  var currentUrl = page.evaluate(function() { return window.location.href; });
  console.log('window.location：' + currentUrl + ' loading...');
};
page.onLoadFinished = function(status){};   // page.open完成事件callback
page.onAlert = function(msg) {};            // page.onAlert监听alert事件
page.onError = function(msg, trace) {};     // page.onError监听error事件
page.onUrlChanged = function(targetUrl) {}; // page.onUrlChanged监听URL进行跳转事件
page.onConsoleMessage = function(msg) {     // page.onConsoleMessage监听console语句事件
    console.log('console.log：'+ msg);
};
page.onResourceRequested = function(requestData, networkRequest) {
    // requestData {
    //  id：所请求资源的编号
    //  method：使用的HTTP方法
    //  url：所请求的资源URL
    //  time：一个包含请求时间的Date对象
    //  headers：HTTP头信息数组
    // networkRequest {
    //  bort()：终止当前的网络请求，这会导致调用onResourceError回调函数
    //  changeUrl(newUrl)：改变当前网络请求的URL
    //  setHeader(key, value)：设置HTTP头信息
  var mch = requestData.url.match(/old.js/g);
  if (mch != null) {
    console.log('Request (#' + requestData.id + '): ' + JSON.stringify(requestData));
    networkRequest.changeUrl('new.js');
  }
};
page.onResourceReceived = function(response) {
    // response {
    //  id：所请求的资源编号
    //  url：所请求的资源的URL r-time：包含HTTP回应时间的Date对象
    //  headers：HTTP头信息数组
    //  bodySize：解压缩后的收到的内容大小
    //  contentType：接到的内容种类
    //  redirectURL：重定向URL（如果有的话）
    //  stage：对于多数据块的HTTP回应，头一个数据块为start，最后一个数据块为end
    //  status：HTTP状态码，成功时为200
    //  statusText：HTTP状态信息，比如OK
  console.log('Response (#' + response.id + ', stage "' + response.stage + '"): ' + JSON.stringify(response));
};
page.onResourceError = function(resourceError) {
    console.log('Unable to load resource (#' + resourceError.id + 'URL:' + resourceError.url + ')');
    console.log('Error code: ' + resourceError.errorCode + '. Description: ' + resourceError.errorString);
};
require('webpage').create().open('https://www.baidu.com/', function(status) {
    console.log('Status: ' + status); // 打印success或fail
});
require('webpage').create().open('http://www.google.com/', 'POST', 'user=username&password=password', function(status) {
    console.log('Status: ' + status);
});
require('webpage').create().open('http://api.custom.com/', {
  operation: "POST",
  encoding: "utf8",
  headers: {
    "Content-Type": "application/json"
  },
  data: JSON.stringify({
    data: "data",
    list: ["custom", "data"]
  })
}, function(status) {
    console.log('Status: ' + status);
});
// page.evaluate方法用于打开网页后，在页面中执行js代码，如点击、滑动、翻页等
var page = require('webpage').create();
page.open('https://www.baidu.com/', function(status) {
    if (status !== 'success') {
        console.log('Unable to access network');
    } else {
      var title = page.evaluate(function(){ return document.title; });
      console.log(title);
    }
    phantom.exit();
});
// page.includeJs方法用于页面加载外部脚本，加载完成后可调用指定的回调函数
var page = require('webpage').create();
page.open('https://www.baidu.com/', function(status) {
    if (status !== 'success') {
        console.log('Unable to access network');
        phantom.exit();
    } else {
      page.includeJs('https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js', function() {
          page.evaluate(function () { $('.button').click(); });
          phantom.exit();
      });
    }
});
// render方法用于将网页保存成图片。该方法根据后缀名，将网页保存成不同的格式，如：PDF,PNG,JPEG,BMP,PPM,GIF
var page = require('webpage').create();
page.viewportSize = { width: 1920, height: 1080 }; // 浏览器窗口大小
page.zoomFactor = 0.25; // 使用25％缩放创建缩略图
page.open('https://www.baidu.com/', function start(status) {
  page.render('baidu.jpg', { format: 'jpeg', quality: '100' });
  phantom.exit();
});


// fs模块: 获取文件系统对象，通过它可以操作操作系统的文件操作，包括read、write、move、copy、delete等。
var fs = require('fs');

// system模块: 获得系统操作对象，包括命令行参数、phantomjs系统设置等。
var system = require('system');
system.args;

phantom.exit(); // 退出 PhantomJS (这一行不能少)
~~~


#### 3. [`Selenium`](https://selenium.dev/) [WebDriver](https://www.selenium.dev/downloads)+[Selenium IDE](https://www.selenium.dev/downloads)+[Selenium Grid](https://www.selenium.dev/downloads) & [Client & WebDriver Language(JavaScript,Java,C#,Python,Ruby)](https://www.selenium.dev/downloads) & [Document](https://www.selenium.dev/documentation/en/grid/grid_3/)

> [Install Selenium Server (Grid)](https://www.selenium.dev/downloads)
~~~bash
Step 1: Start the Hub 
# http://localhost:4444/grid/console
> java -jar selenium-server-standalone.jar -role hub -port 4444  # undefined configfile
> java -jar selenium-server-standalone.jar -role hub -debug  # print debug logs to console.
> java -jar selenium-server-standalone.jar -role hub -log log.txt  # specify a log file.
> java -jar selenium-server-standalone.jar -role hub -hubConfig hubConfig.json -debug

Step 2: Start the Nodes 
# If a port is not specified -port flag, a free port will be chosen.
# For both hub and node, if the -host flag is not specified, 0.0.0.0 will be used by default.
> java -jar selenium-server-standalone.jar -role node -hub http://localhost:4444  # undefined configfile
> java -jar selenium-server-standalone.jar -Dwebdriver.chrome.driver=chromedriver.exe -role node -nodeConfig nodeConfig.json
~~~




