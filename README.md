# Instalação

Para executar os exemplos será necessário:
- Terminal shell
- dotnet sdk 6.0
- docker
- openssl cli

Abrir um terminal no diretório [/src](https://github.com/willsbctm/mtls-teste/tree/main/src) e seguir os próximos passos

## Configurar host

Apontar o endereço test.localdev.me para 127.0.0.1 na sua máquina

## Gerar Certificados

Rodar [gerar-certificados.sh](https://github.com/willsbctm/mtls-teste/blob/main/src/gerar-certificados.sh) para gerar os certificados e chaves no diretório [/certs](https://github.com/willsbctm/mtls-teste/tree/main/src/certs):
- server.crt
- server.key
- ca.crt
- client.crt
- client.key

```
./gerar-certificados.sh
```

## Criar servidor

Rodar [docker-build.sh](https://github.com/willsbctm/mtls-teste/blob/main/src/docker-build.sh) para gerar a imagem nginx:mtls que terá configurado o certificado do servidor:
- server.crt
- server.key

E também terá a autoridade confiável para certificados do cliente:
- ca.crt

Essas configurações estão no arquivo [nginx-setup-mtls.conf](https://github.com/willsbctm/mtls-teste/blob/main/src/nginx/nginx-setup-mtls.conf)
```
./docker-build.sh
```

Rodar [docker-run-servidor.sh](https://github.com/willsbctm/mtls-teste/blob/main/src/docker-run-servidor.sh) para iniciar o servidor nginx expondo a porta 443
```
./docker-run-servidor.sh
```

## Realizar chamada do cliente no servidor

### Via curl
Rodar [run-cliente-curl.sh](https://github.com/willsbctm/mtls-teste/blob/main/src/run-cliente-curl.sh) para realizar uma chamada curl informando o client.crt e client.key
```
./run-cliente-curl.sh
```

### Via dotnet
Rodar [run-cliente-dotnet.sh](https://github.com/willsbctm/mtls-teste/blob/main/src/run-cliente-dotnet.sh) para realizar uma chamada utilizando HttpClient e informando o client.crt e client.key
```
./run-cliente-dotnet.sh
```

# Resultado esperado

- Chamar o servidor e não informar certificado de cliente:
"400 No required SSL certificate was sent"

- Chamar o servidor e informar certificado do cliente inválido:
"400 The SSL certificate error"

- Chamar o servidor e informar certificado do cliente assinado pela autoridade configurado no servidor:
"mTLS fechado com sucesso!"

# Conceitos


- TLS x mTLS

[<img src="imagens/tls.jpg" width="400px"/>](imagens/tls.jpg)
[<img src="imagens/mtls.jpg" width="396px"/>](imagens/tls.jpg)

Algumas questões interessantes:
1) O certificado do servidor não tem nenhuma relação com o certificado do cliente.
2) O servidor aceita comunicação com o cliente se o certificado do cliente for assinado pela autoridade de certificados de cliente configurada no servidor.
3) O servidor aceita qualquer certificado de cliente assinado pela autoridade configurada.
4) O certificado do cliente provavelmente será assinado por uma autoridade interna da organização para que os certificados de cliente aceitos pelo servidor estejam sob controle.
5) Para realizar uma chamada dotnet utilizando HttpClient, é necessário:
```c#
var certificado = X509Certificate2.CreateFromPemFile("client.crt", "client.key");
var handler = new HttpClientHandler();
handler.ClientCertificateOptions = ClientCertificateOption.Manual;
handler.ClientCertificates.Add(certificado);
var client = new HttpClient(handler);
var resultado = await client.GetAsync("https://test.localdev.me/index.html");
```


# Em resumo
O mTLS tem o fluxo normal do TLS somado a uma validação por parte do servidor do certificado informado pelo cliente através do ca root configurado no servidor, dessa forma o cliente também consegue provar ser quem ele deve ser para o servidor.