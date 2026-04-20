#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class QuestionDto : AuditableDto<string>
    {
        public string QuestionText { get; set; }

        public string TopicUuid { get; set; }

        public string CorrectOption { get; set; }

        public List<QuestionOptionDto> Options { get; set; } = new List<QuestionOptionDto>();

        public List<QuestionGradeDto> Grades { get; set; } = new List<QuestionGradeDto>();
    }
}
