#!/bin/sh

cd /a/go/bin/cronsun
./cronnode -conf conf/base.json &
./cronweb -conf conf/base.json &
