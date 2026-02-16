using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Common;

namespace MiniApps.RepositoryInterface.Common
{
    public interface IUserAccountRepository : IBaseRepository<UserAccountDto>
    {
        Task<UserAccountDto> ReadUserByEmailAddress(string emailAddress);

        Task<bool> IsEmailExistAsync(string emailAddress);

        Task<UserAccountDto> ReadUserByRefreshTokenAsync(string refreshToken);
    }
}
