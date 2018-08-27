#! /usr/bin/env bash

# Taken from
# https://github.com/google/certificate-transparency/blob/master/docs/Deployment.md#private-key-generation
openssl ecparam -name prime256v1 > privkey.pem # generate parameters file
openssl ecparam -in privkey.pem -genkey -noout >> privkey.pem # generate and append private key
openssl ec -in privkey.pem -noout -text # check key is readable
openssl ec -in privkey.pem -pubout -out pubkey.pem # generate corresponding public key

cat /etc/ssl/certs/* > ca-roots.pem
