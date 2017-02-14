#!/bin/bash
set -e

PRODUCT_ID=
SERIAL=12345678
CLIENT_ID=
CLIENT_SECRET=
HOSTNAME=alexa-service
PORT=3000

mkdir -p certs/ca certs/server certs/client

if [ ! -f certs/ca/ca.key ]; then
    openssl genrsa -out certs/ca/ca.key 4096
    HOSTNAME=$HOSTNAME COMMON_NAME="My CA" \
            openssl req -new -x509 -days 365 -key certs/ca/ca.key -out certs/ca/ca.crt -config ssl.cnf -sha256
fi

# Create the KeyPair for the Node.js Companion Service
if [ ! -f certs/server/server.key -o ! -f certs/server/server.crt ]; then
    openssl genrsa -out certs/server/server.key 2048
    HOSTNAME=$HOSTNAME COMMON_NAME=$HOSTNAME \
            openssl req -new -key certs/server/server.key -out certs/server/server.csr -config ssl.cnf -sha256
    openssl x509 -req -days 365 -in certs/server/server.csr -CA certs/ca/ca.crt -CAkey certs/ca/ca.key \
            -set_serial 02 -out certs/server/server.crt -sha256
fi

# Create the KeyPair for the Jetty server running on the Device Code in companionApp mode
if [ ! -f certs/server/jetty.pkcs12 ]; then
    openssl genrsa -out certs/server/jetty.key 2048
    HOSTNAME=$HOSTNAME COMMON_NAME=$HOSTNAME \
            openssl req -new -key certs/server/jetty.key -out certs/server/jetty.csr -config ssl.cnf -sha256
    HOSTNAME=$HOSTNAME COMMON_NAME=$HOSTNAME \
            openssl x509 -req -days 365 -in certs/server/jetty.csr -CA certs/ca/ca.crt -CAkey certs/ca/ca.key \
            -set_serial 03 -out certs/server/jetty.crt -extensions v3_req -extfile ssl.cnf -sha256
    openssl pkcs12 -inkey certs/server/jetty.key -in certs/server/jetty.crt -export \
            -out certs/server/jetty.pkcs12 -password pass:
fi

# Create the Client KeyPair for the Device Code
if [ ! -f certs/client/client.pkcs12 ]; then
    openssl genrsa -out certs/client/client.key 2048
    HOSTNAME=$HOSTNAME COMMON_NAME="$PRODUCT_ID:$SERIAL" \
            openssl req -new -key certs/client/client.key -out certs/client/client.csr -config ssl.cnf -sha256
    openssl x509 -req -days 365 -in certs/client/client.csr -CA certs/ca/ca.crt -CAkey certs/ca/ca.key \
            -set_serial 01 -out certs/client/client.crt -sha256
    openssl pkcs12 -inkey certs/client/client.key -in certs/client/client.crt -export \
            -out certs/client/client.pkcs12 -password pass:
fi

cp certs/ca/ca.crt certs/server/server.{key,crt} companionService/certs
cp certs/ca/ca.crt certs/client/client.pkcs12 certs/server/jetty.pkcs12 javaclient/certs

docker build -t alexa-service \
       --build-arg product_id=$PRODUCT_ID --build-arg serial=$SERIAL --build-arg client_id=$CLIENT_ID \
       --build-arg client_secret=$CLIENT_SECRET --build-arg hostname=$HOSTNAME --build-arg port=$PORT \
       companionService

docker build -t alexa-client \
       --build-arg product_id=$PRODUCT_ID --build-arg serial=$SERIAL --build-arg hostname=$HOSTNAME \
       --build-arg port=$PORT \
       javaclient

docker build -t alexa-wwa wakeWordAgent
