#!/bin/bash
set -e

docker rm -f mtls-nginx
docker rmi nginx:mtls
./apagar-certificados.sh