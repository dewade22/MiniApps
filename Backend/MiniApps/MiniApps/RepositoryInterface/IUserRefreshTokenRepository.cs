using MA.Framework.RepositoryInterface;
using MiniApps.Dto;

namespace MiniApps.RepositoryInterface
{
    public interface IUserRefreshTokenRepository : IBaseRepository<UserRefreshTokenDto>
    {
        Task<int> DeleteExpiredRefreshTokenAsync(string userUuid);
    }
}
