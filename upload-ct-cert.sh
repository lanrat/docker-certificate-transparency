#!/usr/bin/env bash

if [ $# -ne 2 ]; then
    echo "pass PEM cert and host to upload to"
    echo "example: $0 example.com.pem http://localhost.com:6962/"
    exit 1
fi

certs=$(cat $1 | sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p' | tr -d '\n')

eol=$'\n'
certs="${certs//'-----END CERTIFICATE-----'/$eol}"
certs="${certs//'-----BEGIN CERTIFICATE-----'/}"

#echo "$certs"

chain='{"chain":['
#chain="{\"chain\":$eol["

add=""
while read -r line; do
    if [ -z "$line" ]; then
        continue
    fi
    #echo "> $line"
    chain="${chain}${add}\"${line}\""
    add=","

done <<< "$certs"

chain="$chain]}"

#echo "$chain"
curl -d "$chain" $2/ct/v1/add-chain
echo ""

