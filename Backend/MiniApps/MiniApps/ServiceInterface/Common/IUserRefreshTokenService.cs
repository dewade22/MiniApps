using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Common;

namespace MiniApps.ServiceInterface.Common
{
    public interface IUserRefreshTokenService : IBaseService<UserRefreshTokenDto, string>
    {
        Task<GenericResponse<int>> DeleteExpiredRefreshTokenAsync(string userUuid);
    }
}
