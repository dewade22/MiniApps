using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Academic;

namespace MiniApps.RepositoryInterface.Academic
{
    public interface ISubjectRepository : IBaseRepository<SubjectDto>
    {
        Task<SubjectDto> ReadByName(string name);
    }
}
