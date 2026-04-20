#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.Academic
{
    public class QuestionOptionRequest
    {
        [Required]
        [StringLength(1, MinimumLength = 1)]
        public string Label { get; set; }

        [Required]
        public string OptionText { get; set; }
    }

    public class QuestionGradeRequest
    {
        [Required]
        public string GradeUuid { get; set; }

        /// <summary>easy | medium | hard</summary>
        [Required]
        [RegularExpression("^(very easy|easy|medium|hard|very hard)$", ErrorMessage = "Difficulty must be very easy, easy, medium, hard, or very hard")]
        public string Difficulty { get; set; } = "medium";
    }

    public class QuestionRequest
    {
        [Required]
        public string QuestionText { get; set; }

        public string TopicUuid { get; set; }

        /// <summary>Stores the actual answer text (not the label), so options can be shuffled.</summary>
        [Required]
        public string CorrectOption { get; set; }

        [Required]
        [MinLength(4)]
        [MaxLength(5)]
        public List<QuestionOptionRequest> Options { get; set; }

        public List<QuestionGradeRequest> Grades { get; set; } = new List<QuestionGradeRequest>();
    }
}
