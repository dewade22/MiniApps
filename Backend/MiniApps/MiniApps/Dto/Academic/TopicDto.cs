#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class TopicDto : AuditableDto<string>
    {
        public string Name { get; set; }

        public string SubjectUuid { get; set; }
    }
}
