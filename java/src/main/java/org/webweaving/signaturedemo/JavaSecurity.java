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

import org.bouncycastle.asn1.ASN1InputStream;
import org.bouncycastle.asn1.ASN1Primitive;
import org.bouncycastle.asn1.cms.ContentInfo;
import org.bouncycastle.asn1.x509.Certificate;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cms.CMSProcessableByteArray;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.cms.CMSSignedDataGenerator;
import org.bouncycastle.cms.SignerInformation;
import org.bouncycastle.cms.SignerInformationStore;
import org.bouncycastle.cms.SignerInformationVerifier;
import org.bouncycastle.cms.jcajce.JcaSignerInfoGeneratorBuilder;
import org.bouncycastle.cms.jcajce.JcaSimpleSignerInfoVerifierBuilder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.operator.jcajce.JcaDigestCalculatorProviderBuilder;
import org.bouncycastle.util.Store;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.X509Certificate;
import java.util.Base64;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class JavaSecurity {

    private static final String ALIAS = "aliasname";
    private String keystoreFile;
    private char[] password;

    public JavaSecurity(String keystoreFile, String password) {
        Security.addProvider(new BouncyCastleProvider());
        if (keystoreFile != null) {
            this.keystoreFile = keystoreFile;
            this.password = password.toCharArray();
        }
    }

    /**
     * Convenience method to pass payload as a string instead of byte array.
     * @param payload
     * @return
     */
    public Map<String, String> sign(String payload) {
        return sign(payload.getBytes());
    }

    /**
     * Not using a json library is deliberate.
     * returns
     * <code>
     *     {
     *         "payload": base64 of payload
     *         "signature: base64 of signature of payload
     *     }
     * </code>
     * @param payload
     * @return
     */
    public Map<String, String> sign(byte[] payload) {
        Map<String, String> result = new HashMap<>();
        result.put("payload", new String(Base64.getEncoder().encode(payload)));
        try {
            KeyStore store = getKeyStore();
            X509Certificate cert = getCertificate(store);
            PrivateKey pk = (PrivateKey) store.getKey(ALIAS, password);
            CMSSignedDataGenerator gen = new CMSSignedDataGenerator();
            // convert java.security certificate to buoncycastle
            X509CertificateHolder certHolder = new X509CertificateHolder(Certificate.getInstance(cert.getEncoded()));
            gen.addCertificate(certHolder);
            ContentSigner sha1Signer = new JcaContentSignerBuilder(cert.getSigAlgName()).setProvider("BC").build(pk);
            gen.addSignerInfoGenerator(new JcaSignerInfoGeneratorBuilder(new JcaDigestCalculatorProviderBuilder().build()).build(sha1Signer, certHolder));
            CMSProcessableByteArray msg = new CMSProcessableByteArray(payload);
            CMSSignedData signedData = gen.generate(msg);
            result.put("signature", new String(Base64.getEncoder().encode(signedData.getEncoded("DER"))));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * checks the if the signature is the expected one
     * @param signatureEncoded (assumed base64 encoded value).
     * @param payloadEncoded assumed base64 encoded.
     * @return
     */
    public boolean verify(String signatureEncoded, String payloadEncoded) {
        byte[] signature = Base64.getDecoder().decode(signatureEncoded);
        byte[] payload = Base64.getDecoder().decode(payloadEncoded);
        System.out.println(new String(payload));
        return verify(signature, payload);
    }

    public boolean verify(byte[] signature, byte[] payload) {
        boolean result = false;
        try {
            ASN1Primitive asn = null;
            try(ByteArrayInputStream bIn = new ByteArrayInputStream(signature)) {
                try(ASN1InputStream aIn = new ASN1InputStream(bIn)) {
                    asn = aIn.readObject();
                }
            }
            ContentInfo contentInfo = ContentInfo.getInstance(asn);
            CMSSignedData s = new CMSSignedData(new CMSProcessableByteArray(payload), contentInfo);
            Store certs = s.getCertificates();
            SignerInformationStore signers = s.getSignerInfos();
            SignerInformation signer = signers.getSigners().iterator().next();
            X509CertificateHolder certHolder = ((Collection<X509CertificateHolder>)certs.getMatches(signer.getSID())).iterator().next();
            SignerInformationVerifier verifier = new JcaSimpleSignerInfoVerifierBuilder().build(certHolder);
            result = signer.verify(verifier);
        }catch(Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private KeyStore getKeyStore() {
        KeyStore result = null;
        try {
            result = KeyStore.getInstance("PKCS12");
            result.load(new FileInputStream(keystoreFile), password);
        }catch(Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private X509Certificate getCertificate(KeyStore store) {
        X509Certificate result = null;
        try {
            result = (X509Certificate) store.getCertificate(ALIAS);
        } catch (KeyStoreException e) {
            e.printStackTrace();
        }
        return result;
    }

}
