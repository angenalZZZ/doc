# [HTTP specification](https://tools.ietf.org/html/rfc7230)

#### Request headers

~~~
Authorization: Bearer eyJhbGciOiJIUzII6IkpXVCJ9.eyJodHRwOi8vc2JjZHpnIn0.kRZsQ8gw0zOn0
Origin: [*-Origin-Host-Name-*]
Cookie: _ga=GA1.1.719053831.1554966534
Content-Type: application/vnd.ms-excel  [application/json]
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) \
            Chrome/80.0.3987.122 YaBrowser/20.3.0.1223 Yowser/2.5 Safari/537.36
Accept: */*
Sec-Fetch-Site: none
Sec-Fetch-Mode: cors
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh-TW;q=0.9,zh;q=0.8,en;q=0.7
~~~

#### Response headers

~~~
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked

Server: Kestrel
Status: 200 OK

Vary: Origin
Vary: Accept-Encoding, Accept, X-Requested-With
Strict-Transport-Security: max-age=31536000; includeSubdomains; preload
Set-Cookie: user_session=1OUjiNMkXZPGHlteIdQpWACqfgchWAqLqFFN44SXv1-_tXMn; \
            path=/; expires=Tue, 07 Apr 2020 01:15:43 GMT; secure; HttpOnly

Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: [*-Origin-Host-Name-*]

X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
X-GitHub-Request-Id: EE0A:452CE:3F6D51:5D1749:5E795F3E

Date: Tue, 17 Mar 2020 08:55:13 GMT
~~~

