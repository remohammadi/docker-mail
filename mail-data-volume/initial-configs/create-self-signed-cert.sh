#!/bin/bash

if [ -f mail.key ]; then
    echo "mail.key exists!"
    exit 1
fi

if [ ! -f openssl.cnf ]; then
    echo "openssl.cnf doesn't exists!"
    exit 1
fi

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout mail.key -out mailcert.pem -config openssl.cnf
