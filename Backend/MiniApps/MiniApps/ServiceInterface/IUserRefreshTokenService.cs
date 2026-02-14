using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto;

namespace MiniApps.ServiceInterface
{
    public interface IUserRefreshTokenService : IBaseService<UserRefreshTokenDto, string>
    {
        Task<GenericResponse<int>> DeleteExpiredRefreshTokenAsync(string userUuid);
    }
}
