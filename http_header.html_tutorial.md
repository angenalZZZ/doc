# [HTTP specification](https://tools.ietf.org/html/rfc7230)

#### Request headers
```
Authorization: Bearer eyJhbGciOiJIUzII6IkpXVCJ9.eyJodHRwOi8vc2JjZHpnIn0.kRZsQ8gw0zOn0
Origin: www.xxx.com   # 请求来源 [*-Origin-Host-Name-*]
Cookie: _ga=GA1.1.719053831.1554966534
Content-Type: application/vnd.ms-excel  [application/json]
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) \
            Chrome/80.0.3987.122 YaBrowser/20.3.0.1223 Yowser/2.5 Safari/537.36
 # "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36"
Accept: */*
Sec-Fetch-Site: none
Sec-Fetch-Mode: cors
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh-TW;q=0.9,zh;q=0.8,en;q=0.7
```

#### Request data

> 通过网址:Route参数+Query参数+Body数据+Form表单提交

Parameter             | Variable
---                   |---
`k=m&k=n`             | `map[k:n]`                   → k=`"n"`
`k1=m&k2=n`           | `map[k1:m k2:n]`             → k1=`"m"` k2=`"n"`
`k[]=m&k[]=n`         | `map[k:[m n]]`               → k=`["m","n"]`
`k[a][]=m&k[a][]=n`   | `map[k:map[a:[m n]]]`        → k=`{"a":["m","n"]}`
`k[a]=m&k[b]=n`       | `map[k:map[a:m b:n]]`        → k=`{"a":"m","b":"n"}`
`k[a][a]=m&k[a][b]=n` | `map[k:map[a:map[a:m b:n]]]` → k=`{"a":{"a":"m","b":"n"}}`
`k=m&k[a]=n`          | `error`                      → k~`无法识别`



#### Response headers
```text
Content-Type: text/plain; charset=utf-8  # HTTP 输出的数据类型和字符编码
# Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked

Server: Kestrel  # HTTP Web服务器名称
Status: 200 OK   # HTTP 状态码

Vary: Origin
Vary: Accept-Encoding, Accept, X-Requested-With
Strict-Transport-Security: max-age=31536000; includeSubdomains; preload
Set-Cookie: user_session=1OUjiNMkXZPGHlteIdQpWACqfgchWAqLqFFN44SXv1-_tXMn; \
            path=/; expires=Tue, 07 Apr 2020 01:15:43 GMT; secure; HttpOnly

Access-Control-Allow-Credentials: true # 允许安全证书
Access-Control-Allow-Headers: Origin,Content-Type,Accept,User-Agent,Cookie,Authorization,X-Auth-Token,X-Requested-With,X-Request-Id
Access-Control-Allow-Methods: GET,PUT,POST,DELETE,PATCH,HEAD,CONNECT,OPTIONS,TRACE
Access-Control-Allow-Origin: *    # 请求来源网址 [*-Origin-Host-Name-*]
Access-Control-Max-Age: 3628800   # 预检请求有效期（秒） 42天（42×86400(天)）

X-Content-Type-Options: nosniff   # 开启*内容保护
X-XSS-Protection: 1; mode=block   # 开启*XSS*保护
X-Frame-Options: SAMEORIGIN       # 相同域名下*才允许用iframe加载网页
X-Request-Id: EE0A:452CE:3F6D51:5D1749:5E795F3E  # 防止*重放攻击

Date: Tue, 17 Mar 2020 08:55:13 GMT
```

#### Response data


# [HTML tutorial](https://www.runoob.com/html/html-tutorial.html)

~~~html
<!DOCTYPE html>
<html>
<script type="text/javascript" >//<![CDATA[
si_ST=new Date
//]]></script>
<head>
    <meta charset="UTF-8">
    <!-- <meta content="text/html; charset=utf-8" http-equiv="content-type"> -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex,nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no">
    <meta name="theme-color" content="#4F4F4F">

    <!-- Search Engine Settings -->
    <title>网页标题</title>
    <meta name="description" content="网页描述">
    <meta name="keywords" content="关键词">
    <meta name="author" content="网站名">
    <meta name="apple-itunes-app" content="app-id=1477376905">
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="网站名">
    <link rel="dns-prefetch" href="https://github.githubassets.com">
    <link rel="dns-prefetch" href="https://avatar.githubusercontent.com">
    <link rel="dns-prefetch" href="https://images.githubusercontent.com">

    <!-- Favicon Icon -->
    <link rel="shortcut icon" href="https://github.githubassets.com/favicons/favicon.ico">
    <link rel="alternate icon" type="image/png" href="https://github.githubassets.com/favicons/favicon.png">
    <link rel="icon" type="image/png" href="https://github.githubassets.com/favicons/favicon.png">
    <link rel="icon" type="image/svg+xml" href="https://github.githubassets.com/favicons/favicon.svg">
    <link rel="mask-icon" color="#000000" href="https://github.githubassets.com/favicons/pinned-octocat.svg">
    <link rel="fluid-icon" href="https://github.githubassets.com/favicons/fluidicon.png" title="网站名">
    <link rel="assets" href="https://github.githubassets.com/">
    <link rel="manifest" href="/manifest.json" crossOrigin="use-credentials">

    <meta name="request-id" content="7B80:19E4:1DAC41F:286CB30:5F50D10B" data-pjax-transient="true">
    <meta name="html-safe-nonce" content="c65b5fdbe6dc5d513ee96d378c084ca168d26166" data-pjax-transient="true">
    <meta name="visitor-payload" content="eyJyZWZlcnJlciI6Imh0dHBzOi8vZ2l0aHViLm==" data-pjax-transient="true">
    <meta name="visitor-hmac" content="416e097200a3517d05a17f56d3e5e175ccc1a277407" data-pjax-transient="true">
    <meta name="cookie-consent-required" content="false">
    <meta name="google-site-verification" content="K2HIVF635l">
    <meta name="google-analytics" content="UA-3769691-2">
    <meta name="userId" content="4f6c9e73602f087580151869b0be93d2" class="js-ga-set">
    <meta name="user-login" content="angenal">
    <meta name="hostname" content="github.com">
    <meta name="enabled-features" content="MARKETPLACE_PENDING_INSTALLATIONS,JS_HTTP_CACHE_HEADERS">

    <script type="text/javascript" crossorigin="anonymous" src="/rs/nj/SaARcujqfMTKslsX8RYX1fR5N7Q.js">
    
    
~~~

