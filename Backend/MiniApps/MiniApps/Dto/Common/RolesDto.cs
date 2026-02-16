#nullable disable

using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Common
{
    public class RolesDto : AuditableDto<string>
    {
        public string RoleName { get; set; }
    }
}
