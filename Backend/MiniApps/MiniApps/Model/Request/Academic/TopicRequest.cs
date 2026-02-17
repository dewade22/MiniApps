#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.Academic
{
    public class TopicRequest
    {
        [Required]
        [StringLength(100, MinimumLength = 3)]
        public string TopicName { get; set; }

        [Required]
        public string SubjectUuid { get; set; }
    }
}
