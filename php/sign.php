<?php

$payloadfile = "example.json";
$encode_payloadfile = "example.b64";
$sigfile = "signed.out";

$payload = fread(fopen($payloadfile, "r"),filesize($payloadfile));

$fot = fopen($encode_payloadfile,"w");
fwrite($fot,base64_encode($payload));
fclose($fot);

if (!(openssl_cms_sign(
	$payloadfile, $sigfile,
	"file://client.pem",  
	array("file://client.key","changeme"), 
	null, 
	PKCS7_DETACHED | PKCS7_BINARY,
	OPENSSL_ENCODING_DER, # ignore the manual; OPENSSL is wrong.
	"chain.pem", # Don't ask - but note file prefix..
))) exit(1);


$b64_p = fread(fopen($encode_payloadfile, "r"),filesize($encode_payloadfile));
$b64_s = base64_encode(fread(fopen($sigfile, "r"),filesize($sigfile)));

echo "{\"payload\":\"$b64_p\",\"signature\":\"$b64_s\"}";
