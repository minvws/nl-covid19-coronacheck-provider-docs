# CoronaCheck Provider Test Suite

Version 0.3 - 24th June 2021

In the CoronaCheck project we are providing sample test data to Test Providers that we advice the Test Providers contain within their system. Combined with the Test Provider Test Portal, this enables Test Providers to conduct an end-to-end test of their endpoints.

## Test Portal

VWS provides a web front-end through which Test Providers can test their endpoints. Data entered through this web front-end will be sent to a given endpoint and show the response it receives from it.

On the web front-end the user will need to enter:
The TOKEN element of the retrieval code (the Y-part from XXX-YYYYYYYYYYYYY-ZV).
The end-point that the test service needs to address

After the test service has been called, the exact return values will be shown to the user.

A standardized test set has been provided. It is up to the Test Provider to ensure that this data is recorded in their database, such that this VWS web front-end can be used against an existing and known test set.

This Test Portal can be found here: [https://provider.coronacheck.nl/](https://provider.coronacheck.nl/)

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

## Test Data

The data that the Test Provider should maintain in their system can be found in this repository. This data has been provided as a means to conduct end-to-end testing via the above mentioned portal.

How the data is represented in the Test Provider database is up to the implementor of that database.

### V3 Test Data

The data is defined as follows for V3:

| field name               | type               | description                                                      |
|--------------------------|--------------------|------------------------------------------------------------------|
| token                    | string             | the token that is going to be used to retrieve the test data     |
| protocolVersion          | string             | the version number of the interface                              |
| providerIdentifier       | string             | the three-letter code for the test provider                      |
| unique                   | string             | the unique number of the test                                    |
| sampleDate               | string (date/time) | the date and time of when the sample was taken                   |
| eventType                | string             | the type of event:                               				   |
| 			               |                    |    `V` for Vaccination										   |
| 			               |                    |    `R` for Recovery										   	   |
| 			               |                    |    `P` for Positive Test										   |
| 			               |                    |    `N` for Negative Test										   |
| productType              | string             | the type of the test or vaccination from the EU valueset		   |
| isSpecimen               | boolean            | if this data refers to a specimen (always TRUE)                  |
| negativeResult           | boolean            | if the result of the test was negative then TRUE				   |
| positiveResult           | boolean            | if the result of the test was positive then TRUE			       |
| country                  | string             | the country code from the EU country valuesets				   |
| facility                 | string             | the name of the facility where the test/vaccine occurred         |
| brand                    | string             | the brand of the vaccine from the EU vaccine brand valueset      |
| manufacturer             | string             | the manufacturer from the EU test/vaccine manufacturer list      |
| namePrefix               | string             | any letters, or titles that go in front of the persons' name     |
| firstName                | string             | the full first name of the person                                |
| nameInfix                | string             | any letters or words that go in between first and last name      |
| lastName                 | string             | the full last name of the person                                 |
| namePostfix              | string             | any letters or titles that go after the persons' last name       |
| dateOfBirth              | string (date)      | the date of birth of the person                                  |
| expectedReturnCode       | int                | the HTTP return code that is expected                            |
| expectedStatus           | string             | the status code that is expected                                 |
| expectedSampleDate       | string (date/time) | the expected date and time when the test sample was taken        |
| expectedNegativeResult   | boolean            | the expected value if the test result was negative (always TRUE) |
| expectedTestType         | string             | the expected test type                                           |
| expectedIsSpecimen       | boolean            | the expected specimen indicator (always TRUE)                    |
| expectedFirstName		   | string             | the expected first name										   |
| expectedInfix			   | string             | the expected infix											   |
| expectedLastName		   | string             | the expected last name										   |
| expectedDateOfBirth	   | string (date/time) | the expected  date of birth of the person             		   |
| testTitle                | string             | the name of the specific test record                             |

The official valuesets are available here:

* Countries: [EU Country List](https://github.com/ehn-dcc-development/ehn-dcc-valuesets/blob/release/1.3.0/country-2-codes.json)
* Brands (vaccine): [EU Vaccine Product List](https://github.com/ehn-dcc-development/ehn-dcc-valuesets/blob/release/1.3.0/vaccine-medicinal-product.json)
* Manufacturers (vaccine): [EU Vaccine Manufacturer List](https://github.com/ehn-dcc-development/ehn-dcc-valuesets/blob/release/1.3.0/vaccine-mah-manf.json)
* Manufacturers (tests): [EU Test Manufacturer List](https://github.com/ehn-dcc-development/ehn-dcc-valuesets/blob/main/test-manf.json)
* Product types (tests): [EU Test types](https://github.com/ehn-dcc-development/ehn-dcc-schema/blob/main/valuesets/test-type.json)
* Product types (vaccine): [EU Vaccine types](https://github.com/ehn-dcc-development/ehn-dcc-schema/blob/main/valuesets/vaccine-prophylaxis.json)

The data can be found [here](default-test-cases-v3.csv).

### V2 Test Data

The data is defined as follows for V2:

| field name               | type               | description                                                      |
|--------------------------|--------------------|------------------------------------------------------------------|
| token                    | string             | the token that is going to be used to retrieve the test data     |
| protocolVersion          | string             | the version number of the interface                              |
| providerIdentifier       | string             | the three-letter code for the test provider                      |
| unique                   | string             | the unique number of the test                                    |
| sampleDate               | string (date/time) | the date and time of when the sample was taken                   |
| testType                 | string             | the type of the test that was taken                              |
| isSpecimen               | boolean            | if this data refers to a specimen (always TRUE)                  |
| negativeResult           | boolean            | if the result of the test was negative (always TRUE)             |
| namePrefix               | string             | any letters, or titles that go in front of the persons' name     |
| firstName                | string             | the full first name of the person                                |
| nameInfix                | string             | any letters or words that go in between first and last name      |
| lastName                 | string             | the full last name of the person                                 |
| namePostfix              | string             | any letters or titles that go after the persons' last name       |
| dateOfBirth              | string (date)      | the date of birth of the person                                  |
| expectedReturnCode       | int                | the HTTP return code that is expected                            |
| expectedStatus           | string             | the status code that is expected                                 |
| expectedSampleDate       | string (date/time) | the expected date and time when the test sample was taken        |
| expectedNegativeResult   | boolean            | the expected value if the test result was negative (always TRUE) |
| expectedTestType         | string             | the expected test type                                           |
| expectedIsSpecimen       | boolean            | the expected specimen indicator (always TRUE)                    |
| expectedFirstNameInitial | character          | the expected first name initial                                  |
| expectedLastNameInitial  | character          | the expected last name initial                                   |
| expectedBirthDay         | int                | the expected day-of-month of the persons' birth date             |
| expectedBirthMonth       | int                | the expected month of the persons' birth date                    |
| testTitle                | string             | the name of the specific test record                             |

The data can be found [here](default-test-cases-v2.csv)

### Updating the data prior to testing

The tokens cannot be older than 40 hours. In order to be able to test properly, the `sampleData` field in your database needs to be updated to something sensible. For testing, we suggest to update the sample dates in the test providers' database prior to using this portal, and set these to `now()`. That way, the test cases will send the appropriate `expectedStatus`. Only the test cases for token `LLBULLBULLBU` and `VSBQVSBQVSBQ` should not be updated. These two tests are specifically focussing on expired and pending tests.

### Submitting new test cases

If you uncover additional test cases, that could be helpful for VWS and / or other test providers -- and as such make this service even more useful, please add these to the [default test cases](default-test-cases.csv) CSV file and create a pull request on this repository.

This also means that it may be a good idea to put a Watch on this repository, as we will be adding new test records as and when we receive them.
