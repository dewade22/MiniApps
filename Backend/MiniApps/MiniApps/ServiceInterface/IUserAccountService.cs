using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto;
using MiniApps.Model.Authentication;
using MiniApps.Model.Request;

namespace MiniApps.ServiceInterface
{
    public interface IUserAccountService : IBaseService<UserAccountDto, string>
    {
        #region Async

        Task<GenericResponse<UserAccountDto>> ReadUserByEmailAddressAsync(string emailAddress);

        Task<GenericResponse<bool>> IsEmailExistAsync(string emailAddress);

        Task<GenericResponse<UserAccountDto>> ReadUserByRefreshTokenAsync(string refreshToken);

        #endregion

        #region Sync

        GenericResponse<Token> GenerateToken(TokenRequest request);

        #endregion
    }
}
