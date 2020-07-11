#!/bin/sh

export MINIO_BROWSER=on
export MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
export MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
cd /a/go/bin/minio
./minio server --address :9000 --config-dir /a/go/bin/minio --certs-dir /a/go/bin/minio/certs /a/go/bin/minio/data
