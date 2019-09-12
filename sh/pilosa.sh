#!/bin/sh

cd /4g/database/pilosa
./pilosa server --data-dir /4g/database/pilosa/.pilosa --bind 127.0.0.1:10101 --handler.allowed-origins "*"
