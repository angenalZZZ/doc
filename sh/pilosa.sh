#!/bin/sh

cd /a/database/pilosa
./pilosa server --data-dir /a/database/pilosa/.pilosa --bind 127.0.0.1:10101 --handler.allowed-origins "*"
