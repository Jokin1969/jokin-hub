#!/bin/sh
echo "server { listen ${PORT}; root /usr/share/nginx/html; index index.html; }" \
    > /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'
