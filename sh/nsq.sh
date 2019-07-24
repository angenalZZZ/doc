#!/bin/sh

sh -c 'nsqlookupd &'
sh -c 'nsqd --lookupd-tcp-address=127.0.0.1:4160 &'
sh -c 'nsqadmin --lookupd-http-address=127.0.0.1:4161 &'
