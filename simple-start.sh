#!/bin/sh
SECRET=$(head -c 16 /dev/urandom | xxd -ps)
echo "Secret: $SECRET"
mtproto-proxy -u -p 8888 -H 443 -S "$SECRET" -M 1
