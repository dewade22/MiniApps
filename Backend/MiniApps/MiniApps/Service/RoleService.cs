using MA.Framework.Service;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;
using MiniApps.ServiceInterface;

namespace MiniApps.Service
{
    public class RoleService : BaseService<RolesDto, string, IRoleRepository>, IRoleService
    {
        public RoleService(IRoleRepository repository)
            : base(repository)
        {

        }
    }
}
