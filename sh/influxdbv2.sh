#!/bin/sh

cd /4g/database/influxdb
./influxd --http-bind-address=":9999" --session-length="1440" --store="bolt" --bolt-path="/4g/database/influxdb/.influxdbv2/influxd.bolt" --engine-path="/4g/database/influxdb/.influxdbv2/engine" --log-level="error" --reporting-disabled
