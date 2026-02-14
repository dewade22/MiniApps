using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;

namespace MiniApps.Repository
{
    public class UserInRoleRepository : BaseRepository<ApplicationContext, ComUserinrole, UserInRoleDto, string>, IUserInRoleRepository
    {
        public UserInRoleRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {

        }

        public async Task<UserInRoleDto> ReadByUserUuidAsync(string userUuid)
        {
            var dbSet = this.Context.Set<ComUserinrole>();
            var entity = await dbSet
                .FirstOrDefaultAsync(item => item.Useruuid == userUuid);
            if (entity == null)
            {
                return null;
            }

            var dto = new UserInRoleDto();
            EntityToDto(entity, dto);
            return dto;
        }

        public async Task<List<UserInRoleDto>> SearchByUserUuidAsync(string userUuid)
        {
            var dbSet = this.Context.Set<ComUserinrole>();
            var entities = await dbSet
                .Where(item => item.Useruuid == userUuid).ToListAsync();

            if (entities == null)
            {
                return null;
            }

            var dtos = new List<UserInRoleDto>();
            foreach (var entity in entities) {
                var dto = new UserInRoleDto();
                EntityToDto(entity, dto);
                dtos.Add(dto);
            }

            return dtos;
        }

        public async Task<UserInRoleDto> ReadByUserUuidRoleUuidAsync(string userUuid, string roleUuid)
        {
            var dbSet = this.Context.Set<ComUserinrole>();
            var entity = await dbSet
                .FirstOrDefaultAsync(item => item.Useruuid == userUuid && item.Roleuuid == roleUuid);

            if (entity == null)
            {
                return null;
            }

            var dto = new UserInRoleDto();
            EntityToDto(entity, dto);

            return dto;
        }
    }
}
