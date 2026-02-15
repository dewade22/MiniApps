#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request
{
    public class RefreshTokenRequest
    {
        [Required]
        public string RefreshToken { get; set; }
    }
}
