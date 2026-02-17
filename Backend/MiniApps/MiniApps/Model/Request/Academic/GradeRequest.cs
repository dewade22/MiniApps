#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.Grade
{
    public class GradeRequest
    {
        [Required]
        [StringLength(100, MinimumLength = 1)]
        public string GradeName { get; set; }
    }
}
