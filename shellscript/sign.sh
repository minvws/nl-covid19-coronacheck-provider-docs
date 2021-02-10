#!/bin/sh

set -e

if [ $# -gt 2 ]; then
	echo "Syntax: $0 [example.json [client.crt]]"
	exit 1
fi

JSON=${1:-example.json}
CERT=${2:-client.crt}

if [ $# -lt 2 -a ! -e client.crt ]; then
	echo Generating a self signed demo certificate.
	echo

	ERM=$(
              SERIAL=$(openssl rand -hex 1024 | tr -d a-zA-Z | cut -c 1-16)
              openssl req \
		-new -x509 \
		-extensions v3_req \
		-addext subjectKeyIdentifier=hash \
		-addext authorityKeyIdentifier=keyid,issuer \
		-subj "/CN=Locatie Noord/O=Testers-are-us/C=NL" \
		-keyout client.crt -out client.crt -nodes -set_serial $SERIAL 2>&1

	     openssl pkcs12 -in client.crt -export -out keystore.p12 \
		-passout pass:changeme -name "1" 2>&1
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
