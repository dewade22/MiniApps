using MA.Framework.RepositoryInterface;
using MiniApps.Dto;

namespace MiniApps.RepositoryInterface
{
    public interface IRoleRepository : IBaseRepository<RolesDto>
    {
        Task<RolesDto> ReadByName(string name);
    }
}
