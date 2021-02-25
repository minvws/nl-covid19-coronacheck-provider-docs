// Copyright 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
// Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
// SPDX-License-Identifier: EUPL-1.2

using System.Text.Json.Serialization;

namespace CmsSigner.Model
{
    public class SignedDataResponse
    {
        /// <summary>
        /// Bytes over which <see cref="Signature"/> was calculated, encoded as base64
        /// </summary>
        [JsonPropertyName("payload")] public string Payload { get; set; }

        /// <summary>
        /// CMS/PKCS#7 message containing the signature, encoded as base64
        /// </summary>
        [JsonPropertyName("signature")] public string Signature { get; set; }
    }
}
