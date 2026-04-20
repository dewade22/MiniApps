using MA.Framework.Service;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.ServiceInterface.Academic;

namespace MiniApps.Service.Academic
{
    public class SchoolService : BaseService<SchoolDto, string, ISchoolRepository>, ISchoolService
    {
        public SchoolService(ISchoolRepository repository) : base(repository)
        {
        }
    }
}
