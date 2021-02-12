#!/bin/sh
#
if [ $# -ne 0 ]; then
	echo Syntax: $0
	exit 1
fi
OPENSSL=${OPENSSL:-openssl}

grep signature |\
	tr -d '\\' |\
	tr -d '\n\r' |\
	sed -e 's/.*"M/M/' -e 's/".*//' |  \
	base64 -d |\
	$OPENSSL pkcs7 -inform DER -noout -print
