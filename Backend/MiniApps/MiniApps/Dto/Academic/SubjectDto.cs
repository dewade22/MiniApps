
#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class SubjectDto : AuditableDto<string>
    {
        public string Name { get; set; }
    }
}
