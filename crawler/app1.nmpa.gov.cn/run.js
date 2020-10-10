(function () {
    // create a mask layer
    let id0 = 'script-20200529';
    if (document.getElementById(id0)) return;
    let div0 = document.createElement('div');
    div0.id = id0;
    div0.style = 'background-color:rgba(0,0,0,0.5);position:fixed;z-index:999999;top:0;left:0;text-align:center;right:0;padding-top:calc(50vh-100px);bottom:0;width:1265px;height:719px;overflow:auto';
    document.body.append(div0);
    div0 = document.getElementById(id0);
    // create a show text layer
    let loading = document.createElement('div');
    let loadHtml = function (txt, add) { if (add) loading.innerHTML += txt; else loading.innerHTML = txt; };
    loadHtml('Loading...', false);
    loading.style = 'position:absolute;z-index:1;top:20px;left:20px;color:#fff;font-size:16px;font-weight:bold;cursor:default';
    div0.append(loading);
    // create a close button
    let div1 = document.createElement('div');
    div1.style = 'position:absolute;z-index:2;top:50%;left:50%';
    div0.append(div1);
    let btn1 = document.createElement('button');
    btn1.style = 'position:fixed;z-index:2;top:1px;right:1px;color:#f39;font-size:16px;font-weight:bold;padding:5px';
    btn1.innerText = 'Close';
    btn1.addEventListener('click', async () => await BlinkFunc.CloseWebPage());
    div0.append(btn1);

    // create ajax request
    let getItemById = function (id, idMax, fn0, fn1) {
        let xhr = new XMLHttpRequest();
        xhr.timeout = 3000;
        xhr.ontimeout = function () { alert(`请求超时 Id=${id} (${(xhr.timeout/1000)}s)`); };
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    let t = xhr.responseText;
                    t = t.substring(t.indexOf("<table "));
                    t = t.substring(0, t.indexOf("</table>") + 8);
                    fn0(id, t);
                } else {
                    fn1(id, xhr.statusText);
                }
                if (id++ <= idMax) {
                    getItemById(id, idMax, fn0, fn1);
                }
            }
        };
        xhr.open("GET", "content.jsp?tableId=25&tableName=TABLE25&tableView=国产药品&Id=" + id);
        xhr.setRequestHeader("Content-Type", "text/html;encoding=gbk");
        xhr.send();
    };

    // do ajax request
    getItemById(2, 3, function (id, t) {
        loadHtml(`<p style="color:#3e3">成功: 国产药品: Id=${id} </p>`, id > 2);
    }, function (id, t) {
        loadHtml(`<p style="color:#e39">失败: 国产药品: Id=${id} <b>${t}</b></p>`, id > 2);
    });
})();