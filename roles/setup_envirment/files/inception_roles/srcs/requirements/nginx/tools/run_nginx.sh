#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $KEYOUT_ -out $CERTS_ -subj "/C=AM/L=Yerevan/O=42/OU=student/CN=$DOMAIN_NAME"

cd /etc/nginx/sites-available/

if [ -f ./default.conf ]; then
    sed -i "s#\$DOMAIN_NAME#$DOMAIN_NAME#g" default.conf
    sed -i "s#\$CERTS_#$CERTS_#g" default.conf
    sed -i "s#\$KEYOUT_#$KEYOUT_#g" default.conf

    cat default.conf > default

    rm -rf default.conf
fi

nginx -g "daemon off;"