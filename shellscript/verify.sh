#!/bin/sh

set -e

if [ $# -gt 1 ]; then
	echo "Syntax: $0 [client.crt]"
	exit 1
fi

CERT=${2:-client.crt}
JSON=$(cat)
TMPDIR=${TMPDIR:-/tmp}

printf "$JSON" | tr -d '\n\r' | sed -e 's/.*payload":.?*"//' -e 's/".*//' > "$TMPDIR/payload.$$.bin"

printf "$JSON" | \
	tr -d '\n\r' | \
	sed -e 's/.*signature":.?*"//' -e 's/".*//' |\
	base64 -d |\
	openssl cms -verify -CAfile client.crt -content "$TMPDIR/payload.$$.bin" -inform DER -binary | base64 -d

rm -f "$TMPDIR/payload.$$.bin"
