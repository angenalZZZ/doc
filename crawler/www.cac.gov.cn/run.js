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
    var urlItems = [];
    let getItemById = function (id, idMax, fn0, fn1, fn2) {
        // alert($);
        var channelCode = 'A0905';
        var width = '', height = '';

        var replaceStyle = "<li class='list-item'><i></i><a href='{链接URL}' target='_blank'>{主题}</a><span>{发布年份}-{发布月份}-{发布日}</span></li>"; 
        $.ajax({
            type: 'POST',
            url: '/cms/JsonList',
            data: {channelCode:channelCode,perPage:'40',pageno:id},
            dataType: 'json',
            success: function(data){
                // alert(data.totalRec);
                var listhtml = "";
                $.each(data.list,function(i,item){
                    var infostr = replaceStyle;
                    var topic = item.topic;
                    var longtopic = item.topic;
                    if(topic.length>120) topic = topic.substring(0,120);
                    var pubtime = item.pubtime;
                    var filltime = item.filltime;
                    var infourl = item.infourl; urlItems.push(infourl);
                    var coverurl = item.coverurl;
                    var description = item.description;
                    if(coverurl==""){
                    }else{
                        coverurl = "<img border=0 src='"+coverurl+"' width='"+width+"' height='"+height+"' >";
                    }
                    infostr = infostr.replace("{信息封面|"+width+"~"+height+"}",coverurl);
                    infostr = infostr.replace(/{链接URL}/g,infourl);
                    infostr = infostr.replace(/{主题}/g,topic);
                    infostr = infostr.replace(/{摘要}/g,description);
                    infostr = infostr.replace(/{长标题}/g,longtopic);
                    infostr = infostr.replace(/{发布年份}/g,pubtime.substring("0","4"));
                    infostr = infostr.replace(/{发布月份}/g,pubtime.substring("5","7"));
                    infostr = infostr.replace(/{发布日}/g,pubtime.substring("8","10"));
                    infostr = infostr.replace(/{发布时间}/g,pubtime);
                    listhtml = listhtml + infostr;
                });
                // $("#loadingInfoPage").html(listhtml);
                fn0(id, listhtml);

                // 循环下一页
                if (id++ <= idMax) {
                    getItemById(id, idMax, fn0, fn1, fn2);
                } else {
                    fn2(); // 结束循环
                }
            },
            error: function(xhr, type){
                fn1(id, xhr.statusText);
            }
        });
    };
    let getItemContentByUrl = function (url, cb) {
        $.get(url, function (html, status) {
            // alert(htm);
            let s = html.substring(html.indexOf('<div class="main">'));
            s = s.substring(0, s.indexOf('<div id="check">'));
            s = jQuery(s).find('#content').html();
            cb(s);
        });
    };

    // do ajax request
    getItemById(1, 3, function (id, t) {
        loadHtml(`<p style="color:#3e3">抓取成功: pagenum: ${id} </p><p><ul style="background:#ddd">${t}</ul></p>`, id > 1);
    }, function (id, t) {
        loadHtml(`<p style="color:#e39">抓取失败: pagenum: ${id} <b>${t}</b></p>`, id > 1);
    }, function () {
        if (urlItems.length == 0) return;
        let url = urlItems[0];
        // alert(url);
        getItemContentByUrl(url, function (htm) {
            loadHtml(`<p style="color:#3e3">抓取第一条内容页(1/${urlItems.length}): ${url} </p><p><div style="background:#ddd">${htm}</div></p>`, true);
        });
    });
})();