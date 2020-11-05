# 支付宝

#### 测试环境/沙箱环境
 - [沙箱环境](https://openhome.alipay.com/platform/appDaily.htm)、[开发文档](https://opendocs.alipay.com/open/200/105311)
 - [密钥设置-OpenSSL生成密钥](https://opendocs.alipay.com/open/291/106130)、[获取支付宝公钥](https://opendocs.alipay.com/open/291/105971)
~~~bash
OpenSSL
> genrsa -out app_private_key.pem 2048 #生成"应用私钥"--私钥填入源代码中
> pkcs8 -topk8 -inform PEM -in app_private_key.pem -outform PEM -nocrypt -out app_private_key_pkcs8.pem #仅Java需将私钥转成PKCS8格式
> rsa -in app_private_key.pem -pubout -out app_public_key.pem #生成"应用公钥"--处理格式：去除头尾换行空格，转成一行字符串
> exit #登录开放平台上传"应用公钥"并获取"支付宝公钥"--然后处理格式。
~~~


