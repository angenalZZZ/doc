#!/bin/bash
# all-in-run.sh 生成证书

openssl genrsa -out sv.key 2048
openssl genrsa -out ci.key 2048

openssl req -new -x509 -days 3650 -key sv.key -out sv.crt -subj "/C=GB/L=China/O=api-server/CN=server.api.io"
openssl req -new -x509 -days 3650 -key ci.key -out ci.crt -subj "/C=GB/L=China/O=api-client/CN=client.api.io"
