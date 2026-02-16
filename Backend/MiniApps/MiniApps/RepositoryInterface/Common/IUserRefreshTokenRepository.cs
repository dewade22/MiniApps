using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Common;

namespace MiniApps.RepositoryInterface.Common
{
    public interface IUserRefreshTokenRepository : IBaseRepository<UserRefreshTokenDto>
    {
        Task<int> DeleteExpiredRefreshTokenAsync(string userUuid);
    }
}
