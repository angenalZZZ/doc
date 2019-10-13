#!/bin/sh

$GOPATH/bin/centrifugo -c /4g/git/doc/sh/centrifugo.config.json --port "8116" --engine "memory" --grpc_api
