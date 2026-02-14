#nullable disable

using MA.Framework.Dto.Base;

namespace MiniApps.Dto
{
    public class UserMembershipDto : AuditableDto<string>
    {
        public string UserUuid { get; set; }

        public string Password { get; set; }
    }
}
