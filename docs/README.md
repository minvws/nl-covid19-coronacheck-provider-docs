# Provider documentation

## Connection documentation

Depending on your situation, you need one of these docs:

* For providing negative test results for the 1.4 version of the app, use this protocol:
  * [Test result token protocol version 2](legacy/test-result-provisioning-2.4.1.md)

* For providers who are preparing for version 2.0 of the app and/or to hand out results that can be used for a European DCC, you will need to connect using one of these protocols:
  * [Test/vaccination/recovery token based protocol version 3](providing-events-by-token.md)
  * [Test/vaccination/recovery digid based protocol version 3](providing-events-by-digid.md)

When in doubt, discuss this with your CoronaCheck liaison. 

## Data structures overview:

An overview with samples of the various datastructures can be [found here](data-structures-overview.md). 

## Other relevant documentation

To understand how the apps use certificate pinning, and what this means for your signing and SSL certificates, can be found in the (pinning document)[x509-pinning-test-providers-1.08.pdf].