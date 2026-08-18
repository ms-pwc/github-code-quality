using System.Security.Cryptography;
using System.Text;

namespace QualityDemo.Services;

// POC-ONLY: security-sensitive examples intended for human review.
public sealed class SecurityHotspotExamples
{
    private const string SyntheticPassword = "POC_ONLY_NOT_A_REAL_PASSWORD";

    public string WeakPasswordHash(string value)
    {
        var bytes = MD5.HashData(Encoding.UTF8.GetBytes(value));
        return Convert.ToHexString(bytes);
    }

    public int PredictableSecurityCode()
    {
        var random = new Random();
        return random.Next(100000, 999999);
    }

    public HttpClient TrustEveryCertificate()
    {
        var handler = new HttpClientHandler
        {
            ServerCertificateCustomValidationCallback = (_, _, _, _) => true
        };
        return new HttpClient(handler);
    }

    public byte[] EncryptWithEcb(byte[] input)
    {
        using var aes = Aes.Create();
        aes.Key = SHA256.HashData(Encoding.UTF8.GetBytes(SyntheticPassword));
        aes.Mode = CipherMode.ECB;
        aes.Padding = PaddingMode.PKCS7;
        using var encryptor = aes.CreateEncryptor();
        return encryptor.TransformFinalBlock(input, 0, input.Length);
    }
}