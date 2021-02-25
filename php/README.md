# Running this example

1)	generate a chain by doing

     sh genkeys.sh

2)	try a signature

     php sign.php

3)	validate the signature against the CA

     php sign.php  | sh -x ../shellscript/verify.sh ca.pem

### Sample output signature

The results should look like:

```
% php sign.php  | sh  ../shellscript/verify.sh ca.pem 
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
Verification successful
```

Note the last line. 

### Against a real signature

To run this against a real signature use;

    % php sign.php  | sh  ../shellscript/verify.sh NL-PKI-Root.pem 
    
Wehere ```NL-PKI-Root.pem``` is obtained from https://cert.pkioverheid.nl/cert-pkioverheid-nl.htm its entry for the Stamcertificaat and converted with:

    curl https://cert.pkioverheid.nl/RootCA-G3.cer |\
          openssl x509 -inform DER -out  NL-PKI-Root.pem 

