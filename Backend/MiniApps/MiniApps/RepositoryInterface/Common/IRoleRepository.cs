using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Common;

namespace MiniApps.RepositoryInterface.Common
{
    public interface IRoleRepository : IBaseRepository<RolesDto>
    {
        Task<RolesDto> ReadByName(string name);
    }
}
