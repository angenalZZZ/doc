#!/bin/sh

cd /home/yangzhou/go/bin/cronsun
./cronnode -conf conf/base.json &
./cronweb -conf conf/base.json &
