FROM nginx:1.23.0
COPY nginx/nginx-setup-mtls.conf /etc/nginx/conf.d/default.conf
COPY nginx/index.html /usr/share/nginx/html/
COPY certs/server.crt /etc/nginx/certs/
COPY certs/server.key /etc/nginx/certs/
COPY certs/ca.crt /etc/nginx/mtls/

CMD ["/bin/sh",  "-c", "exec nginx -g 'daemon off;'"]
