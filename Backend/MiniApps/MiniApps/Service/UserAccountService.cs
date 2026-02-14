using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Core.Resource.UserAccount;
using MiniApps.Dto;
using MiniApps.Model.Authentication;
using MiniApps.Model.Request;
using MiniApps.RepositoryInterface;
using MiniApps.ServiceInterface;

namespace MiniApps.Service
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

            var result = await this._repository.ReadUserByEmailAddress(emailAddress);
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
            var result = await this._repository.IsEmailExistAsync(emailAddress);

            response.Data = result;

            return response;
        }

        #endregion

        #region Sync

        public GenericResponse<Token> GenerateToken(TokenRequest request)
        {
            var response = new GenericResponse<Token>();
            var tokenResponse = this._jwtTokenManagerRepository.GenerateToken(request);
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
