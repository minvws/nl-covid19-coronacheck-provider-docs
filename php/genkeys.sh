#!/bin/sh
set -e

# Create a 4 level CA chain; from CA->TSP->RA->client

openssl req \
	-new -x509 \
	-set_serial 1278172891 \
	-subj "/CN=Da Root/O=Testers-are-us/C=NL" \
	-keyout ca.key -passout pass:capass \
	-extensions v3_ca \
	-out ca.pem 

openssl req \
	-new \
	-subj "/CN=Da TSP/O=Testers-are-us/C=NL" \
	-extensions v3_ca \
	-keyout tsp.key -passout pass:tsppass |
openssl x509 -req \
	-CA ca.pem -CAkey ca.key -passin pass:capass \
        -set_serial 212983129 \
        -extfile openssl.cnf  -extensions subca \
	-out tsp.pem 

openssl req \
	-new \
	-subj "/CN=Da RA doing the actual work/O=Testers-are-us/C=NL" \
	-keyout ra.key -passout pass:rapass |
openssl x509 -req \
	-CA tsp.pem -CAkey tsp.key -passin pass:tsppass \
        -set_serial 212983129 \
        -extfile openssl.cnf  -extensions subca \
	-out ra.pem 

openssl req \
	-new  \
	-subj "/CN=Locatie Noord/O=Testers-are-us/C=NL" \
	-keyout client.key -passout pass:changeme  |\
openssl x509 -req \
	-CA ra.pem -CAkey ra.key -passin pass:rapass \
	-set_serial 78129871 \
	-out client.pem 

# Generate a chain
#
cat ra.pem tsp.pem ca.pem > chain.pem
