# 浏览器注入javascript

#### 浏览器插件

> [Install Chrome extension to inject Javascript into a webpage](https://chrome.google.com/webstore/detail/scripty-javascript-inject/milkbiaeapddfnpenedfgbfdacpbcbam)、[scripty.abhisheksatre.com](https://scripty.abhisheksatre.com)

 * [URL to QR Code](qrserver.com)
~~~javascript
(function() {
    var id = 'scripty-qr';
    if (!document.getElementById(id)) {
        var code = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' + encodeURIComponent(window.location.href);
        var div = document.createElement('div');
        div.id = id;
        div.style = `background-color: rgba(0, 0, 0, 0.9); position: fixed; top: 0px; left: 0px; text-align: center; right: 0px; padding-top: calc(50vh - 100px); bottom: 0px;`;
        var loading = document.createElement('div');
        loading.textContent = 'Loading...';
        loading.style = `position: absolute; top: 50%; left:50%; color: #FFF; font-size: 18px;`;
        div.append(loading);
        var img = document.createElement('img');
        img.src = code;
        img.onload = function(){loading.remove();};
        div.append(img);
        div.addEventListener('click', function(){
           div.remove(); 
        });
        document.body.append(div);
    }
})();
~~~
 * [国家药监局-抓取国产药品](http://app1.nmpa.gov.cn/datasearchcnda/face3/base.jsp?tableId=25&tableName=TABLE25&title=%B9%FA%B2%FA%D2%A9%C6%B7&bcId=152904713761213296322795806604)
~~~javascript
(function () {
    // create a mask layer
    var id = 'script-20200529';
    if (document.getElementById(id)) return;
    var div = document.createElement('div');
    div.id = id;
    div.style = `background-color:rgba(0,0,0,0.5);position:fixed;z-index:999999;top:0;left:0;text-align:center;right:0;padding-top:calc(50vh-100px);bottom:0`;
    document.body.append(div);
    div = document.getElementById(id);

    // create a show text layer
    var loading = document.createElement('div');
    loading.textContent = 'Loading...';
    loading.style = `position:absolute;top:20px;left:20px;color:#fff;font-size:16px;font-weight:bold;cursor:default`;
    div.append(loading);
    var setContent = function (txt, add) { if (add) loading.innerHTML += txt; else loading.innerHTML = txt; };

    // create ajax request
    var getItemById = function (id, idMax, fn0, fn1) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function () {
            if (request.readyState == 4) {
                if (request.status == 200) {
                    var t = request.responseText;
                    t = t.substring(t.indexOf("<table "));
                    t = t.substring(0, t.indexOf("</table>") + 8);
                    fn0(id, t);
                } else {
                    fn1(id, request.responseText);
                }
                if (id < idMax) {
                    getItemById(id + 1, idMax, fn0, fn1);
                }
            }
        };
        request.open("GET", "content.jsp?tableId=25&tableName=TABLE25&tableView=国产药品&Id=" + id);
        request.setRequestHeader("Content-Type", "text/html;encoding=gbk");
        request.send(null);
    };

    // do ajax request
    getItemById(1, 3, function (id, t) {
        setContent('<p style="color:#3f9">成功: 国产药品: Id=' + id + '</p>', id > 1);
    }, function (t) {
        setContent('<p style="color:#f93">失败: 国产药品: Id=' + id + '</p>', id > 1);
    });


    // double click two times, hide div.
    var clickTimes = 0; div.addEventListener('dblclick', function () { if (clickTimes++ >= 2) div.remove(); });
})();
~~~
