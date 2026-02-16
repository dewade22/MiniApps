#nullable disable

using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Common
{
    public class UserInRoleDto : AuditableDto<string>
    {
        public string UserUuid { get; set; }

        public string RoleUuid { get; set; }
    }
}
