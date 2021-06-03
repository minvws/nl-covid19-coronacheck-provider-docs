#!/bin/sh
set -e

if [ $# -gt 1 ]; then
	echo "Syntax: $0 [client.crt]"
	exit 1
fi
JSON=$(cat | tr -d '\\' | tr -d '\n\r' )

TMPDIR=${TMPDIR:-/tmp}
CA=${1:-ca-pki-overheid.pem}
PURPOSE=${PURPOSE:-any}
OPENSSL=${OPENSSL:-openssl}

if $OPENSSL version | grep -q LibreSSL; then
        echo Sorry - OpenSSL is needed.
        exit 1
fi
if ! $OPENSSL version | grep -q 1\.; then
        echo Sorry - OpenSSL 1.0 or higher is needed.
        exit 1
fi

printf "$JSON" |\
	jq .payload |\
	sed -e 's/^"//' -e 's/"$//' |
	base64 -d > "$TMPDIR/payload.$$.bin"

if [ $# -eq 1 ]; then
	PARTIAL="-partial_chain"
	CA=$1
fi

# Allow for partial chain and any purpose for
# testing and debugging purposes. 
#
printf "$JSON" | jq -r .signature | 
	base64 -d  > x.raw

printf "$JSON" | jq -r .signature |
	base64 -d |\
	$OPENSSL cms -verify \
		-content "$TMPDIR/payload.$$.bin" -inform DER -binary \
		-CAfile "$CA" \
		-certfile "$CA" \
		$PARTIAL \
		-purpose $PURPOSE  

# rm -f "$TMPDIR/payload.$$.bin"
