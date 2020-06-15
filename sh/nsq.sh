#!/bin/sh

sh -c '/a/go/bin/nsq/nsqlookupd -tcp-address=0.0.0.0:4160 -http-address=0.0.0.0:4161 &'
sh -c '/a/go/bin/nsq/nsqd -node-id=1 --lookupd-tcp-address=127.0.0.1:4160 -tcp-address=0.0.0.0:4150 -http-address=0.0.0.0:4151 -data-path=/a/go/bin/nsq/data &'
sh -c '/a/go/bin/nsq/nsqadmin --lookupd-http-address=127.0.0.1:4161 -http-address=0.0.0.0:4171 -log-level=warn &'
