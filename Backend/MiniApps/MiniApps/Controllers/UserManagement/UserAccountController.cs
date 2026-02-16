using MA.Framework.Application.Controller;
using MA.Framework.Application.Model;
using MA.Framework.Core.Constant;
using MA.Framework.Core.Resource;
using MA.Framework.ServiceInterface.Request;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Core.Resource.UserAccount;
using MiniApps.Dto.Common;
using MiniApps.Helper;
using MiniApps.Model.Authentication;
using MiniApps.Model.Request;
using MiniApps.Model.Request.UserManagement;
using MiniApps.ServiceInterface.Common;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace MiniApps.Controllers.UserManagement
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class UserAccountController : BaseController
    {
        private readonly IRoleService _roleService;
        private readonly IUserAccountService _userAccountService;
        private readonly IUserInRoleService _userInRoleService;
        private readonly IUserMembershipService _userMembershipService;
        private readonly IUserRefreshTokenService _userRefreshTokenService;

        public UserAccountController(
            IRoleService roleService,
            IUserAccountService userAccountService,
            IUserInRoleService userInRoleService,
            IUserMembershipService userMembershipService,
            IUserRefreshTokenService userRefreshTokenService)
        {
            this._roleService = roleService;
            this._userAccountService = userAccountService;
            this._userInRoleService = userInRoleService;
            this._userMembershipService = userMembershipService;
            _userRefreshTokenService = userRefreshTokenService;
        }

        [HttpGet]
        [AllowAnonymous]
        [Route("/v{version:apiversion}/user-account/ping")]
        public async Task<IActionResult> PingEndpoint()
        {
            return await Task.FromResult(Ok());
        }

        [HttpGet]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/user-account/{emailAddress}")]
        public async Task<IActionResult> ReadUserByEmailAddressAsync([FromRoute][Required] string emailAddress)
        {
            if (string.IsNullOrEmpty(emailAddress))
            {
                return this.GetApiError(new[] { UserAccountResource.UserAccount_EmptyEmail }, (int)HttpStatusCode.BadRequest);
            }

            var userAccountResponse = await this._userAccountService.ReadUserByEmailAddressAsync(emailAddress);
            if (userAccountResponse.IsError())
            {
                return this.GetApiError(userAccountResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(userAccountResponse.Data);
        }

        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/user-account")]
        public async Task<IActionResult> CreateUserAsync([FromBody] CreateUserRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            if (!this.IsValidTimeZone(model.TimeZoneId))
            {
                return this.GetApiError(new[] { GeneralResource.Timezone_Invalid }, (int)HttpStatusCode.BadRequest);
            }

            var isEmailAddressExistResponse = await this._userAccountService.IsEmailExistAsync(model.EmailAddress);
            if (isEmailAddressExistResponse.Data)
            {
                return this.GetApiError(new[] { string.Format(UserAccountResource.CreateUser_EmailExist, model.EmailAddress) }, (int)HttpStatusCode.BadRequest);
            }

            var createUserRequest = new GenericRequest<UserAccountDto>()
            {
                Data = new UserAccountDto
                {
                    Uuid = this.GenerateUuid(UidTableConstant.UserAccount),
                    EmailAddress = model.EmailAddress,
                    FirstName = model.FirstName,
                    LastName = model.LastName,
                    TimeZoneId = model.TimeZoneId,
                    IsArchived = false,
                }
            };

            this.PopulateCreatedFields(createUserRequest.Data);

            var createUserResponse = await this._userAccountService.InsertAsync(createUserRequest);
            if (createUserResponse.IsError())
            {
                this.GetApiError(createUserResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            var hashedPassword = CryptoHash.HashedString(model.Password);
            var createUserPasswordRequest = new GenericRequest<UserMembershipDto>()
            {
                Data = new UserMembershipDto()
                {
                    Uuid = this.GenerateUuid(UidTableConstant.UserMembership),
                    UserUuid = createUserRequest.Data.Uuid,
                    Password = hashedPassword,
                }
            };

            this.PopulateCreatedFields(createUserPasswordRequest.Data);
            var createUserPasswordResponse = await this._userMembershipService.InsertAsync(createUserPasswordRequest);
            if (createUserPasswordResponse.IsError())
            {
                await this._userAccountService.DeleteAsync(new GenericRequest<string> { Data = createUserRequest.Data.Uuid });
                return this.GetApiError(createUserPasswordResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            var apiResponse = new BasicApiResponse()
            {
                Uuid = createUserResponse.Data.Uuid,
            };

            return this.Created("/Home/Index", apiResponse);
        }

        [HttpPut]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/user-account/roles")]
        public async Task<IActionResult> AssignUnAssignRole([FromBody] AssignRoleRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var userAccountResponse = await this._userAccountService.ReadUserByEmailAddressAsync(model.EmailAddress);
            if (userAccountResponse.IsError())
            {
                return this.GetApiError(userAccountResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            var readRoleRequest = new GenericRequest<string>
            {
                Data = model.RoleUuid,
            };

            var roleResponse = await this._roleService.ReadAsync(readRoleRequest);
            if (roleResponse.IsError())
            {
                return this.GetApiError(roleResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            var userInRoleRequest = new GenericRequest<UserInRoleDto>
            {
                Data = new UserInRoleDto(),
            };

            var currentUserInRoleResponse = await this._userInRoleService.ReadByUserUuidRoleUuidAsync(userAccountResponse.Data.Uuid, model.RoleUuid);
            if (currentUserInRoleResponse.IsError())
            {
                userInRoleRequest.Data.Uuid = this.GenerateUuid(UidTableConstant.UserInRole);
                userInRoleRequest.Data.UserUuid = userAccountResponse.Data.Uuid;
                userInRoleRequest.Data.RoleUuid = roleResponse.Data.Uuid;
                this.PopulateCreatedFields(userInRoleRequest.Data);
                
                var createResponse = await this._userInRoleService.InsertAsync(userInRoleRequest);
                if (createResponse.IsError())
                {
                    return this.GetApiError(createResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
                }
            }
            else
            {
                var deleteRequest = new GenericRequest<string>
                {
                    Data = currentUserInRoleResponse.Data.Uuid
                };

                var deleteResponse = await this._userInRoleService.DeleteAsync(deleteRequest);
                if (deleteResponse.IsError())
                {
                    return this.GetApiError(deleteResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
                }
            }

            var response = new BasicApiResponse()
            {
                Uuid = userInRoleRequest.Data.Uuid,
            };

            return new OkObjectResult(response);
        }

        [HttpPost]
        [AllowAnonymous]
        [Route("/v{version:apiversion}/user-account/signin")]
        public async Task<IActionResult> SignIn([FromBody] LoginRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var userResponse = await this._userAccountService.ReadUserByEmailAddressAsync(model.Email);
            if (userResponse.IsError())
            {
                return this.GetApiError(new[] { string.Format(UserAccountResource.User_NotRegistered, model.Email) }, (int)HttpStatusCode.BadRequest);
            }

            if (userResponse.Data.IsArchived)
            {
                return this.GetApiError(new[] { UserAccountResource.User_Archived }, (int)HttpStatusCode.BadRequest);
            }

            var isPasswordMatch = CryptoHash.Verify(model.Password, userResponse.Data.Password);
            if (!isPasswordMatch)
            {
                return this.GetApiError(new[] { UserAccountResource.User_WrongPassword }, (int)HttpStatusCode.BadRequest);
            }

            return await this.CreateTokenSignInUser(userResponse.Data);
        }

        [HttpPost]
        [Route("/v{version:apiversion}/user-account/refresh")]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequest model)
        {
            var refreshTokenResponse = await this._userAccountService.ReadUserByRefreshTokenAsync(model.RefreshToken);
            if (refreshTokenResponse.IsError())
            {
                return this.GetApiError(refreshTokenResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            var userResponse = await this._userAccountService.ReadUserByEmailAddressAsync(refreshTokenResponse.Data.EmailAddress);
            if (userResponse.IsError())
            {
                return this.GetApiError(new[] { UserAccountResource.User_NotRegistered }, (int)HttpStatusCode.BadRequest);
            }

            if (userResponse.Data.IsArchived)
            {
                return this.GetApiError(new[] { UserAccountResource.User_Archived }, (int)HttpStatusCode.BadRequest);
            }

            return await this.CreateTokenSignInUser(userResponse.Data);
        }

        #region private Methods

        private async Task<IActionResult> CreateTokenSignInUser(UserAccountDto userAccount)
        {
            var tokenRequest = new TokenRequest()
            {
                UserUuid = userAccount.Uuid,
                EmailAddress = userAccount.EmailAddress,
                Role = userAccount.RoleName ?? string.Empty,
            };

            var tokenResponse = this._userAccountService.GenerateToken(tokenRequest);
            if (tokenResponse.IsError())
            {
                return this.GetApiError(tokenResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            var saveRefreshTokenRequest = new GenericRequest<UserRefreshTokenDto>()
            {
                Data = new UserRefreshTokenDto()
                {
                    Uuid = this.GenerateUuid(UidTableConstant.UserRefreshToken),
                    RefreshToken = tokenResponse.Data.RefreshToken,
                    UserUuid = userAccount.Uuid,
                },
            };

            this.PopulateCreatedFields(saveRefreshTokenRequest.Data);

            this.DeleteExpiredRefreshToken(userAccount.Uuid);

            await this._userRefreshTokenService.InsertAsync(saveRefreshTokenRequest);

            return new OkObjectResult(tokenResponse);
        }

        private void DeleteExpiredRefreshToken(string uuid)
        {
            this._userRefreshTokenService.DeleteExpiredRefreshTokenAsync(uuid).GetAwaiter().GetResult();
        }

        #endregion
    }
}
