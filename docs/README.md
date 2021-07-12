# Provider documentation

## Connection documentation

Depending on your situation, you need one of these docs:

  * [Test/vaccination/recovery token based protocol version 3](providing-events-by-token.md) - For (usually commercial) providers who hand out 'retrieval codes'.
  * [Test/vaccination/recovery digid based protocol version 3](providing-events-by-digid.md) - For RIVM/GGD or other providers who are allowed to do BSN based retrieval

Providers that are still on the 2.0 protocol can use this 2.0 tagged doc for reference of their current implementation:
  * [Test result token protocol version 2](legacy/test-result-provisioning-2.4.1.md)

When in doubt which version to use, discuss this with your CoronaCheck liaison. 

## Data structures overview:

An overview with samples of the various datastructures can be [found here](data-structures-overview.md). 

## Other relevant documentation

To understand how the apps use certificate pinning, and what this means for your signing and SSL certificates, can be found in the (pinning document)[x509-pinning-test-providers-1.08.pdf].
