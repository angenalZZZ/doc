#!/bin/sh

sh -c '/4g/go/nsq/nsqlookupd &'
sh -c '/4g/go/nsq/nsqd --lookupd-tcp-address=127.0.0.1:4160 &'
sh -c '/4g/go/nsq/nsqadmin --lookupd-http-address=127.0.0.1:4161 &'
