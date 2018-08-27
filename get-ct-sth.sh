#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "pass host to connect to"
    echo "ex: $0 http://localhost:6962/"
    exit 1
fi

curl $1/ct/v1/get-sth
echo ""
