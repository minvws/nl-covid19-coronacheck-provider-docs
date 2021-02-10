#!/bin/sh

set -e

if [ $# -gt 2 ]; then
	echo "Syntax: $0 [example.json [client.crt]]"
	exit 1
fi

JSON=${1:-example.json}
CERT=${2:-client.crt}

if [ ! -e client.crt ]; then
	echo Generating a self signed demo certificate.
	echo

	ERM=$(
              openssl req \
		-new -x509 \
		-subj "/CN=Locatie Noord/O=Testers-are-us/C=NL" \
		-keyout client.crt -out client.crt -nodes -set_serial 1278172891  2>&1

	     openssl pkcs12 -in client.crt -export -out keystore.p12 -passout pass:changeme 2>&1
	) 
	if [ $? -ne 0 ]; then
		echo cert generation failed: $ERM
		echo Aborted.
		exit $?
	fi
fi

JSON_B64=$(base64 "$JSON")

# We avoid using echo (shell and /bin echo behave differently) as to 
# get control over the trialing carriage return.

SIG_B64=$(printf "$JSON_B64" | openssl cms -sign -outform DER -signer "$CERT" | base64)

cat <<EOM
[
	{
		"payload": "$JSON_B64",
		"signature": "$SIG_B64"
	}
]
EOM
