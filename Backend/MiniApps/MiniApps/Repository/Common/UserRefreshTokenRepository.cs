using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Common;
using MiniApps.RepositoryInterface.Common;

namespace MiniApps.Repository.Common
{
    public class UserRefreshTokenRepository : BaseRepository<ApplicationContext, ComUserrefreshtoken, UserRefreshTokenDto, string>, IUserRefreshTokenRepository
    {
        public UserRefreshTokenRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public async Task<int> DeleteExpiredRefreshTokenAsync(string userUuid)
        {
            var cutoffDate = DateTime.UtcNow.AddDays(-15);

            var rowsAffected = await Context.Set<ComUserrefreshtoken>()
                .Where(x => x.Useruuid == userUuid && x.Createdat < cutoffDate)
                .ExecuteDeleteAsync();

            return rowsAffected;
        }
    }
}
