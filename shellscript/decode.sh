#!/bin/sh
grep signature | sed -e 's/.*"M/M/' -e 's/".*//' |  base64 -d | openssl pkcs7 -inform DER -noout -print
