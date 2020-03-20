#!/bin/bash
# all-in-run.sh 生成证书

openssl rand -out ./.rnd $(date +%s)
mkdir -p ./demoCA/newcerts && touch demoCA/index.txt demoCA/index.txt.attr && echo 01 |tee demoCA/serial

# 指定密码生成私钥 ca.key server.key
openssl genrsa -passout pass:123456 -des3 -out ca.key 1024
openssl genrsa -passout pass:123456 -des3 -out server.key 1024

# 生成根证书公钥 ca.crt
openssl req -passin pass:123456 -new -x509 -days 3650 -key ca.key -out ca.crt -subj "/C=CN/ST=SiChuan/CN=www.fpapi.cn" -extensions SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))

# 先生成server端 证书签名请求文件 server.csr
openssl req -passin pass:123456 -new -key server.key -out server.csr -subj "/C=CN/ST=SiChuan/CN=www.fpapi.cn" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))

openssl ca -passin pass:123456 -days 3650 -in server.csr -keyfile ca.key -cert ca.crt -extensions SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:*.fpapi.cn,IP:127.0.0.1"))

# writing RSA key
openssl rsa -passin pass:123456 -in server.key -out server.key

openssl pkcs8 -topk8 -nocrypt -in server.key -out server.pem
openssl pkcs8 -topk8 -nocrypt -in server.key -out server.pem

# 然后根证书重新对server端签名, 获得server.crt
openssl x509 -req -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in server.csr -out server.crt

