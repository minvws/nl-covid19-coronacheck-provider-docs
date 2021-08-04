# COVID-19 CoronaCheck App - Provider Documentation

## Introduction
This repository contains the technical documentation for Vaccination, Negative Test and Recovery providers of the Dutch COVID-19 CoronaCheck app.

## Contents

Here's an overview of relevant parts of this repository:

* [Documentation](docs/) - All technical documentation to connect to the CoronaCheck app
* [Templates](html-templates/) - HTML templates for providers integrating CoronaCheck into their frontends
* [Signing Demo](signing-demo/) - Demo / reference code for digitally signing responses and verifying the result
* [Test Suite](test-suite/) - Once you've implemented the endpoints, import our test suite to be able to verify your endpoints

## Getting started

### Test Providers

If you're a provider of covid-19 tests, the following documents are relevant to you:

1. [Data Structures Overview](docs/data-structures-overview.md) - The JSON responses that you should generate
2. [Providing Events by Token](docs/providing-events-by-token.md) - The endpoints you need to implement to allow users to retrieve test results via a token (all commercial providers).
3. [Providing Events by DigiD](docs/providing-events-by-digid.md) - The endpoints you need to implement to allow users to retrieve test results via DigiD (currently only GGD for negative tests).
4. [Migration Guide](docs/migration-guide.md) - For providers on version 2 of the protocol, this helps migrate to 3.0 
5. [Certificate Information](docs/x509-pinning-test-providers-1.08.pdf) - Documentation on which certificates you need to sign test results.
6. [Example Implementation](https://github.com/minvws/nl-covid19-coronacheck-app-coronatestprovider-example) - A reference implementation of a working test provider.

### Vaccination Providers

If you're a provider of vaccinations, the following documents are relevant to you:

1. [Data Structures Overview](docs/data-structures-overview.md) - The JSON responses that you should generate
2. [Providing Events by DigiD](docs/providing-events-by-digid.md) - The endpoints you need to implement to allow users to retrieve vaccination records via DigiD
3. [Certificate Information](docs/x509-pinning-test-providers-1.08.pdf) - Documentation on which certificates you need to sign recovery statements.

### Recovery Providers

If you're a provider of recovery statements (based on positive test results), the following documents are relevant to you:

1. [Data Structures Overview](docs/data-structures-overview.md) - The JSON responses that you should generate
2. [Providing Events by Token](docs/providing-events-by-token.md) - The endpoints you need to implement to allow users to retrieve recovery statements via a token.
2. [Providing Events by DigiD](docs/providing-events-by-digid.md) - The endpoints you need to implement to allow users to retrieve recovery statements via DigiD
3. [Certificate Information](docs/x509-pinning-test-providers-1.08.pdf) - Documentation on which certificates you need to sign recovery statements.

### Ticket app providers

If you have an app for access tickets and you want to integrate with the CoronaCheck app, the following document is relevant to you:

1. [Deeplink Integration](docs/app-deeplinks.md) - Documentation on deeplink integration between CoronaCheck and other apps.


## Other Relevant Repositories

* [Architecture Documentation](https://github.com/minvws/nl-covid19-coronacheck-app-coordination)
* [UX/UI Designs](https://github.com/minvws/nl-covid19-coronacheck-app-design)
* [Reference implementation of a dummy test provider](https://github.com/minvws/nl-covid19-coronacheck-app-coronatestprovider-example)

## Development & Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes.
This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a gpg key.


