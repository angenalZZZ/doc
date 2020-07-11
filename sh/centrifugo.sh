#!/bin/sh

/a/go/bin/centrifugo -c /a/git/doc/sh/centrifugo.config.json --port 8116 --engine memory --grpc_api
