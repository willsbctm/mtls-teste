#!/bin/bash
set -e

# Gerar certificado do servidor
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certs/server.key -out certs/server.crt -subj '/CN=test.localdev.me/O=test.localdev.me'

# Gerar CA root que assinará o certificado do cliente e ficará no servidor
openssl req -x509 -sha256 -newkey rsa:4096 -keyout certs/ca.key -out certs/ca.crt -days 356 -nodes -subj '/CN=Minha autoridade cliente'

# Gerar csr para gerar certificado do cliente
openssl req -new -newkey rsa:4096 -keyout certs/client.key -out certs/client.csr -nodes -subj '/CN=Meu cliente'

# Assinar csr com o CA e gerar certificado do cliente
openssl x509 -req -sha256 -days 365 -in certs/client.csr -CA certs/ca.crt -CAkey certs/ca.key -set_serial 02 -out certs/client.crt

rm certs/ca.key
rm certs/client.csr
