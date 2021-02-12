/**
 * The code (the work) that is created for the Dutch Corona app is available under the EUPL/1.2 license; and any outside contributions to it are under an individual Committer License Agreement (iCLA) that references this license explicitly.
 *
 * However - that does not mean that all (derived) work is solely under that single license.
 *
 * For example - where appropriate certain (open source) modules may be required and included in the Corona App. These will remain under their original Copyright and License (though some of the Corona App specific changes may released under the be EUPL/1.2 if they are unsuitable to be contributed back upstream).
 *
 * Secondly - it is a general policy of the ‘Rijksoverheid’ to release its websites and documents under the CC0 license provided that any further use or citations do not infringe or suggest that an endorsement or similar from the Government of the Netherlands (https://www.rijksoverheid.nl/copyright). For this purposes, documentation of this project is held in the directory ‘documentation’.
 *
 * Finally - there is a certain set of creative assets; such as the logo of the Government of the Netherlands and for example certain fonts which are “for official use only”. These files are labeled explicitly as not available under a EUPL/1.2 or CC0 license.
 *
 * -- v1.00 / 2020-5-17
 */
package org.webweaving.signaturedemo;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.Map;

public class SignatureDemo {

    private static final String HELP = "Expected sign | verify keystore keystorepassword [payload]\n Payload is optional if you use pipes";

    private String keyStore;
    private String password;
    private String payloadFile;

    public static void main(String[] args) {
        if(args.length < 3) {
            // command and config
            System.out.println(HELP);
            System.exit(1);
        }
        SignatureDemo demo = new SignatureDemo();
        demo.keyStore = args[1];
        demo.password = args[2];
        demo.payloadFile = args.length == 4 ? args[3] : null;
        String action = args[0];
        if  (action.equalsIgnoreCase("verify")) {
            if(!demo.verify()) {
                throw new RuntimeException("Verify failed");
            } else {
                System.out.println("Verification succesful");
            }
        } else if (action.equalsIgnoreCase("sign")) {
            demo.sign();
        } else {
            System.out.println("Unknown parameter");
            System.out.println(HELP);
        }
    }

    public void sign() {
        JavaSecurity js = new JavaSecurity(keyStore, password);
        byte[] payload = readFromStdin();
        Map<String, String> data = js.sign(payload);
        StringBuffer json = new StringBuffer();
        json.append("[{\n");
        json.append("\"payload\":");
        json.append("\""+data.get("payload")+"\",\n");
        json.append("\"signature\":");
        json.append("\""+data.get("signature")+"\"\n");
        json.append("}]");
        System.out.println(json);
    }

    public boolean verify() {
        JavaSecurity js = new JavaSecurity(keyStore, password);
        String sigpay = new String(readFromStdin());
        String signature = getValue("signature", sigpay);
        String payload = getValue("payload", sigpay);
        return js.verify(signature, payload);
    }

    private byte[] readFromStdin() {
        byte[] result = null;
        if(payloadFile != null) {
            try (FileInputStream fis = new FileInputStream(payloadFile)) {
                result = fis.readAllBytes();
            } catch (Exception e) {
                System.out.println("Could not load payload");
                e.printStackTrace();
                System.exit(1);
            }
        } else {
            // read from stdin
            try (BufferedReader bur = new BufferedReader(new InputStreamReader(System.in))) {
                StringBuffer sb = new StringBuffer();
                String line = "";
                while ((line = bur.readLine()) != null) {
                    sb.append(line);
                }
                System.out.println(sb);
                result = sb.toString().getBytes();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    private String getValue(String key, String data) {
        int start = data.indexOf(key)+key.length()+2;
        start = data.indexOf("\"",start)+1;
        int end = data.indexOf("\"", start);
        return data.substring(start, end);
    }
}
