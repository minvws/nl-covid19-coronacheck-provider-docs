#!/bin/sh

set -e

if [ $# -gt 2 ]; then
	echo "Syntax: $0 [example.json [client.crt]]"
	exit 1
fi

JSON=${1:-example.json}
CERT=${2:-client.crt}

if [ $# -lt 2 -a ! -e client.crt ]; then
	. ./gen-fake-pki-overheid.sh
fi

JSON_B64=$(base64 "$JSON")

# We avoid using echo (shell and /bin echo behave differently) as to 
# get control over the trialing carriage return.

SIG_B64=$(printf "$JSON_B64" | openssl cms -sign -outform DER -signer "$CERT" -certfile chain.pem| base64)

cat <<EOM
[
	{
		"payload": "$JSON_B64",
		"signature": "$SIG_B64"
	}
]
EOM
