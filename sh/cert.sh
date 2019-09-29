#!/bin/bash
# ./cert.sh test@test.com 123456 127.0.0.1 [certs] !please check: cert-openssl.conf
# Found: https://gist.github.com/ncw/9253562#file-makecert-sh

if [ "$1" == "" ]; then
    echo "Need EMAIL as argument"
    exit 1
fi

if [ "$2" == "" ]; then
    echo "Need PRIVKEY as argument"
    exit 1
fi

if [ "$3" == "" ]; then
    echo "Need CN as argument"
    exit 1
fi

EMAIL=$1
PRIVKEY=$2
CN=$3
ROOT=${4:-certs}

rm -rf tmp
mkdir tmp
cd tmp

echo "make CA"
openssl req -new -x509 -days 3650 -keyout ca.key -out ca.pem \
    -config ../cert-openssl.conf -extensions ca \
    -subj "/CN=ca" \
    -passout pass:$PRIVKEY

echo "make server cert"
openssl genrsa -out server.key 2048
openssl req -new -sha256 -key server.key -out server.req \
    -subj "/emailAddress=${EMAIL}/C=DE/ST=NRW/L=Earth/O=Random Company/OU=IT/CN=${CN}"
openssl x509 -req -days 3650 -sha256 -in server.req -CA ca.pem -CAkey ca.key -CAcreateserial -passin pass:$PRIVKEY -out server.pem \
    -extfile ../cert-openssl.conf -extensions server

echo "make client cert"
openssl genrsa -out client.key 2048
openssl req -new -sha256 -key client.key -out client.req \
    -subj "/emailAddress=${EMAIL}/C=DE/ST=NRW/L=Earth/O=Random Company/OU=IT/CN=${CN}"
openssl x509 -req -days 3650 -sha256 -in client.req -CA ca.pem -CAkey ca.key -CAserial ca.srl -passin pass:$PRIVKEY -out client.pem \
    -extfile ../cert-openssl.conf -extensions client

cd ..
mv tmp/* $ROOT
rm -rf tmp
