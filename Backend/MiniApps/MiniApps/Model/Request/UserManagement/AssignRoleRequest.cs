#nullable disable

using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.UserManagement
{
    public class AssignRoleRequest
    {
        [Required]
        public string EmailAddress { get; set; }

        [Required]
        public string RoleUuid { get; set; }
    }
}
