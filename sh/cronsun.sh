#!/bin/sh

cd /4g/go/cronsun
./cronnode -conf conf/base.json &
./cronweb -conf conf/base.json &
