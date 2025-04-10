# 证书

[`安装证书`](#安装证书)

#### 获取证书 [亚洲诚信/TrustAsia`DigiCert`](https://www.trustasia.com/guide)、[天威诚信`DigiCert`](https://www.itrus.cn/product.html)、[安信证书/AnTrust`Geotrust`](https://www.anxinssl.com/geotrust/)、[沃通WoTrus](https://www.wosign.com/price.htm)
> [SSL工具/在线转换格式](https://tools.imtrust.cn)、[SSL工具/证书分析/下载中间证书](https://www.myssl.cn/tools/downloadchain.html)

```
证书：           CA根证书(服务器身份验证)                               # apiserver.crt <=> apiserver.key
*版本            V1
*颁发者          acme                                                 # CN = acme
*使用者          acme-apiserver                                       # CN = acme-apiserver
*公钥            RSA (2048 Bits)
*公钥参数         05 00
*增强型密钥用法   服务器身份验证 (1.3.6.1.5.5.7.3.1)
*使用者可选名称   DNS Name=localhost \ DNS Name=host.acme.internal \
                 IP Address=0.0.0.0 \ IP Address=10.96.0.1 \ IP Address=192.168.65.3 \ IP Address=127.0.0.1
*密钥用法         Digital Signature, Key Encipherment, Certificate Signing (a4) #CA已认证$
                 #self.sign-> Digital Signature, Key Encipherment (a0) #自签名,未经CA认证$
*基本约束         Subject Type=CA \ Path Length Constraint=None
*指纹             a79be724538b668fa817e8578d6a8078337fd3ad

OV证书：显示组织
  路径： Certum Trusted Network CA        # CA根证书
            UCA Global G2 Root            # 根证书(证书链信息)
                SHECA OV Server CA G5      # 中间证书(证书链)
                      *.yourdomain.com      # 服务器SSL证书
EV证书：显示组织单位
  层次： DigiCert Global Root CA       # CA根证书
             GeoTrust CN RSA CA G1     # 中间证书(证书链)
                 *.yourdomain.com       # 服务器SSL证书

Let’s Encrypt E6 <=Certificate=> signed by ISRG Root X2 <==> https://letsencrypt.org/certs/2024/e6.pem
Subject: O = Let's Encrypt, CN = E6
Key type: ECDSA P-384
```

> `证书密钥常用后缀`
```
  证书(Certificate)：.cer (windows),  .crt 
  私钥(Private Key)：.key (windows) 
  证书签名请求(Certificate Sign Request)：.csr 

  至于pem和der是编码方式, 以上三类均可用以下两种编码方式：
  pem  base64编码 Linux 工具通常使用 base64 编码的文本格式
  der  二进制编码

  Windows IIS 下的数字证书格式一般为 .pfx
  Java Tomcat 下的数字证书格式一般为 .jks 或 .store
  Apache 和 Nginx 一般是 .pem
```

> [`SSH 远程登录Linux 软件操作指南`](https://cloud.tencent.com/document/product/1207/44578)

> [`SSH for Connect to GitHub Help`](https://help.github.com/en/articles/connecting-to-github-with-ssh)

> [安全便捷的证书申请和管理工具`KeyManager`](https://keymanager.org)`推荐`，`SSL免费证书`提供机构比较多，如：
0. `永久免费HTTPS证书` : https://freessl.cn
1. `腾讯云DV SSL 证书` : https://cloud.tencent.com/product/ssl
2. `Let’s Encrypt` : https://letsencrypt.org/
4. `CloudFlare SSL` : https://www.cloudflare.com/
4. `StartSSL` : https://www.startcomca.com/
5. `Wosign沃通SSL` : https://www.wosign.com/
6. `loovit.net AlphaSSL` : https://www.lowendtalk.com/entry/register?Target=discussion%2Fcomment%2F2306096


# 获取 SSL/TLS 证书

您可通过以下两种方式获取相关 SSL/TLS 证书：

1. 自签名证书：即使用自己签发的证书，由于自签名证书存在较多的安全隐患，因此只建议用于测试验证环境。
2. 申请或购买证书：您可以向 [Let's Encrypt](https://letsencrypt.org/zh-cn/) 或华为云、腾讯云等云厂商申请免费证书，也可以向 [DigiCert](https://www.digicert.com/) 等机构购买收费证书。对于企业级用户，一般建议申请收费的 OV 及以上类型的证书，以获取更高等级的安全保护。

本页介绍了如何创建自签名 Certificate Authority (CA) 证书并签发服务器和客户端证书的操作步骤。

## 创建自签名 CA 证书

:::tip 前置准备

已安装 [OpenSSL](https://www.openssl.org/)。

:::

1. 运行以下命令生成密钥对，该命令随即会提示您输入密钥保护密码，后续在生成、签发、验证证书时均需要此密码。请妥善相关密钥及密码。

```bash
openssl genrsa -des3 -out rootCA.key 2048
```

2. 运行以下命令通过密钥对中的私有密钥生成 CA 证书，该命令随即会提示您设置证书的唯一标识名称 DN（Distinguished Name）。

```bash
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.crt
```

## 签发服务器证书

使用 CA 证书来签发服务器证书，用于验证服务器所有者的身份，服务器证书通常颁发给主机名、服务器名称或域名（如 www.ssl.com, localhot）。我们需要 CA 密钥（rootCA.key）、CA 证书（ rootCA.crt）和服务端 CSR （server.csr）生成服务器证书。

1. 运行以下命令生成服务器证书密钥对：

```bash
openssl genrsa -out server.key 2048
```

2. 运行以下命令使用 Server 密钥对制作 CSR。经 CA 根证书私钥签名后，CSR 可生成颁发给用户的证书公钥文件。该命令随即也会要求设置证书的唯一标识名称。

```bash
openssl req -new -key server.key -out server.csr
```

  系统将提示以下信息，对应的含义如下：

  ```bash
  You are about to be asked to enter information that will be incorporated
  into your certificate request.
  What you are about to enter is what is called a Distinguished Name or a DN.
  There are quite a few fields but you can leave some blank
  For some fields there will be a default value,
  If you enter '.', the field will be left blank.
  -----
  Country Name (2 letter code) [AU]: # 国家/地区
  State or Province Name (full name) [Some-State]: # 省/市
  Locality Name (eg, city) []: # 城市
  Organization Name (eg, company) [Internet Widgits Pty Ltd]: # 组织机构（或公司名），如 EMQ
  Organizational Unit Name (eg, section) []: # 机构部门，如 EMQX
  Common Name (e.g. server FQDN or YOUR name) []: # 通用名称，此处应当设置为服务器域名如 mqtt.emqx.com
  ...
  ```

3. 使用 CSR 生成服务器证书，此时也可指定证书的有效天数，此处为 365 天：

  ```bash
  openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -days 365
  ```

至此您就得到了一组证书。

```bash
.
├── rootCA.crt
├── rootCA.key
├── rootCA.srl
├── server.crt
├── server.csr
└── server.key
```

## 签发客户端证书

签发客户端证书的步骤与签发服务器证书类似，只是在生成 CSR 时，需要将 Common Name 设置为客户端的唯一标识，如用户名、客户端 ID 等。

客户端证书与服务端证书使用相同的 CA 证书签名，因此客户端证书也可以使用上述 CA 证书签名。


#### [安装证书](https://cloud.tencent.com/document/product/400/4143)
- [证书部署使用指南`沃通WoTrus`](https://www.wosign.com/Docdownload/)
  - [Apache SSL 证书申请部署指南](https://www.wosign.com/Docdownload/Apache_csr证书部署指南.pdf)
  - [IIS SSL 证书申请部署指南](https://www.wosign.com/Docdownload/IIS8.0_csr证书安装指南.pdf)
  - [Nginx SSL 证书申请部署指南](https://www.wosign.com/Docdownload/Nginx_csr证书部署指南.pdf)
  - [Tomcat SSL 证书申请部署指南](https://www.wosign.com/Docdownload/Tomcat_csr证书部署指南.pdf)

<table>
<tbody><tr>
<th>证书类型</th>
<th>服务器系统</th>
<th>证书安装方式</th>
</tr>
<tr>
<td rowspan="9">国际标准证书</td>
<td rowspan="7">Linux 系统</td>
<td>
  [宝塔面板 SSL 证书安装](https://cloud.tencent.com/document/product/400/50874)
</td>
</tr>
<tr><td> [Apache 服务器证书安装](https://cloud.tencent.com/document/product/400/35243) </td></tr>
<tr>
<td> [Nginx 服务器证书安装](https://cloud.tencent.com/document/product/400/35244) </td>
</tr>
<tr>
<td> [Tomcat 服务器证书安装](https://cloud.tencent.com/document/product/400/35224) </td>
</tr>
<tr>
<td> [GlassFish 服务器证书安装](https://cloud.tencent.com/document/product/400/44759) </td>
</tr>
<tr>
<td> [JBoss 服务器证书安装](https://cloud.tencent.com/document/product/400/44760) </td>
</tr>
<tr>
<td> [Jetty 服务器证书安装](https://cloud.tencent.com/document/product/400/44761) </td>
</tr>
<tr>
<td rowspan="2">Windows 系统</td>
<td> [IIS 服务器证书安装](https://cloud.tencent.com/document/product/400/35225) </td>
</tr>
<tr>
<td> [Weblogic 服务器证书安装](https://cloud.tencent.com/document/product/400/47358) </td>
</tr>
<tr>
<td rowspan="3">国密标准证书</td>
<td rowspan="2">Linux 系统</td>
<td> [Apache 服务器国密证书安装](https://cloud.tencent.com/document/product/400/47359) </td>
</tr>
<tr>
<td> [Nginx For Linux 国密证书安装](https://cloud.tencent.com/document/product/400/47360) </td>
</tr>
<tr>
<td>Windows 系统</td>
<td> [Nginx For Windows 服务器国密证书安装](https://cloud.tencent.com/document/product/400/47361) </td>
</tr>
</tbody></table>

~~~bash
#####安装.证书链信息.####
##打开：证书管理(本地计算机)-控制台.msc 分别导入指定的存储区。
##_.*.*_zheng_shu_lian.cer##
-----BEGIN CERTIFICATE-----
MIIFnTCCA4WgAwIBAgIQWdOdl..# CA根证书(全球少数根服务商)
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFvzCCBKegAwIBAgIRAOXkc..# 根证书(证书链:本国根服务商)
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDuzCCAqOgAwIBAgIDBETAM..# 中间证书(证书链:中间服务商) 如：Let’s Encrypt
-----END CERTIFICATE-----
~~~

 - `合并证书`或`证书链`(用于HAProxy等WEB中间件)
~~~
sudo cat /etc/letsencrypt/live/*.ddns.net/fullchain.pem \
  /etc/letsencrypt/live/*.ddns.net/privkey.pem \
  | sudo tee /app/cert/haproxy/*.ddns.net.pem

~~~

 - [Let’s Encrypt 免费证书/`E6`,`R11`:`Subject`设定: Root CAs + Subordinate (Intermediate) CAs + Chains](https://letsencrypt.org/certificates)
 - [Let’s Encrypt 免费证书/GUI manage free automated https certificates](https://certifytheweb.com/)
 - [Let’s Encrypt 免费证书/lego](https://go-acme.github.io/lego/usage/cli/examples/)
~~~bash
$ lego --email="foo@bar.com" --domains="example.com" --http run   # 获取证书 ACME v2 版本支持申请通配符证书了
$ AWS_REGION=us-east-1 AWS_ACCESS_KEY_ID=my_id AWS_SECRET_ACCESS_KEY=my_key \
$ lego --email="foo@bar.com" --domains="example.com" --dns="route53" run # 获取证书时使用AWS/DNS
$ lego --email="foo@bar.com" --http --csr=/path/to/csr.pem run # 获取给定由其他内容生成的证书签名请求(CSR)的证书
$ lego --email="foo@bar.com" --domains="example.com" --http renew # 续订证书
$ lego --email="foo@bar.com" --domains="example.com" --http renew --days 45 # 证书在45天内过期时续订证书
$ lego --email="foo@bar.com" --domains="example.com" --http renew --renew-hook="./myscript.sh" # 续订证书(钩子)
~~~
 - [Let’s Encrypt 免费证书/自动化脚本getssl](https://github.com/srvrco/getssl)
~~~bash
$ wget https://raw.githubusercontent.com/srvrco/getssl/master/getssl && chmod 700 getssl  # 下载getssl工具
$ ./getssl -c yourdomain.com               # init email account
$ getssl yourdomain.com                    # run ssl service
$ crontab                                  # auto reboot cron
23  5 * * * /root/scripts/getssl -u -a -q  # auto update config
~~~
 - [Let’s Encrypt 免费证书/自动化工具certbot](https://certbot.eff.org)、[自动续期证书](https://github.com/ywdblog/certbot-letencrypt-wildcardcertificates-alydns-au)
~~~bash
$ sudo add-apt-repository universe  # sudo apt-get update & sudo apt-get install software-properties-common
$ sudo add-apt-repository ppa:certbot/certbot
$ sudo apt-get update
$ sudo apt-get install certbot

$ certbot certonly --standalone -d 申请域名 --staple-ocsp -m 邮箱地址 --agree-tos  # 默认有效期为3个月
# /etc/letsencrypt/***/fullchain.pem, privkey.pem         # 生产证书(fullchain.pem, privkey.pem)
0 0 * * * certbot renew --quiet --renew-hook "kill -SIGUSR1 $(pidof 进程名称)" # 使用crontab自动续期

# certbot-auto -V  # update version for certbot^0.22.0    # 1.登录域名管理给域名添一个 DNS TXT 记录
$ tree /etc/letsencrypt/accounts  # 如何使用 ACME v2 版本?  https://www.jianshu.com/p/c5c9d071e395
$ certbot-auto certonly -d *.newyingyong.cn --manual --preferred-challenges dns \
  --server https://acme-v02.api.letsencrypt.org/directory # 2.没有获得 DNS TXT 记录生效前【不要回车执行确认】
$ dig -t txt _acme-challenge.newyingyong.cn @8.8.8.8      # 2.1确认获得 DNS TXT 记录是否生效？
$ tree /etc/letsencrypt/archive/newyingyong.cn            # 2.2证书申请成功
$ openssl x509 -in /etc/letsencrypt/archive/newyingyong.cn/cert1.pem -noout -text # 2.3校验证书
$ certbot-auto certificates                               # 2.4查看机器上有多少证书？
~~~
 - [OpenSSH入门](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_install_firstuse)、[适用于Windows的OpenSSH密钥管理](https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_keymanagement)
 - [OpenSSL管理证书docs](https://www.openssl.org/docs/manmaster/man1/)、[Create a self-signed SSL certificate](https://www.wowza.com/docs/how-to-create-a-self-signed-ssl-certificate)
~~~bash
#创建数字签名认证
> openssl req -new -nodes -x509 -out server.crt -keyout server.key -days 3650 \
    -subj "/C=DE/ST=NRW/L=Earth/O=Company-Name/OU=IT/CN=127.0.0.1/emailAddress=***@example.com"

openssl list -help            # 帮助
openssl list -commands        # 命令列表
openssl list -cipher-commands # 加密方式列表
# 加密签名 hmac+sha256
SIGNATURE="$(printf "${TIMESTAMP}${TOKEN}"|openssl dgst -sha256 -hmac "${SECRET}" -binary|openssl enc -base64)"
# 编码解码 base64
openssl base64 -in file.bin -out file.b64
openssl base64 -d -in file.b64 -out file.bin
# AES128加密 (CBC模式&PBKDF2密钥)密码+Salt 可选模式:aes-[128|192|256]-[cbc|cfb|cfb1|cfb8|ctr|ecb|ofb]
openssl enc -aes128 -pbkdf2 -in file.txt -out file.aes128    # 需输入密码<password>
openssl enc -aes128 -pbkdf2 -d -in file.aes128 -out file.txt -pass pass:<password>
# AES256加密 (CTR模式&PBKDF2密钥)密码+Salt + base64
openssl enc -aes-256-ctr -pbkdf2 -a -in file.txt -out file.aes256  # 需输入密码<password>
openssl enc -aes-256-ctr -pbkdf2 -d -a -in file.aes256 -out file.txt -pass file:<passfile> #提供密钥文件

# 生成秘钥文件
openssl genrsa -out server.key 2048                     # 使用常用的RSA算法
openssl ecparam -genkey -name secp384r1 -out server.key # 也可使用ECDSA算法
# 根据秘钥生成证书文件                                    # 开发证书(server.crt, server.key)
openssl req -new -x509 -key server.key -out server.crt -days 3650
# 根据秘钥生成公钥文件，该文件用于客户端与服务端通信(可选)
openssl rsa -in server.key -out server.key.public

~~~
 - *本机开发证书-- OpenSSL 生成 localhost.crt & localhost.key*
~~~bash
# localhost本机开发证书
# hosts可指定子域名www等: 127.0.0.1 www.localhost
> openssl req -x509 -out localhost.crt -keyout localhost.key -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' -extensions EXT -config <( printf "[dn]\nCN=localhost\n[req]\ndistinguished_name \
    = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

# localhost项目生成事件(Microsoft Visual Studio)
> if not exist "$(ProjectDir)$(PackageId).pfx" (dotnet dev-certs https -ep "$(ProjectDir)$(PackageId).pfx" -p 123456 -t && dotnet dev-certs https --clean -i "$(ProjectDir)$(PackageId).pfx" -p 123456)

  ## 单个域名 [sv.key sv.crt ci.key ci.crt] -一般用于本地开发(无密码验证-pass*)
openssl genrsa -out sv.key 2048    # genrsa生成server端密钥文件
openssl req -new -x509 -days 3650 -key sv.key -out sv.crt -subj "/C=GB/L=China/O=grpc-server/CN=server.grpc.io"
openssl genrsa -out ci.key 2048    # genrsa生成client端密钥文件
openssl req -new -x509 -days 3650 -key ci.key -out ci.crt -subj "/C=GB/L=China/O=grpc-client/CN=client.grpc.io"
  ## 单个域名+CA [ca.key ca.crt sv.key sv.crt ci.key ci.crt] -一般用于服务器生产
openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj "/C=GB/L=China/O=gobook/CN=github.com"
 // 生成server端`证书签名请求文件`sv.csr,然后根证书重新对server端签名,获得sv.crt
openssl req -new -key sv.key -out sv.csr -subj "/C=GB/L=China/O=server/CN=server.io"
openssl x509 -req -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in sv.csr -out sv.crt
 // 生成client端`证书签名请求文件`ci.csr,然后根证书重新对client端签名,获得ci.crt
openssl req -new -key ci.key -out ci.csr -subj "/C=GB/L=China/O=client/CN=client.io"
openssl x509 -req -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in ci.csr -out ci.crt

  ## 多IP+多域名+CA [ca.key ca.crt server.key server.crt server.pem]
openssl rand -out ~/.rnd $(date +%s)   # rand生成随机数文件
mkdir -p ./demoCA/newcerts && touch demoCA/index.txt demoCA/index.txt.attr && echo 01 |tee demoCA/serial 
openssl genrsa -passout pass:123456 -des3 -out ca.key 1024
openssl req -passin pass:123456 -new -x509 -days 3650 -key ca.key -out ca.crt \
    -subj "/C=CN/ST=SiChuan/CN=www.fpapi.cn" -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))
openssl genrsa -passout pass:123456 -des3 -out server.key 1024
openssl req -passin pass:123456 -new -key server.key -out server.csr \
    -subj "/C=CN/ST=SiChuan/CN=www.fpapi.cn" -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))
openssl ca -passin pass:123456 -days 3650 -in server.csr -keyfile ca.key -cert ca.crt -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))
openssl rsa -passin pass:123456 -in server.key -out server.key
openssl pkcs8 -topk8 -nocrypt -in server.key -out server.pem
~~~
 - *本机开发证书-- 工具mkcert,win-acme等 生成 localhost.crt & localhost.key*
```bash
#1.安装mkcert数字签名工具 github.com/FiloSottile/mkcert *26k
$ sudo apt install libnss3-tools  #or: sudo yum install nss-tools #or: sudo pacman -S nss
$ git clone github.com/FiloSottile/mkcert && go build -ldflags "-X main.Version=$(git describe --tags)"
$ mkcert -help    #.用于搭建本地CA数字签名认证: CA, Digital Signature, Key Encipherment, Certificate Signing.
$ mkcert -CAROOT  #1.查看证书存储路径"${HOME}/.local/share/mkcert": rootCA.pem,rootCA-key.pem
$ mkcert -install      #2.安装本地CA证书,为下面创建证书作准备↑↑
$ mkcert example.com "*.example.com" localhost 127.0.0.1 ::1 #3.创建证书,指定域名或IP
#1.1修改PowerShell脚本执行策略 windows
> Get-ExecutionPolicy
> Set-ExecutionPolicy RemoteSigned [RemoteSigned,AllSigned,Bypass,Restricted] # 全选 A (以管理员身份执行)
#1.2创建PowerShell数字签名认证 windows 10
> cd "C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64" # 签名工具makecert [-eku设为代码签名]
> makecert -n "CN=Api Cert" -a sha1 -eku 1.3.6.1.5.5.7.3.1 -r -sv api-root.pvk api-root.cer -ss Root -sr LocalMachine
#1.3打开PowerShell查询数字签名证书
> ls Cert:\CurrentUser\Root | where {$_.Subject -eq "CN=Api Cert"}

#2.安装win-acme证书管理windows客户端 github.com/win-acme/win-acme *4k

```

#### 安装证书后的操作

> Windows Server
~~~cmd
:: 清除dns本地缓存
ipconfig /release
:: ipconfig /all
ipconfig /flushdns
ipconfig /renew
:: 刷新dns本地缓存
netsh int ip set dns
netsh winsock reset
~~~

----

