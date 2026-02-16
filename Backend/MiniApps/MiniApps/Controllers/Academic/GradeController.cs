using MA.Framework.Application.Controller;
using MA.Framework.Application.Model;
using MA.Framework.Core.Constant;
using MA.Framework.Core.Resource;
using MA.Framework.ServiceInterface.Request;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Dto.Academic;
using MiniApps.Dto.Common;
using MiniApps.Model.Request.Grade;
using MiniApps.ServiceInterface.Academic;
using System.Net;

namespace MiniApps.Controllers.Academic
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class GradeController : BaseController
    {
        private readonly IGradeService _gradeService;

        public GradeController(
            IGradeService gradeService)
        {
            this._gradeService = gradeService;
        }

        [HttpGet]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/grades")]
        public async Task<IActionResult> SearchGrades()
        {
            var gradesResponse = await this._gradeService.SearchAsync();
            if (gradesResponse.IsError())
            {
                return this.GetApiError(gradesResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(gradesResponse.DtoCollection);
        }

        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/grade")]
        public async Task<IActionResult> AddGrade([FromBody] GradeRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var gradeResponse = await this._gradeService.ReadByName(model.GradeName);
            if (!gradeResponse.IsError())
            {
                return new OkObjectResult(gradeResponse.Data.Uuid);
            }

            var request = new GenericRequest<GradeDto>()
            {
                Data = new GradeDto
                {
                    Uuid = this.GenerateUuid(UidTableConstant.Grade),
                    Name = model.GradeName,
                }
            };

            this.PopulateCreatedFields(request.Data);

            var createRequest = await this._gradeService.InsertAsync(request);

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

        [HttpGet]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/grade/{id}")]
        public async Task<IActionResult> ReadGrade([FromRoute] string id)
        {
            var request = new GenericRequest<string> { Data = id };
            var gradeResponse = await this._gradeService.ReadAsync(request);
            if (gradeResponse.IsError())
            {
                return this.GetApiError(gradeResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(gradeResponse.Data);
        }

        [HttpPut]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/grade/{id}")]
        public async Task<IActionResult> UpdateGrade([FromRoute] string id, [FromBody] GradeRequest model)
        {
            if (!ModelState.IsValid)
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var request = new GenericRequest<string> { Data = id };
            var gradeResponse = await this._gradeService.ReadAsync(request);
            if (gradeResponse.IsError())
            {
                return this.GetApiError(gradeResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            var updateRequest = new GenericRequest<GradeDto>
            {
                Data = gradeResponse.Data,
            };
            updateRequest.Data.Name = model.GradeName;
            this.PopulatedUpdatedFields(updateRequest.Data);

            var updateResponse = await this._gradeService.UpdateAsync(updateRequest);
            if (updateResponse.IsError())
            {
                return this.GetApiError(updateResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return new OkObjectResult(updateResponse.Data.Uuid);
        }

        [HttpDelete]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/grade/{id}")]
        public async Task<IActionResult> DeleteGrade([FromRoute] string id)
        {
            var request = new GenericRequest<string> { Data = id };
            var gradeResponse = await this._gradeService.ReadAsync(request);
            if (gradeResponse.IsError())
            {
                return this.GetApiError(gradeResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            var deleteResponse = await this._gradeService.DeleteAsync(request);
            if (deleteResponse.IsError())
            {
                return this.GetApiError(deleteResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return this.Ok();
        }
    }
}
