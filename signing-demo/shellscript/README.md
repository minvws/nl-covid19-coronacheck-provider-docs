## Requirements

	Openssl 1.0 or newer.
	base64 
	jq (https://stedolan.github.io/jq/)
	
Note: MacOS ships with LibreSSL which doesn't support all algorithms we use. Install openssl for example via `brew install openssl`. If succesful, an `openssl version` should display 'OpenSSL' instead of 'LibreSSL'.	
	
## Usage

       ./sign.sh [example.json [client-cert-to-sign-with.pem]]

If no client cert is passed - this tool wil generate a keystore.p12 java style trust store in PKCS#12 format and a client certifciate (client.crt).

Output:

```
[
	{
		"payload": "WwogeyJhZm5hbWVkYXR1bSI6IjIwMjAtMDYtMTdUMTA6MDA6MDAuMDAwKzAyMDAiLAogICJ1aXRzbGFnZGF0dW0iOiIyMDIwLTA2LTE3VDEwOjEwOjAwLjAwMCswMjAwIiwKICAicmVzdWx0YWF0IjoiTkVHQVRJRUYiLAogICJhZnNwcmFha1N0YXR1cyI6IkFGR0VST05EIiwKICAiYWZzcHJhYWtJZCI6Mjc4NzE3Njh9LAogeyJhZm5hbWVkYXR1bSI6IjIwMjAtMTEtMDhUMTA6MTU6MDAuMDAwKzAxMDAiLAogICAidWl0c2xhZ2RhdHVtIjoiMjAyMC0xMS0wOVQwNzo1MDozOS4wMDArMDEwMCIsCiAgICJyZXN1bHRhYXQiOiJQT1NJVElFRiIsCiAgICJhZnNwcmFha1N0YXR1cyI6IkFGR0VST05EIiwKICAgImFmc3ByYWFrSWQiOjI1ODcxOTcyMTl9Cl0K",
		"signature": "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"
	}
]
```

To check:

	 ./sign.sh | ./verify.sh ca.pem

To see what is in it
	./sign.sh | ./decode.sh


## Verification against a real server


         curl --silent 'https://api.example.com/something/config' | sh verify.sh

Gives the output:

```
Verification successful


[
 {"afnamedatum":"2020-06-17T10:00:00.000+0200",
  "uitslagdatum":"2020-06-17T10:10:00.000+0200",
  "resultaat":"NEGATIEF",
  "afspraakStatus":"AFGEROND",
  "afspraakId":27871768},
 {"afnamedatum":"2020-11-08T10:15:00.000+0100",
   "uitslagdatum":"2020-11-09T07:50:39.000+0100",
   "resultaat":"POSITIEF",
   "afspraakStatus":"AFGEROND",
   "afspraakId":2587197219}
]
```

The scripts

	extract_signer

can be used to extract (just) the signer from a CMS package. It wont'd do ANY validation - just display what the file claims is the signer. 
	
