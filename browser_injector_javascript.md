# 浏览器注入javascript

#### 浏览器插件

> [Install Chrome extension, inject Javascript into a webpage](https://chrome.google.com/webstore/detail/scripty-javascript-inject/milkbiaeapddfnpenedfgbfdacpbcbam)、[from scripty.abhisheksatre.com](https://scripty.abhisheksatre.com)

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
 * [国家药监局-抓取国产药品](http://app1.sfda.gov.cn/datasearchcnda/face3/base.jsp?tableId=25&tableName=TABLE25&title=%B9%FA%B2%FA%D2%A9%C6%B7&bcId=152904713761213296322795806604)
~~~javascript
(function(i) {
    var cb=function(id){
        request=new XMLHttpRequest();
        request.onreadystatechange=function(){
            if(request.readyState==4)
            {
                if(request.status==200)
                {
                    var res=request.responseText;
                    //console.log(res);
                    var t=res.substring(res.indexOf("<table "));
                    t = t.substring(0, t.indexOf("</table>")+8);
                    alert("服务器正常返回数据:国产药品:Id="+id+"  "+t);
                    request=null;
                }
                else
                {
                    alert("服务器未返回数据:国产药品:Id="+id)
                }
            }
        };
        request.open("GET","content.jsp?tableId=25&tableName=TABLE25&tableView=国产药品&Id="+id);
        request.setRequestHeader("Content-Type","text/html;encoding=gbk");
        request.send(null);
    };
    for(var id=1;id<=i;id++)cb(id);
})(1);
~~~