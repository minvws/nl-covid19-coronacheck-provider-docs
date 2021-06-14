// Copyright 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
// Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
// SPDX-License-Identifier: EUPL-1.2

using System;
using System.Security.Cryptography;
using System.Security.Cryptography.Pkcs;
using System.Security.Cryptography.X509Certificates;
using CmsSigner.Certificates;

namespace CmsSigner.Cms
{
    public class CmsSignerEnhanced : IContentSigner
    {
        private readonly ICertificateProvider _certificateProvider;
        private readonly ICertificateChainProvider _certificateChainProvider;

        public CmsSignerEnhanced(ICertificateProvider certificateProvider, ICertificateChainProvider certificateChainProvider)
        {
            _certificateProvider = certificateProvider ?? throw new ArgumentNullException(nameof(certificateProvider));
            _certificateChainProvider = certificateChainProvider ?? throw new ArgumentNullException(nameof(certificateChainProvider));
        }

        public string SignatureOid => "2.16.840.1.101.3.4.2.1";

        public byte[] GetSignature(byte[] content, bool excludeCertificates = false)
        {
            if (content == null) throw new ArgumentNullException(nameof(content));

            var certificate = _certificateProvider.GetCertificate();

            if (!certificate.HasPrivateKey)
                throw new InvalidOperationException($"Certificate does not have a private key - Subject:{certificate.Subject} Thumbprint:{certificate.Thumbprint}.");

            var certificateChain = _certificateChainProvider.GetCertificates();

            var contentInfo = new ContentInfo(content);
            var signedCms = new SignedCms(contentInfo, true);
            
            signedCms.Certificates.AddRange(certificateChain);

            var signer = new System.Security.Cryptography.Pkcs.CmsSigner(SubjectIdentifierType.IssuerAndSerialNumber, certificate);
            var signingTime = new Pkcs9SigningTime(DateTime.UtcNow);
            if (excludeCertificates) signer.IncludeOption = X509IncludeOption.None;

            if (signingTime.Oid == null) throw new Exception("PKCS signing failed to due to missing time.");

            signer.SignedAttributes.Add(new CryptographicAttributeObject(signingTime.Oid, new AsnEncodedDataCollection(signingTime)));

            signedCms.ComputeSignature(signer);

            return signedCms.Encode();
        }
    }
}