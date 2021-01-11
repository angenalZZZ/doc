# 抓取工具 crawler

#### 1. [`ejs`](https://github.com/angenalZZZ/doc-zip/blob/master/crawler-ejs.zip) based on [miniblink c++](https://github.com/weolar/miniblink49)、[miniblink c#](https://gitee.com/angenal/NetMiniblink)、[gowebui](https://github.com/selfplan/gowebui)、[blink-demo](https://github.com/raintean/blink-demo)


#### 2. [`PhantomJS`](https://phantomjs.org/) is a headless web browser scriptable with [JavaScript](http://phantomjs.org/api/)
    phantomjs [options] example.js [arg1 [arg2 [...]]]
~~~bash
// 参考: https://www.jianshu.com/p/1530061334a3
phantom.outputEncoding = "gbk"; // 设置网页编码 (防止输出中文时出现乱码)

// webpage模块: PhantomJs的核心模块，用于网页操作，获取操作DOM或者web网页的对象，
// 通过它可以打开网页、接收网页内容、request、response参数等。
// 提供了一套可以访问和操作web文档的核心方法，包括操作DOM、事件捕获、用户事件模拟等。
var webPage = require('webpage'); // 加载模块
var page = webPage.create();  // 创建实例
// url：将要被打开的网页网址  
// callback：网页被彻底打开完时的回调函数
// method：指定HTPP的方法，默认为GET，也可指定为POST方法等
// data：指定该方法所要使用的数据
// settings：HTTP配置对象
page.open(url, callback) {}
page.open(url, method, callback) {}
page.open(url, method, data, callback) {}
page.open(url, settings, callback) {}

require('webpage').create().open('https://www.baidu.com/', function (status) {
    console.log('Status: ' + status); // 打印success或fail
    phantom.exit();
});

require('webpage').create().open('http://www.google.com/', 'POST', 'user=username&password=password', function(status) {
  console.log('Status: ' + status);
});

require('webpage').create().open('http://your.custom.api', {
  operation: "POST",
  encoding: "utf8",
  headers: {
    "Content-Type": "application/json"
  },
  data: JSON.stringify({
    some: "data",
    another: ["custom", "data"]
  })
}, function(status) {
  console.log('Status: ' + status);
});

//evaluate方法用于打开网页以后，在页面中执行JavaScript代码，在所加载的webpage内执行该函数，像翻页、点击、滑动等。
require('webpage').create().open('https://www.baidu.com/', function () {
    var title = page.evaluate(function(){ return document.title; });
    console.log('Page title is ' + title);
    phantom.exit();
});


// fs模块: 获取文件系统对象，通过它可以操作操作系统的文件操作，包括read、write、move、copy、delete等。
var fs = require('fs');

// system模块: 获得系统操作对象，包括命令行参数、phantomjs系统设置等。
var system = require('system');
system.args;

phantom.exit(); // 退出 PhantomJS (这一行不能少)
~~~


