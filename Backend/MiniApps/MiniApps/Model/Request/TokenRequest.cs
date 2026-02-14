#nullable disable

namespace MiniApps.Model.Request
{
    public class TokenRequest
    {
        public string UserUuid { get; set; }

        public string EmailAddress { get; set; }

        public string Role { get; set; }
    }
}
