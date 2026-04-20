#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class QuizTopicDto : AuditableDto<string>
    {
        public string QuizUuid { get; set; }
        public string TopicUuid { get; set; }
        public string TopicName { get; set; }
    }
}
