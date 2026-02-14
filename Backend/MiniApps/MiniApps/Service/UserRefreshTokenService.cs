using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;
using MiniApps.ServiceInterface;

namespace MiniApps.Service
{
    public class UserRefreshTokenService : BaseService<UserRefreshTokenDto, string, IUserRefreshTokenRepository>, IUserRefreshTokenService
    {
        public UserRefreshTokenService(IUserRefreshTokenRepository repository)
            : base(repository)
        {
        }

        public async Task<GenericResponse<int>> DeleteExpiredRefreshTokenAsync(string userUuid)
        {
            var response = new GenericResponse<int>();
            var result = await this._repository.DeleteExpiredRefreshTokenAsync(userUuid);

            response.Data = result;

            return response;
        }
    }
}
