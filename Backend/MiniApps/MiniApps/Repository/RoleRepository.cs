using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
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

        public async Task<RolesDto> ReadByName(string name)
        {
            var dbSet = this.Context.Set<ComRole>();
            var entity = await dbSet.FirstOrDefaultAsync(x => x.Rolename == name);
            if (entity == null)
            {
                return null;
            }

            var dto = new RolesDto();
            EntityToDto(entity, dto);
            return dto;
        }
    }
}
