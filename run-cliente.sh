#!/bin/bash
set -e

curl -k -v https://test.localdev.me/index.html --key certs/client.key --cert certs/client.crt
