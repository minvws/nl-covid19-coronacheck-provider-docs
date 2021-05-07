# nl-covid19-coronacheck-app-coronatestprovider-portal

Version 0.1 - 7th May 2021


In the CoronaCheck project we are providing sample test data to Test Providers that we advice the Test Providers contain within their system. Combined with the Test Provider Test Portal (at https://aaaa), this enables Test Providers to conduct an end-to-end test of their endpoints.

## Test Portal
VWS provides a web front-end through which Test Providers can test their endpoints. Data entered through this web front-end will be sent to a given endpoint and show the response it receives from it.

On the web front-end the user will need to enter:
The TOKEN element of the retrieval code (the Y-part from XXX-YYYYYYYYYYYYY-ZV).
The end-point that the test service needs to address

After the test service has been called, the exact return values will be shown to the user.

A standardized test set has been provided. It is up to the Test Provider to ensure that this data is recorded in their database, such that this VWS web front-end can be used against an existing and known test set.

This Test Portal can be found here: 

### User Interface
The Test Portal contains the following fields:

```
[ URL                                              ]
[ Token                                          ^ ]
[ Verification code                                ] (optional)
```

After providing this information and hitting `Submit` the portal executes the following:

 * It sends a `POST` request to the provided URL
 * The Tokens that a user can select are presented as a drop-down. These are read from the accompanying test data set, that should be included in the Test Providers database.
 * This post request contains the following headers:
   - `Authorization: Bearer <Token>`
   - `CoronaCheck-Protocol-Version: 2.0`
 * And, if a Verification code was provided, the following JSON object is sent as data
   - `{ "verificationCode": "<Verification code>"}`

The values returned from this call are then presented to the user. Next to the returned values, the expected return values are also shown and it is clearly indicated which do not match the expected outcomes.
