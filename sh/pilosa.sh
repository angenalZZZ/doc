#!/bin/sh

cd /4g/go/.pilosa
./pilosa server --data-dir /4g/go/.pilosa --bind 127.0.0.1:10101 --handler.allowed-origins "*"
