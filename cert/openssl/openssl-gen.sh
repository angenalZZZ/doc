#!/bin/bash
set -ex
# generate CA's  key
openssl genrsa -aes256 -passout pass:1 -out ca.key.pem 4096
openssl rsa -passin pass:1 -in ca.key.pem -out ca.key.pem.tmp
mv ca.key.pem.tmp ca.key.pem

openssl req -config openssl.cnf -key ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out ca.pem

# https://www.cnblogs.com/nidey/p/9041960.html
# 生成秘钥，得到(无密码的) server.key
# openssl genrsa -out server.key 2048
# 生成证书签发请求，得到 server.csr
# openssl req -new -sha256 -out server.csr -key server.key -config openssl.conf
# 用CA证书生成终端用户证书，得到 server.crt
# openssl x509 -req -days 3650 -CA ca.crt -CAkey ca.key -CAcreateserial -in server.csr -out server.crt \
#  -extensions req_ext -extfile openssl.conf
