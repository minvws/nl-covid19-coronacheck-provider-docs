// Copyright 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
// Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
// SPDX-License-Identifier: EUPL-1.2

namespace CmsSigner.Cms
{
    public interface IContentSigner
    {
        //TODO dead code
        //https://docs.microsoft.com/en-us/windows/win32/api/wincrypt/ns-wincrypt-crypt_algorithm_identifier
        string SignatureOid { get; }
        byte[] GetSignature(byte[] content, bool excludeCertificates = false);
    }
}