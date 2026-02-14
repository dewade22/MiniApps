using AutoMapper;
using MA.Framework.Repository;
using MiniApps.DataAccess.Application;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;

namespace MiniApps.Repository
{
    public class RoleRepository : BaseRepository<ApplicationContext, ComRole, RolesDto, string>, IRoleRepository
    {
        public RoleRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {

        }
    }
}
