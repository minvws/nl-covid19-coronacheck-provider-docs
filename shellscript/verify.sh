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

printf "$JSON" | sed -e 's/.*payload":.?*"//' -e 's/".*//' | base64 -d  > "$TMPDIR/payload.$$.bin"

if [ $# -eq 1 ]; then
	PARTIAL="-partial_chain"
	CA=$1
fi

# Allow for partial chain and any purpose for
# testing and debugging purposes. 
#
printf "$JSON" | \
	sed -e 's/.*signature":.?*"//' -e 's/".*//' |\
	base64 -d |\
	openssl cms -verify \
		-content "$TMPDIR/payload.$$.bin" -inform DER -binary \
		-CAfile "$CA" \
		-certfile "$CA" \
		$PARTIAL \
		-purpose $PURPOSE  

# rm -f "$TMPDIR/payload.$$.bin"
