using MA.Framework.RepositoryInterface;
using MiniApps.Dto;

namespace MiniApps.RepositoryInterface
{
    public interface IUserAccountRepository : IBaseRepository<UserAccountDto>
    {
        Task<UserAccountDto> ReadUserByEmailAddress(string emailAddress);

        Task<bool> IsEmailExistAsync(string emailAddress);

        Task<UserAccountDto> ReadUserByRefreshTokenAsync(string refreshToken);
    }
}
