#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.UserManagement
{
    public class RoleRequest
    {
        [Required]
        [StringLength(100, MinimumLength = 3)]
        public string RoleName { get; set; }
    }
}
