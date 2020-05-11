# 浏览器注入javascript

#### 浏览器插件

> [Install Chrome extension, inject Javascript into a webpage](https://chrome.google.com/webstore/detail/scripty-javascript-inject/milkbiaeapddfnpenedfgbfdacpbcbam)、[scripty.abhisheksatre.com](https://scripty.abhisheksatre.com)
~~~javascript
// URL to QR Code
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

