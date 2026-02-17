#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.Grade
{
    public class SubjectRequest
    {
        [Required]
        [StringLength(100, MinimumLength = 3)]
        public string SubjectName { get; set; }
    }
}
