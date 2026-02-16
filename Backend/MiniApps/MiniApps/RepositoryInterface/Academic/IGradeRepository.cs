using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Academic;

namespace MiniApps.RepositoryInterface.Academic
{
    public interface IGradeRepository : IBaseRepository<GradeDto>
    {
        Task<GradeDto> ReadByName(string name);
    }
}
