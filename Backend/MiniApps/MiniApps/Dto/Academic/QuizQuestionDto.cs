#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class QuizQuestionDto : AuditableDto<string>
    {
        public string QuizUuid { get; set; }
        public string QuestionUuid { get; set; }
        public int QuestionOrder { get; set; }

        // Flattened question fields for display
        public string QuestionText { get; set; }
        public string CorrectOption { get; set; }
        public string Difficulty { get; set; }
        public List<QuestionOptionDto> Options { get; set; } = new List<QuestionOptionDto>();
    }
}
