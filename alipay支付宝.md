# 支付宝

#### 开发环境/开源SDK
 * Go语言
   * [github.com/smartwalle/alipay/v3 支持公钥证书和普通公钥方式](https://github.com/smartwalle/alipay)

#### 测试环境/沙箱环境
 - [沙箱环境(AppID获取+密钥设置+应用网关+回调地址)](https://openhome.alipay.com/platform/appDaily.htm)、[查看开发文档](https://opendocs.alipay.com/open/200/105311)
 - [1.0 密钥设置--OpenSSL生成密钥](https://opendocs.alipay.com/open/291/106130)
~~~bash
OpenSSL
> genrsa -out app_private_key.pem 2048 #生成"应用私钥";填入源代码中,跟应用APPID一一对应;不要泄露私钥;
> pkcs8 -topk8 -inform PEM -in app_private_key.pem -outform PEM -nocrypt -out app_private_key_pkcs8.pem #仅java需将私钥转成pkcs8格式
> rsa -in app_private_key.pem -pubout -out app_public_key.pem #生成普通"应用公钥"--处理格式：去除头尾换行空格，转成一行字符串;
> exit #登录开放平台，上传普通"应用公钥"并获取"支付宝公钥"。
~~~
 - [1.1 普通"公钥"方式--上传"应用公钥"并获取"支付宝公钥"](https://opendocs.alipay.com/open/291/105971)
```
应用私钥：MIIEogIBAAKCAQEAlmozX8gSXAKcBIcol5bLTPD1pGSRSzcNzMCG9oGNs96nNV7l0Rc3Kx8Oyw9lR28GINpRel4/GtdlbcxW1xL0lKwfqw4KGyB5j70a1R9hgcx5fl4u/A8vpUipA7opfE3lM8L8CsseHN5bfHgGCcgeSegghJ5ygh4p8z9iAkcURRxvjraudWEtSJiguSeE3Ovifj/6TeFVNpxHtNADpMhn77GjDFSulcO88vRA5Tc9V06QXJoPNtRygjDIGEpEAJjtwPbwNGIyqzjOojoGOYKUaISzpdIWyKikIjZYreE5bSnUn95yQaDZfDzuorVymDIfRzFqC8d9YZ/R01LJrCg/5wIDAQABAoIBACtxIMVZE3RfjJACOUcO1kiyjz+bjBsdG283a8NmR3bbp49SiS2KdvSNU8hx+d5Xwn1akI23CqLF8xVzHuGfJ+SIkdzlgSW0i2doRoenOJI0bCKDMS67dBdYlPfunGy6UqhQeFrlrxzHW8TnJVdN5PGTiVDEMm5CJ/uJItVlkgUjb26fqULlgaaTrOVzwIvedB6dCZIDnF4CdbLhO9s/NbldGxF30xP+aAxdKbHfKN3F8E23ZC3G5YgS/qRFGmcRPon9nVeRmQ2VrABmM7BZJwN2dR96eFN4fZkYuqSB+zS7Lk0lxDlMC/nZqfJKECxc5kLxBnaJ28BRZiFEPW2woYECgYEA2IevkvJglXG/DO7HTZbkwHnNa5mMfDgJAielW0hzX+/KUXj2/zRWldTGafuIET+/k6zMMK8kzuTJZepwgjcKXIJsV14nT0fWYQFJ0V4iRS7CvjIfcV68ypZQi+51xXJioSWjXt7aCJIZEPmpEi9GPblbNm7uAzqbRivn/F2GtHsCgYEAsdVErK5MfNekup5wJfd9Egsj5NgTTPZeNCrT5hT8ujJJSZaSpC8zpOqbCf787j5PZErbsXL6d+qK/56LONvLFU/nxAvpTCLqMng5uhHzk96wGRPWreGUMZlx+cvM1iJK8nHz3KZKGVQZbWds23Q2uDlXsoleiBSpkhwh5KbytIUCgYBY73I34wG0oCGeiDyoK8ANJnovJcRECSf6EJqkYZ+x2eW5jPu2WqLtq5VLVprOquZfG2xK2sU9jU8DY0WO1liVIqSpRezTbWgqM8NEEWv2CnzGbgPoJsdYVmEC+JC65n6IPdNaViIrvwY4qLK+21f4ZjeGpg1wmhPIwKPqTefUHQKBgC5Bsj5UjDLBCOk+Ax/tE0xZN3n0NnkDcJeTOFEVznNEV0nb78LjQES6fZ+JAxOZg58r1Z9/r+T3TjaVb9NXYKjngvq8um+CeXatTR64QqqI9zdesK3ECn8oUbxPJbXhb6tGts8DNi0GciLCD0+6F+2thME8+CjfbwhBZxOJ1YHdAoGAPLsHHLerlC3OvrteissgK333DA/9ij8LlOOJrIoH7eGXHQ/p9NgxD7tQPA9ELEWA4UytkkoceuuVduyOqbWL5CcsldcBJhG5LYWnvqZn76GVDDlYWv9HM8m1y8wIyRBWor0jqhLvmdK97LIDCZdmNTA9kJRkHsNIBHxW7h5jLKg=
应用公钥：MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlmozX8gSXAKcBIcol5bLTPD1pGSRSzcNzMCG9oGNs96nNV7l0Rc3Kx8Oyw9lR28GINpRel4/GtdlbcxW1xL0lKwfqw4KGyB5j70a1R9hgcx5fl4u/A8vpUipA7opfE3lM8L8CsseHN5bfHgGCcgeSegghJ5ygh4p8z9iAkcURRxvjraudWEtSJiguSeE3Ovifj/6TeFVNpxHtNADpMhn77GjDFSulcO88vRA5Tc9V06QXJoPNtRygjDIGEpEAJjtwPbwNGIyqzjOojoGOYKUaISzpdIWyKikIjZYreE5bSnUn95yQaDZfDzuorVymDIfRzFqC8d9YZ/R01LJrCg/5wIDAQAB
支付宝公钥：MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu+Ik9HVN5Y1znbp293JqrdupIaO+UJN/Co1boiNR5gq9wx0VzfxKAX0wl8f0WSHdGBgCV2MHNl0qn+MK/Ulw0u4GuKJW8ynsfJcsXLtYHwjG2sfuOXVb0/SnVDgL2pJq53DbMSDniS9N9Eh5Kki24yQ/X/OfFAhAO0ynH+FMNjcOq/bDInZepXlaWypaODbFf5Op63qiwQ3lXMa7otU3KiFJ0f5h44SO+FnUAtiTTjVvAUy4fpeO9vDG7ydbdw+e5U13+4VT+Mxr+Ez9ipgCuVGtPz7wfH5L0Ko8WqeAb/IrkhoAQ7K9jVE/pLdXjsUduHO5WVIdOWtilgL5+jxCBQIDAQAB
#普通调用方式(源代码)：应用APPID+应用私钥+支付宝公钥
```
 - [1.2 "公钥证书"方式](https://opendocs.alipay.com/open/291/105971)
```
企业开发者若涉及资金类支出接口接入，必须使用公钥证书模式。
公钥证书签名方式引入了 CA 机构对公钥持有者进行身份识别，保证该证书所属实体的真实性，以实现报文的抗抵赖。
#证书调用方式(源代码)：应用APPID+应用私钥+应用公钥+支付宝公钥+支付宝根证书
```
 - [1.3 配置应用网关与授权回调地址](https://openhome.alipay.com/platform/appDaily.htm)
 - [1.4 下载支付宝"沙箱版",安装后进行开发测试](https://sandbox.alipaydev.com/user/downloadApp.htm)

----



