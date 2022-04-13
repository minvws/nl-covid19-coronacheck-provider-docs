# Provider documentation

## Connection documentation

Depending on your situation, you need one of these docs:

  * [Test/vaccination/recovery token based protocol version 3](providing-events-by-token.md) - For (usually commercial) providers who hand out 'retrieval codes'.
  * [Test/vaccination/recovery digid based protocol version 3](providing-events-by-digid.md) - For RIVM/GGD or other providers who are allowed to do BSN based retrieval


## Data structures overview:

An overview with samples of the various datastructures can be [found here](data-structures-overview.md). 

## Other relevant documentation

* To understand how the apps use certificate pinning, and what this means for your signing and SSL certificates, can be found in the [certificate guide](certificate-guide.md).
* If you work with a broker/intermediary for CoronaCheck, or if you are a broker, check the [broker documentation](brokers.md).
* If you have a ticket app and want to integrate with CoronaCheck via deeplinking, check the [App Deeplinks](app-deeplinks.md) doc.
