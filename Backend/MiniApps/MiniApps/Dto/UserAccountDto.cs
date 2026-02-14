#nullable disable

using MA.Framework.Dto.Base;

namespace MiniApps.Dto
{
    public class UserAccountDto : AuditableDto<string>
    {
        public string EmailAddress { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string FullName => this.FirstName + " " + this.LastName;

        public string TimeZoneId { get; set; }

        public bool IsArchived { get; set; }

        public string RoleName { get; set; }

        public string Password { get; set; }

        public string RefreshToken { get; set; }
    }
}
