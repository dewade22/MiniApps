#nullable disable

using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.UserManagement
{
    public class CreateUserRequest
    {
        [Required]
        [EmailAddress]
        public string EmailAddress { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 3)]
        [MaxLength]
        public string FirstName { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 3)]
        [MaxLength]
        public string LastName { get; set; }

        [Required]
        public string TimeZoneId { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 3)]
        public string Password { get; set; }
    }
}
