#!/bin/bash

echo "der2pem - Myo Soe, https://yehg.net"

if [ $# -eq 0 ]
  then
    echo "Provide parameter as burp cert in der form such as cacert"
    exit
fi

openssl x509 -inform der -in $1 -out cacert.pem

echo "Saved as cacert.pem in current directory - `pwd`"

