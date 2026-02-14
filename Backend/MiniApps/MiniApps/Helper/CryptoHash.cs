using System.Web.Helpers;

namespace MiniApps.Helper
{
    public class CryptoHash
    {
        public static string HashedString(string data)
        {
            return Crypto.HashPassword(data);
        }

        public static bool Verify(string data, string hashedData)
        {
            return Crypto.VerifyHashedPassword(hashedData, data);
        }
    }
}
