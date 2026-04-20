#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class SchoolDto : AuditableDto<string>
    {
        public string Name { get; set; }
        public string Code { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Province { get; set; }
        public string PostalCode { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Website { get; set; }
        public string PrincipalName { get; set; }
        public string Accreditation { get; set; }
        public string SchoolType { get; set; }
        public string EducationLevel { get; set; }
        public bool IsActive { get; set; }
    }
}
