using MA.Framework.Application.Controller;
using MA.Framework.Application.Model;
using MA.Framework.Core.Constant;
using MA.Framework.Core.Resource;
using MA.Framework.ServiceInterface.Request;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Dto.Academic;
using MiniApps.Model.Request.Grade;
using MiniApps.ServiceInterface.Academic;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace MiniApps.Controllers.Academic
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class SubjectController : BaseController
    {
        private readonly ISubjectService _subjectService;

        public SubjectController(
            ISubjectService subjectService)
        {
            this._subjectService = subjectService;
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/subjects")]
        public async Task<IActionResult> SearchSubjects()
        {
            var subjectResponse = await this._subjectService.SearchAsync();
            if (subjectResponse.IsError())
            {
                return this.GetApiError(subjectResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(subjectResponse.DtoCollection);
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/subject/{id}")]
        public async Task<IActionResult> ReadSubject([FromRoute][Required] string id)
        {
            var request = new GenericRequest<string> { Data = id };
            var subjectResponse = await this._subjectService.ReadAsync(request);
            if (subjectResponse.IsError())
            {
                return this.GetApiError(subjectResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(subjectResponse.Data);
        }

        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/subject")]
        public async Task<IActionResult> AddSubject([FromBody] SubjectRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var subjectResponse = await this._subjectService.ReadByName(model.SubjectName);
            if (!subjectResponse.IsError())
            {
                return new OkObjectResult(subjectResponse.Data.Uuid);
            }

            var request = new GenericRequest<SubjectDto>()
            {
                Data = new SubjectDto
                {
                    Uuid = this.GenerateUuid(UidTableConstant.Subject),
                    Name = model.SubjectName,
                }
            };

            this.PopulateCreatedFields(request.Data);

            var createRequest = await this._subjectService.InsertAsync(request);

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

        [HttpPut]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/subject/{id}")]
        public async Task<IActionResult> UpdateGrade([FromRoute][Required] string id, [FromBody] SubjectRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var request = new GenericRequest<string> { Data = id };
            var subjectResponse = await this._subjectService.ReadAsync(request);
            if (subjectResponse.IsError())
            {
                return this.GetApiError(subjectResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            var updateRequest = new GenericRequest<SubjectDto>
            {
                Data = subjectResponse.Data,
            };
            updateRequest.Data.Name = model.SubjectName;
            this.PopulatedUpdatedFields(updateRequest.Data);

            var updateResponse = await this._subjectService.UpdateAsync(updateRequest);
            if (updateResponse.IsError())
            {
                return this.GetApiError(updateResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return new OkObjectResult(updateResponse.Data.Uuid);
        }

        [HttpDelete]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/subject/{id}")]
        public async Task<IActionResult> DeleteSubject([FromRoute][Required] string id)
        {
            var request = new GenericRequest<string> { Data = id };
            var subjectResponse = await this._subjectService.ReadAsync(request);
            if (subjectResponse.IsError())
            {
                return this.GetApiError(subjectResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            var deleteResponse = await this._subjectService.DeleteAsync(request);
            if (deleteResponse.IsError())
            {
                return this.GetApiError(deleteResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return this.Ok();
        }
    }
}
