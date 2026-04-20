#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class QuestionGradeDto : AuditableDto<string>
    {
        public string QuestionUuid { get; set; }

        public string GradeUuid { get; set; }

        public string GradeName { get; set; }

        /// <summary>easy | medium | hard</summary>
        public string Difficulty { get; set; }
    }
}
