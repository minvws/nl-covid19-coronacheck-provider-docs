#!/bin/sh

set -e

if [ $# -gt 1 ]; then
	echo "Syntax: $0 [client.crt]"
	exit 1
fi
CERT=${1:-client.crt}

JSON=$(cat | tr -d '\\' | tr -d '\n\r' )

TMPDIR=${TMPDIR:-/tmp}
CA=${CA:-$CERT}
PURPOSE=${PURPOSE:-any}

printf "$JSON" | sed -e 's/.*payload":.?*"//' -e 's/".*//'  > "$TMPDIR/payload.$$.bin"

PARTIAL=""
if [ "x$CA" = "x$CERT" ]; then
	# check if the CERT is a complete chain; if not - configure
	# the check to be partial.
	#
	if openssl x509 -in "$CERT" -text | grep -q CA:FALSE; then
		PARTIAL="-partial_chain"
		echo Warning - enabling partial chain check - as there is no CA defined. This may not be what you want.
	fi
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
		-certfile client.crt \
		$PARTIAL \
		-purpose $PURPOSE \
	| \
	base64 -d

rm -f "$TMPDIR/payload.$$.bin"