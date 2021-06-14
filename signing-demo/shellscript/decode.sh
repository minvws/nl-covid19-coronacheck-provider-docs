#!/bin/sh
#
if [ $# -ne 0 ]; then
	echo Syntax: $0
	exit 1
fi
OPENSSL=${OPENSSL:-openssl}


if $OPENSSL version | grep -q LibreSSL; then
        echo Sorry - OpenSSL is needed.
        exit 1
fi
if ! $OPENSSL version | grep -q 1\.; then
        echo Sorry - OpenSSL 1.0 or higher is needed.
        exit 1
fi

jq .signature | \
	tr -d '\\' |\
	tr -d '\n\r' |\
	sed -e 's/^"//' -e 's/"$//' |\
	base64 -d |\
	$OPENSSL pkcs7 -inform DER -noout -print
