using MA.Framework.Application.Controller;
using MA.Framework.Application.Model;
using MA.Framework.Core.Constant;
using MA.Framework.Core.Resource;
using MA.Framework.ServiceInterface.Request;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Dto.Academic;
using MiniApps.Model.Request.Academic;
using MiniApps.ServiceInterface.Academic;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace MiniApps.Controllers.Academic
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class TopicController : BaseController
    {
        private readonly ITopicService _topicService;
        private readonly ISubjectService _subjectService;

        public TopicController(
            ITopicService topicService,
            ISubjectService subjectService)
        {
            this._topicService = topicService;
            this._subjectService = subjectService;
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/topics")]
        public async Task<IActionResult> SearchTopics()
        { 
            var topicsResponse = await this._topicService.SearchAsync();
            if (topicsResponse.IsError())
            {
                return this.GetApiError(topicsResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(topicsResponse.DtoCollection);
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/topics/bysubject")]
        public async Task<IActionResult> SearchTopics([FromQuery] string subjectId)
        {
            var subjectResponse = await this._subjectService.ReadAsync(new GenericRequest<string> { Data = subjectId });
            if (subjectResponse.IsError())
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var topicsResponse = await this._topicService.SearchAsync(subjectId);
            if (topicsResponse.IsError())
            {
                return this.GetApiError(topicsResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(topicsResponse.DtoCollection);
        }

        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/topic")]
        public async Task<IActionResult> AddTopic([FromBody] TopicRequest model)
        {
            var topicResponse = await this._topicService.ReadByNamAndSubject(model.TopicName, model.SubjectId);
            if (!topicResponse.IsError())
            {
                return new OkObjectResult(topicResponse.Data.Uuid);
            }

            var subjectResponse = await this._subjectService.ReadAsync(new GenericRequest<string> { Data = model.SubjectId });
            if (subjectResponse.IsError())
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var request = new GenericRequest<TopicDto>
            {
                Data = new TopicDto
                {
                    Uuid = this.GenerateUuid(UidTableConstant.Topic),
                    SubjectUuid = model.SubjectId,
                    Name = model.TopicName,
                }
            };

            this.PopulateCreatedFields(request.Data);

            var createResponse = await this._topicService.InsertAsync(request);
            if (createResponse.IsError())
            {
                return this.GetApiError(createResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            var apiResponse = new BasicApiResponse()
            {
                Uuid = createResponse.Data.Uuid,
            };

            return this.Created("", apiResponse);
        }

        [HttpPut]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/topic/{id}")]
        public async Task<IActionResult> UpdateTopic([FromRoute][Required] string id, [FromBody]TopicRequest model)
        {
            var topicResponse = await this._topicService.ReadAsync(new GenericRequest<string>{ Data = id});
            if (topicResponse.IsError())
            {
                return this.GetApiError(topicResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            if (!topicResponse.Data.SubjectUuid.Equals(model.SubjectId, StringComparison.OrdinalIgnoreCase))
            {
                var subjectResponse = await this._subjectService.ReadAsync(new GenericRequest<string> { Data = model.SubjectId });
                if (subjectResponse.IsError())
                {
                    return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
                }
            }

            var request = new GenericRequest<TopicDto>
            {
                Data = topicResponse.Data,
            };

            request.Data.Name = model.TopicName;
            request.Data.SubjectUuid = model.SubjectId;
            this.PopulatedUpdatedFields(request.Data);

            var updateResponse = await this._topicService.UpdateAsync(request);
            if (updateResponse.IsError())
            {
                return this.GetApiError(updateResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return new OkObjectResult(updateResponse.Data.Uuid);
        }

        [HttpDelete]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/topic/{id}")]
        public async Task<IActionResult> DeleteTopic([FromRoute][Required] string id)
        {
            var topicResponse = await this._topicService.ReadAsync(new GenericRequest<string> { Data = id });
            if (topicResponse.IsError())
            {
                return this.GetApiError(topicResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            var deleteResponse = await this._topicService.DeleteAsync(new GenericRequest<string> { Data= id });
            if (deleteResponse.IsError())
            {
                return this.GetApiError(deleteResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return this.Ok();
        }
    }
}
