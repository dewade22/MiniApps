#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Common
{
    public class UserRefreshTokenDto : AuditableDto<string>
    {
        public string UserUuid { get; set; }

        public string RefreshToken { get; set; }
    }
}
