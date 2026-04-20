#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class QuestionOptionDto : AuditableDto<string>
    {
        public string QuestionUuid { get; set; }

        public string Label { get; set; }

        public string OptionText { get; set; }
    }
}
