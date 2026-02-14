#nullable disable

namespace MA.Framework.Authorization
{
    public class InternalJwtConfig
    {
        public const string jwt = "JWT";

        public string Key { get; set; }

        public string Issuer { get; set; }

        public string Audience { get; set; }
    }
}
