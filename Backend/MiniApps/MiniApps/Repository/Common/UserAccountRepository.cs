using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Common;
using MiniApps.RepositoryInterface.Common;

namespace MiniApps.Repository.Common
{
    public class UserAccountRepository : BaseRepository<ApplicationContext, ComUseraccount, UserAccountDto, string>, IUserAccountRepository
    {
        public UserAccountRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {

        }

        #region Public

        public async Task<UserAccountDto> ReadUserByEmailAddress(string emailAddress)
        {
            var dbSet = Context.Set<ComUseraccount>();
            var entity = await dbSet
                .Include(x => x.ComUserinroles)
                    .ThenInclude(r => r.Roleuu)
                .Include(x => x.ComUsermemberships)
                .Include(x => x.ComUserrefreshtokens)
                .FirstOrDefaultAsync(item => item.Emailaddress == emailAddress);
            if (entity == null)
            {
                return null;
            }

            var dto = new UserAccountDto();
            EntityToDtoWithRelation(entity, dto);
            return dto;
        }

        public async Task<bool> IsEmailExistAsync(string emailAddress)
        {
            var dbSet = Context.Set<ComUseraccount>();
            var entity = await dbSet.FirstOrDefaultAsync(x => x.Emailaddress == emailAddress);

            return entity != null;
        }

        public async Task<UserAccountDto> ReadUserByRefreshTokenAsync(string refreshToken)
        {
            var dbSet = Context.Set<ComUseraccount>();
            var entity = await dbSet
                .Include(x => x.ComUserrefreshtokens)
                .FirstOrDefaultAsync(item => item.ComUserrefreshtokens.Any(rt => rt.Refreshtoken == refreshToken));
            if (entity == null)
            {
                return null;
            }

            var dto = new UserAccountDto();
            EntityToDtoWithRelation(entity, dto);
            return dto;
        }

        #endregion

        #region Protected

        protected override void EntityToDtoWithRelation(ComUseraccount entity, UserAccountDto dto)
        {
            Mapper.Map(entity, dto);

            if (entity.ComUserinroles != null)
            {
                dto.RoleName = entity.ComUserinroles.Select(u => u.Roleuu.Rolename).FirstOrDefault();
            }

            if (entity.ComUsermemberships != null)
            {
                dto.Password = entity.ComUsermemberships.Select(m => m.Password).FirstOrDefault();
            }

            if (entity.ComUserrefreshtokens != null)
            {
                dto.RefreshToken = entity.ComUserrefreshtokens.Select(r => r.Refreshtoken).FirstOrDefault();
            }
        }

        #endregion
    }
}
