#!/bin/sh

pilosa server --data-dir /home/yangzhou/.pilosa --bind 127.0.0.1:10101 --handler.allowed-origins "*"
