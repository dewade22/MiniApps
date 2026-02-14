#nullable disable

using MA.Framework.Dto.Base;

namespace MiniApps.Dto
{
    public class UserInRoleDto : AuditableDto<string>
    {
        public string UserUuid { get; set; }

        public string RoleUuid { get; set; }
    }
}
