#!/bin/sh

# Create SSL directory
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FI/ST=Helsinki/L=Helsinki/O=Hive/OU=nmascaro/CN=nmascaro.42.fr"

# Start NGINX
exec nginx -g "daemon off;"
