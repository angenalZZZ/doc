#!/bin/sh

cd /a/database/influxdb
./influxd --http-bind-address=":9999" --session-length="1440" --store="bolt" --bolt-path="/a/database/influxdb/.influxdbv2/influxd.bolt" --engine-path="/a/database/influxdb/.influxdbv2/engine" --log-level="error" --reporting-disabled
