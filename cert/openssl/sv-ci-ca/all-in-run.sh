#!/bin/bash
# all-in-run.sh 生成证书

openssl genrsa -out sv.key 2048
openssl genrsa -out ci.key 2048
openssl genrsa -out ca.key 2048

openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj "/C=GB/L=China/O=gobook/CN=github.com"

openssl req -new -key sv.key -out sv.csr -subj "/C=GB/L=China/O=server/CN=server.io"
openssl x509 -req -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in sv.csr -out sv.crt

openssl req -new -key ci.key -out ci.csr -subj "/C=GB/L=China/O=client/CN=client.io"
openssl x509 -req -sha256 -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in ci.csr -out ci.crt
