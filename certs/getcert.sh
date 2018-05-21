#!/usr/bin/env bash

domain=$1

openssl s_client -connect $domain:443 -showcerts < /dev/null > $domain.pem
