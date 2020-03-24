# [HTTP specification](https://tools.ietf.org/html/rfc7230)

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

