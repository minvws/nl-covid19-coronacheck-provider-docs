## Simple Java example

### Tested with :
* Maven 3.6.0 and 3.6.3
* OpenJDK 14.0.1 and AdoptOpenJDK 15.02
* macOS Big Sur

### Dependencies
* Bouncy Castle for signing and verifying the CMS based signature.
* JUnit for the test.

### Build
Build it with

'''
mvn clean package
'''

The resulting (executable) jar will have Class-Path entries pointhing to your local maven2 repository, so this
makes it locked to your local machine.

### Run

To test it, you can run the following from the shellscript directory (please see notes on macOS in shellscript README)
```
./sign.sh | java -jar ../java/target/signaturedemo-1.0-SNAPSHOT.jar verify ./client.pfx corona2020
```
or if you have an external source with trusted certificate chain : 
```
curl --silent "https://your.trusted.website" | java -jar ../java/target/signaturedemo-1.0-SNAPSHOT.jar verify
```

### Notes

One goal was minimizing dependencies, since there are too many choices / preferences and leave that to the user to 
choose their own.