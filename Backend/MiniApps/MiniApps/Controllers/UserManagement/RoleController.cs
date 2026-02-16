using MA.Framework.Application.Controller;
using MA.Framework.Application.Model;
using MA.Framework.Core.Constant;
using MA.Framework.Core.Resource;
using MA.Framework.ServiceInterface.Request;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Dto.Common;
using MiniApps.Model.Request.UserManagement;
using MiniApps.ServiceInterface.Common;
using System.Net;

namespace MiniApps.Controllers.UserManagement
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class RoleController : BaseController
    {
        private readonly IRoleService _roleService;

        public RoleController(
            IRoleService roleService
            )
        {
            this._roleService = roleService;
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/roles")]
        public async Task<IActionResult> SearchRoles()
        {
            var rolesResponse = await this._roleService.SearchAsync();
            if (rolesResponse.IsError())
            {
                return this.GetApiError(rolesResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return Ok(rolesResponse.DtoCollection);
        }

        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/roles")]
        public async Task<IActionResult> AddRole([FromBody] RoleRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var roleResponse = await this._roleService.ReadByName(model.RoleName);
            if (!roleResponse.IsError())
            {
                return this.Ok(roleResponse.Data.Uuid);
            }

            var request = new GenericRequest<RolesDto>()
            {
                Data = new RolesDto
                {
                    Uuid = this.GenerateUuid(UidTableConstant.Roles),
                    RoleName = model.RoleName,
                }
            };

            this.PopulateCreatedFields(request.Data);

            var createRequest = await this._roleService.InsertAsync(request);
            if (createRequest.IsError())
            {
                return this.GetApiError(createRequest.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            var apiResponse = new BasicApiResponse()
            {
                Uuid = createRequest.Data.Uuid,
            };

            return this.Created("", apiResponse);
        }
    }
}
