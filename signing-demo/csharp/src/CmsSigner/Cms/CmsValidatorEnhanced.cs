// Copyright 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
// Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
// SPDX-License-Identifier: EUPL-1.2

using System;
using System.Security.Cryptography;
using System.Security.Cryptography.Pkcs;
using CmsSigner.Certificates;

namespace CmsSigner.Cms
{
    public class CmsValidatorEnhanced : ICmsValidator
    {
        private readonly ICertificateProvider _certificateProvider;
        private readonly ICertificateChainProvider _certificateChainProvider;

        public CmsValidatorEnhanced(ICertificateProvider certificateProvider, ICertificateChainProvider certificateChainProvider)
        {
            _certificateProvider = certificateProvider ?? throw new ArgumentNullException(nameof(certificateProvider));
            _certificateChainProvider = certificateChainProvider ?? throw new ArgumentNullException(nameof(certificateChainProvider));
        }

        public bool Validate(byte[] content, byte[] signature)
        {

            if (content == null) throw new ArgumentNullException(nameof(content));
            if (signature == null) throw new ArgumentNullException(nameof(signature));

            var certificate = _certificateProvider.GetCertificate();

            var certificateChain = _certificateChainProvider.GetCertificates();

            var contentInfo = new ContentInfo(content);

            var signedCms = new SignedCms(contentInfo, true);

            signedCms.Certificates.Add(certificate);
            signedCms.Certificates.AddRange(certificateChain);

            signedCms.Decode(signature);

            try
            {
                signedCms.CheckSignature(true);
            }
            catch (CryptographicException)
            {
                return false;
            }

            return true;
        }
    }
}