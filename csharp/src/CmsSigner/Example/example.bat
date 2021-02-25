CmsSigner -i test.txt -s sign.pfx -p corona2020 -c chain.p7b > signed.json
CmsSigner -v -i signed.json -s sign.pfx -p corona2020 -c chain.p7b