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

#nullable disable

namespace MiniApps.Controllers.Academic
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class QuestionController : BaseController
    {
        private readonly IQuestionService _questionService;
        private readonly ITopicService _topicService;
        private readonly IGradeService _gradeService;

        public QuestionController(
            IQuestionService questionService,
            ITopicService topicService,
            IGradeService gradeService)
        {
            this._questionService = questionService;
            this._topicService = topicService;
            this._gradeService = gradeService;
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/questions")]
        public async Task<IActionResult> SearchQuestions()
        {
            var response = await this._questionService.SearchAsync();
            if (response.IsError())
            {
                return this.GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(response.DtoCollection);
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/questions/bytopic")]
        public async Task<IActionResult> SearchQuestionsByTopic([FromQuery] string topicId)
        {
            var topicResponse = await this._topicService.ReadAsync(new GenericRequest<string> { Data = topicId });
            if (topicResponse.IsError())
            {
                return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
            }

            var response = await this._questionService.SearchByTopicAsync(topicId);

            return new OkObjectResult(response.DtoCollection);
        }

        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/question/{id}")]
        public async Task<IActionResult> GetQuestion([FromRoute][Required] string id)
        {
            var response = await this._questionService.ReadWithOptionsAsync(id);
            if (response.IsError())
            {
                return this.GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            return new OkObjectResult(response.Data);
        }

        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/question")]
        public async Task<IActionResult> AddQuestion([FromBody] QuestionRequest model)
        {
            if (!model.Options.Any(o => o.OptionText == model.CorrectOption))
            {
                return this.GetApiError(new[] { "CorrectOption must match the text of one of the options" }, (int)HttpStatusCode.BadRequest);
            }

            if (model.TopicUuid != null)
            {
                var topicResponse = await this._topicService.ReadAsync(new GenericRequest<string> { Data = model.TopicUuid });
                if (topicResponse.IsError())
                {
                    return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
                }
            }

            // Validate grade UUIDs if provided
            foreach (var gradeReq in model.Grades)
            {
                var gradeResponse = await this._gradeService.ReadAsync(new GenericRequest<string> { Data = gradeReq.GradeUuid });
                if (gradeResponse.IsError())
                {
                    return this.GetApiError(new[] { $"Grade '{gradeReq.GradeUuid}' not found" }, (int)HttpStatusCode.BadRequest);
                }
            }

            var questionUuid = this.GenerateUuid(UidTableConstant.Question);

            var dto = new QuestionDto
            {
                Uuid = questionUuid,
                QuestionText = model.QuestionText,
                TopicUuid = model.TopicUuid,
                CorrectOption = model.CorrectOption,
                Options = model.Options.Select(o => new QuestionOptionDto
                {
                    Uuid = this.GenerateUuid(UidTableConstant.QuestionOption),
                    QuestionUuid = questionUuid,
                    Label = o.Label,
                    OptionText = o.OptionText,
                }).ToList(),
                Grades = model.Grades.Select(g => new QuestionGradeDto
                {
                    Uuid = this.GenerateUuid(UidTableConstant.QuestionGrade),
                    QuestionUuid = questionUuid,
                    GradeUuid = g.GradeUuid,
                    Difficulty = g.Difficulty,
                }).ToList(),
            };

            this.PopulateCreatedFields(dto);
            foreach (var option in dto.Options)
            {
                this.PopulateCreatedFields(option);
            }
            foreach (var grade in dto.Grades)
            {
                this.PopulateCreatedFields(grade);
            }

            var response = await this._questionService.InsertWithOptionsAsync(dto);
            if (response.IsError())
            {
                return this.GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return this.Created("", new BasicApiResponse { Uuid = response.Data.Uuid });
        }

        [HttpPut]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/question/{id}")]
        public async Task<IActionResult> UpdateQuestion([FromRoute][Required] string id, [FromBody] QuestionRequest model)
        {
            if (!model.Options.Any(o => o.OptionText == model.CorrectOption))
            {
                return this.GetApiError(new[] { "CorrectOption must match the text of one of the options" }, (int)HttpStatusCode.BadRequest);
            }

            var existingResponse = await this._questionService.ReadWithOptionsAsync(id);
            if (existingResponse.IsError())
            {
                return this.GetApiError(existingResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            if (model.TopicUuid != null && !model.TopicUuid.Equals(existingResponse.Data.TopicUuid, StringComparison.OrdinalIgnoreCase))
            {
                var topicResponse = await this._topicService.ReadAsync(new GenericRequest<string> { Data = model.TopicUuid });
                if (topicResponse.IsError())
                {
                    return this.GetApiError(new[] { GeneralResource.General_RequestInvalid }, (int)HttpStatusCode.BadRequest);
                }
            }

            // Validate grade UUIDs if provided
            foreach (var gradeReq in model.Grades)
            {
                var gradeResponse = await this._gradeService.ReadAsync(new GenericRequest<string> { Data = gradeReq.GradeUuid });
                if (gradeResponse.IsError())
                {
                    return this.GetApiError(new[] { $"Grade '{gradeReq.GradeUuid}' not found" }, (int)HttpStatusCode.BadRequest);
                }
            }

            var dto = existingResponse.Data;
            dto.QuestionText = model.QuestionText;
            dto.TopicUuid = model.TopicUuid;
            dto.CorrectOption = model.CorrectOption;
            dto.Options = model.Options.Select((o, i) =>
            {
                var existingOption = existingResponse.Data.Options.ElementAtOrDefault(i);
                return new QuestionOptionDto
                {
                    Uuid = existingOption?.Uuid ?? this.GenerateUuid(UidTableConstant.QuestionOption),
                    QuestionUuid = id,
                    Label = o.Label,
                    OptionText = o.OptionText,
                    CreatedBy = existingOption?.CreatedBy ?? dto.CreatedBy,
                    CreatedAt = existingOption?.CreatedAt ?? dto.CreatedAt,
                };
            }).ToList();

            dto.Grades = model.Grades.Select(g =>
            {
                var existingGrade = existingResponse.Data.Grades
                    .FirstOrDefault(eg => eg.GradeUuid.Equals(g.GradeUuid, StringComparison.OrdinalIgnoreCase));
                return new QuestionGradeDto
                {
                    Uuid = existingGrade?.Uuid ?? this.GenerateUuid(UidTableConstant.QuestionGrade),
                    QuestionUuid = id,
                    GradeUuid = g.GradeUuid,
                    Difficulty = g.Difficulty,
                    CreatedBy = existingGrade?.CreatedBy ?? dto.CreatedBy,
                    CreatedAt = existingGrade?.CreatedAt ?? dto.CreatedAt,
                };
            }).ToList();

            this.PopulatedUpdatedFields(dto);
            foreach (var option in dto.Options)
            {
                this.PopulatedUpdatedFields(option);
            }
            foreach (var grade in dto.Grades)
            {
                this.PopulatedUpdatedFields(grade);
            }

            var response = await this._questionService.UpdateWithOptionsAsync(dto);
            if (response.IsError())
            {
                return this.GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return new OkObjectResult(response.Data.Uuid);
        }

        [HttpDelete]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/question/{id}")]
        public async Task<IActionResult> DeleteQuestion([FromRoute][Required] string id)
        {
            var existingResponse = await this._questionService.ReadAsync(new GenericRequest<string> { Data = id });
            if (existingResponse.IsError())
            {
                return this.GetApiError(existingResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);
            }

            var deleteResponse = await this._questionService.DeleteAsync(new GenericRequest<string> { Data = id });
            if (deleteResponse.IsError())
            {
                return this.GetApiError(deleteResponse.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);
            }

            return this.Ok();
        }
    }
}
