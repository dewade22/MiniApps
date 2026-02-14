#nullable disable

using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Authentication
{
    public class LoginRequest
    {
        [Required]
        [StringLength(100, MinimumLength = 5)]
        [MaxLength]
        public string Email { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 5)]
        [MaxLength]
        public string Password { get; set; }
    }
}
