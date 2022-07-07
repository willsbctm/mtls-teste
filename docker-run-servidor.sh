#!/bin/bash
set -e

docker run -d --name mtls-nginx -p 443:443 nginx:mtls