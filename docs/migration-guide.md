# CoronaCheck Protocol Version Migration Guide

## Introduction

In the past months the protocol for providing results to the CoronaCheck app has been enhanced. Every time we introduced backward incompatible changes, we updated the protocol version.

The following versions exist:

| Version | Active use | Planning | Remarks |
| --- | --- | --- | --- |
| 1.0 | NO | This was the original protocol and used only during Fieldlab trials. It only supported negative test results. This protocol is no longer in use. There are no clients that use this protocol, so it doesn't have to be implemented. |
| 2.0 | YES | To be phased out by July 1st | The second generation introduced light personally identifiable information (pii) to be able to validate if a proof belongs to the person showing it. This protocol is in use in the 1.4 version of the apps which are currently still out in the field. |
| 3.0 | YES | To be introduced from mid-June | The 3.0 version introduced support for vaccinations and recovery, and contains the dataset that is required to be able to generate European DCC QR codes. This version will be released in version 2.0 of the apps, which are planned for end of June. |

Current recommendation for **new** providers: implement 3.0 and go live after July 1st. If it is important to go live before July 1st, a provider should implement both 2.0 and 3.0 responses.

The data structures for each protocol version are documented in the [Date Structures Document](data-structures-overview.md).

## Dealing with multiple versions

Sometimes we introduce a new version of the protocol, and while users update their apps, for a brief period multiple versions are in the field. Also sometimes we define a new version of the protocol and it's not in active use yet, but we do want providers to start implementing support for it.

To cope with these scenarios each app sends a `CoronaCheck-Protocol-Version: x.x` to provider backends. The version in the header is the *highest* protocol version that the app supports.

For example, when the app sends `CoronaCheck-Protocol-Version: 3.0`, the app supports 3.0 but also 2.0 responses. Providers should never return a response higher than the version indicated by the app. A lower version is allowed as long as it's still in active use (See [Introduction](#introduction).

When the app sends `CoronaCheck-Protocol-Version: 2.0`, then the API should not return any 3.0 responses.

## Migration from Protocol 2.0 to Protocol 3.0

The 3.0 protocol follows the same endpoints and communication as the 2.0 protocol. The changes are isolated to the result JSON objects that the APIs return.

For existing providers who currently support protocol 2.0, the following bullets are the most important changes in the 3.0 datastructure:

* The result now contains an array of events. Each event has a type. This is done for compatibility with vaccinations. Note that you should still only provide the most recent test result, so the array for negative tests will always just contain a single item.
* In 2.0, the holder data only contains initials and birth month / day. In 3.0 this should be changed to include the full names and the full birth date. This is necessary for EU compatiblility.
* The initial normalization that was done on the initials (é -> E, 't -> T etc) is not necessary in 3.0, as CoronaCheck will take care of that based on the full names.
* The test types have changed from plain `pcr`, `pcr-lamp`, `antigen` and `breathalizer` to an EU code system. **Please ensure that the tests you are using are available in the EU code system**. The data should now be derived from:
    *  The [EU valueset for types](https://github.com/ehn-dcc-development/ehn-dcc-schema/blob/main/valuesets/test-type.json).
    *  The [EU valueset for manufacturers](https://github.com/ehn-dcc-development/ehn-dcc-schema/blob/main/valuesets/test-manf.json)
*  The 'name' field for the test is arbitrary and can be set to the name of the test you use. This will be replaced with a valueset in a future version of the specification.
*  The test facility should be included. Note: there's currently a debate about the significance of this field and it may be dropped from the spec. For now it's safer to provide it if available. 
   
Comparison of the responses:

**2.0**

```javascript
{
    "protocolVersion": "2.0",
    "providerIdentifier": "XXX",
    "status": "complete",
    "result": {
        "sampleDate": "2020-10-10T10:00:00Z", // rounded down to nearest hour
        "testType": "pcr", // must be one of pcr, pcr-lamp, antigen, breath
        "negativeResult": true,
        "unique": "kjwSlZ5F6X2j8c12XmPx4fkhuewdBuEYmelDaRAi",
        "isSpecimen": true, // Optional
        "holder": {
            "firstNameInitial": "J", // Normalized
            "lastNameInitial": "D", // Normalized
            "birthDay": "31", // String, but no leading zero, e.g. "4"
            "birthMonth": "12" // String, but no leading zero, e.g. "4"
        }
    }
}
```

**3.0**

```javascript
{
    "protocolVersion": "3.0",
    "providerIdentifier": "XXX",
    "status": "complete", // This refers to the data-completeness, not test status.
    "holder": {
        "firstName": "",
        "infix": "",
        "lastName": "",
        "birthDate": "1970-01-01" // yyyy-mm-dd (see details below)
    },
    "events": [
        {
            "type": "negativetest",
            "unique": "ee5afb32-3ef5-4fdf-94e3-e61b752dbed7",
            "isSpecimen": true,
            "negativetest": {
                "sampleDate": "2021-01-01T10:00:00Z", 
                "negativeResult": true,
                "facility": "GGD XL Amsterdam",
                "type": "LP6464-4",
                "name": "???",
                "manufacturer": "1232"
            }
        }
    ]    
}
```
