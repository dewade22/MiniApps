using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Core.Resource.UserAccount;
using MiniApps.Dto.Common;
using MiniApps.Model.Authentication;
using MiniApps.Model.Request;
using MiniApps.RepositoryInterface.Common;
using MiniApps.ServiceInterface.Common;

namespace MiniApps.Service.Common
{
    public class UserAccountService : BaseService<UserAccountDto, string, IUserAccountRepository>, IUserAccountService
    {
        private readonly IJwtTokenManagerRepository _jwtTokenManagerRepository;

        public UserAccountService(
            IUserAccountRepository repository,
            IJwtTokenManagerRepository jwtTokenManagerRepository)
            : base(repository)
        {
            _jwtTokenManagerRepository = jwtTokenManagerRepository;
        }

        #region Public Async

        public async Task<GenericResponse<UserAccountDto>> ReadUserByEmailAddressAsync(string emailAddress)
        {
            var response = new GenericResponse<UserAccountDto>();

            var result = await _repository.ReadUserByEmailAddress(emailAddress);
            if (result == null)
            {
                response.AddErrorMessage(string.Format(UserAccountResource.UserEmail_NotFound, emailAddress));
                return response;
            }

            response.Data = result;

            return response;
        }

        public async Task<GenericResponse<bool>> IsEmailExistAsync(string emailAddress)
        {
            var response = new GenericResponse<bool>();
            var result = await _repository.IsEmailExistAsync(emailAddress);

            response.Data = result;

            return response;
        }

        public async Task<GenericResponse<UserAccountDto>> ReadUserByRefreshTokenAsync(string refreshToken)
        {
            var response = new GenericResponse<UserAccountDto>();

            var result = await _repository.ReadUserByRefreshTokenAsync(refreshToken);
            if (result == null)
            {
                response.AddErrorMessage(string.Format(UserAccountResource.UserAccount_RefreshTokenNotFound, refreshToken));
                return response;
            }

            response.Data = result;

            return response;
        }

        #endregion

        #region Sync

        public GenericResponse<Token> GenerateToken(TokenRequest request)
        {
            var response = new GenericResponse<Token>();
            var tokenResponse = _jwtTokenManagerRepository.GenerateToken(request);
            if (string.IsNullOrEmpty(tokenResponse.AccessToken))
            {
                response.AddErrorMessage(UserAccountResource.Token_FailedToGenerate);
                return response;
            }

            response.Data = tokenResponse;
            return response;
        }

        #endregion
    }
}
