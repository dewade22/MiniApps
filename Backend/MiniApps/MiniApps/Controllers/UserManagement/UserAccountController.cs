using MA.Framework.Application.Controller;
using MA.Framework.Core.Constant;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Core.Resource.UserAccount;
using MiniApps.ServiceInterface;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace MiniApps.Controllers.UserManagement
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class UserAccountController : BaseController
    {
        private readonly IUserAccountService _userAccountService;

        public UserAccountController(
            IUserAccountService userAccountService)
        {
            this._userAccountService = userAccountService;
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
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
    }
}
