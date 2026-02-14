#nullable disable

using MA.Framework.Dto.Base;

namespace MiniApps.Dto
{
    public class RolesDto : AuditableDto<string>
    {
        public string RoleName { get; set; }
    }
}
