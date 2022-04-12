# CoronaCheck Event Provider Certificate Guide

## Introduction
The CoronaCheck application and website can collect events from different providers. These providers must secure their publically available https endpoints using a TLS connection with a specific certificate X509 certificate. They must also sign all of their data using a CMS signature, created with another X509 certificate.

This is a short summary of the requirements. An extended guide is available [here](https://github.com/minvws/nl-covid19-coronacheck-app-coordination/blob/main/architecture/Security%20Architecture.md).

## Migration from PKIO to OV / EV Certificates
Since PKIO public will cease to exist by December 2022, the requirement to use a PKIO Public certificate for the TLS endpoint will be dropped.


## Requirements per 2022-05-01
### TLS Endpoint
The X509 certificate used to provide the https/tls service must comply with the following requirements:
- Issued by a reputable and widely accepted Root CA. The root certificate must available in all Android 6+, Apple iOS 12.2+, Google Chrome, Firefox, and Safari browsers.
- Contain the Extended Validation (2.23.140.1.1) or Organization Validation (2.23.140.1.2.2) attribute.
- Contain the specific endpoint in the certificate Common Name (wildcards are invalid).

### CMS Signature
The X509 certificate used to sign the data that is provided by the event provider must comply with the following requirements:
- Issued by [Staat der Nederlanden Private Root CA - G1](http://cert.pkioverheid.nl/PrivateRootCA-G1.cer) or one of its Sub-CAs. A list is available [here](https://cert.pkioverheid.nl/).
- Must contain the legal name of the event provider.

## Deprecated requirements
See [x509-pinning-test-providers-1.08.deprecated.pdf](x509-pinning-test-providers-1.08.deprecated.pdf).
