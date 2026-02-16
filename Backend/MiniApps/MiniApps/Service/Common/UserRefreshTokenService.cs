using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Common;
using MiniApps.RepositoryInterface.Common;
using MiniApps.ServiceInterface.Common;

namespace MiniApps.Service.Common
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
            var result = await _repository.DeleteExpiredRefreshTokenAsync(userUuid);

            response.Data = result;

            return response;
        }
    }
}
