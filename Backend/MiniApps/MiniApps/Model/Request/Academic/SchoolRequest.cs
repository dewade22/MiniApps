#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.Academic
{
    public class SchoolRequest
    {
        [Required]
        [StringLength(200, MinimumLength = 3)]
        public string Name { get; set; }

        [Required]
        [StringLength(20, MinimumLength = 3)]
        public string Code { get; set; }

        [Required]
        public string Address { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 2)]
        public string City { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 2)]
        public string Province { get; set; }

        [Required]
        [StringLength(10)]
        public string PostalCode { get; set; }

        [Required]
        [StringLength(20)]
        public string Phone { get; set; }

        [Required]
        [EmailAddress]
        [StringLength(150)]
        public string Email { get; set; }

        [StringLength(200)]
        public string Website { get; set; }

        [Required]
        [StringLength(150, MinimumLength = 3)]
        public string PrincipalName { get; set; }

        [Required]
        [RegularExpression("^(A|B|C|Not Yet)$", ErrorMessage = "Accreditation must be A, B, C, or Not Yet")]
        public string Accreditation { get; set; } = "Not Yet";

        [Required]
        [RegularExpression("^(Public|Private)$", ErrorMessage = "SchoolType must be Public or Private")]
        public string SchoolType { get; set; } = "Public";

        [Required]
        [RegularExpression("^(SD|SMP|SMA|SMK)$", ErrorMessage = "EducationLevel must be SD, SMP, SMA, or SMK")]
        public string EducationLevel { get; set; }

        public bool IsActive { get; set; } = true;
    }
}
