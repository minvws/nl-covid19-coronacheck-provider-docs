// Copyright 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
// Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
// SPDX-License-Identifier: EUPL-1.2

using System.Security.Cryptography.X509Certificates;

namespace CmsSigner.Certificates
{
    internal class CertProvider : ICertificateProvider
    {
        private readonly X509Certificate2 _cert;
        public CertProvider(X509Certificate2 cert) => _cert = cert;
        public X509Certificate2 GetCertificate() => _cert;
    }
}