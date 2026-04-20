#nullable disable
using MA.Framework.Application.Controller;
using MA.Framework.Application.Model;
using MA.Framework.Core.Constant;
using MA.Framework.ServiceInterface.Request;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MiniApps.Dto.Academic;
using MiniApps.Model.Request.Academic;
using MiniApps.Model.Response.Academic;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.ServiceInterface.Academic;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace MiniApps.Controllers.Academic
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class QuizController : BaseController
    {
        private readonly IQuizService _quizService;
        private readonly IQuestionRepository _questionRepository;
        private readonly IGradeService _gradeService;
        private readonly ISubjectService _subjectService;
        private readonly ITopicService _topicService;

        public QuizController(
            IQuizService quizService,
            IQuestionRepository questionRepository,
            IGradeService gradeService,
            ISubjectService subjectService,
            ITopicService topicService)
        {
            _quizService = quizService;
            _questionRepository = questionRepository;
            _gradeService = gradeService;
            _subjectService = subjectService;
            _topicService = topicService;
        }

        // ── GET /v1/quizzes ────────────────────────────────────────────────────
        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/quizzes")]
        public async Task<IActionResult> SearchQuizzes()
        {
            var response = await _quizService.SearchAsync();
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);

            return new OkObjectResult(response.DtoCollection);
        }

        // ── GET /v1/quiz/{id} ──────────────────────────────────────────────────
        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/quiz/{id}")]
        public async Task<IActionResult> GetQuiz([FromRoute][Required] string id)
        {
            var response = await _quizService.ReadWithQuestionsAsync(id);
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);

            return new OkObjectResult(response.Data);
        }

        // ── GET /v1/quiz/eligible-questions ───────────────────────────────────
        [HttpGet]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/quiz/eligible-questions")]
        public async Task<IActionResult> GetEligibleQuestions(
            [FromQuery] string gradeUuid,
            [FromQuery] List<string> topicUuids,
            [FromQuery] string subjectUuid)
        {
            if (string.IsNullOrEmpty(gradeUuid))
                return GetApiError(new[] { "gradeUuid is required" }, (int)HttpStatusCode.BadRequest);

            var questions = await _questionRepository.SearchEligibleWithDetailsAsync(
                gradeUuid, topicUuids, subjectUuid);

            return new OkObjectResult(questions);
        }

        // ── GET /v1/quiz/preview ───────────────────────────────────────────────
        [HttpGet]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/quiz/preview")]
        public async Task<IActionResult> Preview(
            [FromQuery] string gradeUuid,
            [FromQuery] List<string> topicUuids,
            [FromQuery] string subjectUuid,
            [FromQuery] int questionCount = 10,
            [FromQuery] int timeVeryEasy = 30,
            [FromQuery] int timeEasy = 45,
            [FromQuery] int timeMedium = 60,
            [FromQuery] int timeHard = 90,
            [FromQuery] int timeVeryHard = 120)
        {
            if (string.IsNullOrEmpty(gradeUuid))
                return GetApiError(new[] { "gradeUuid is required" }, (int)HttpStatusCode.BadRequest);

            var pool = await _questionRepository.SearchEligibleAsync(gradeUuid, topicUuids, subjectUuid);

            var timeMap = BuildTimeMap(timeVeryEasy, timeEasy, timeMedium, timeHard, timeVeryHard);
            var selectable = Math.Min(pool.Count, questionCount);

            var breakdown = pool
                .GroupBy(p => p.Difficulty)
                .ToDictionary(g => g.Key, g => g.Count());

            int estimatedMin = pool.Count == 0 ? 0
                : (int)Math.Ceiling(
                    pool.Sum(p => timeMap.GetValueOrDefault(p.Difficulty, timeMedium))
                    / (double)pool.Count
                    * selectable);

            return new OkObjectResult(new QuizPreviewResponse
            {
                AvailableQuestions = pool.Count,
                SelectableCount = selectable,
                MinTimeSeconds = estimatedMin,
                DifficultyBreakdown = breakdown,
            });
        }

        // ── POST /v1/quiz ──────────────────────────────────────────────────────
        [HttpPost]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/quiz")]
        public async Task<IActionResult> CreateQuiz([FromBody] QuizRequest model)
        {
            // Validate grade
            var gradeResp = await _gradeService.ReadAsync(new GenericRequest<string> { Data = model.GradeUuid });
            if (gradeResp.IsError())
                return GetApiError(new[] { "Grade not found" }, (int)HttpStatusCode.BadRequest);

            // Assessment-type-specific validation & topic resolution
            IEnumerable<string> eligibleTopicFilter;

            if (model.AssessmentType == "daily_test")
            {
                if (model.TopicUuids == null || model.TopicUuids.Count == 0)
                    return GetApiError(
                        new[] { "daily_test requires at least one topic in TopicUuids" },
                        (int)HttpStatusCode.BadRequest);

                foreach (var topicUuid in model.TopicUuids.Distinct())
                {
                    var topicResp = await _topicService.ReadAsync(new GenericRequest<string> { Data = topicUuid });
                    if (topicResp.IsError())
                        return GetApiError(new[] { $"Topic '{topicUuid}' not found" }, (int)HttpStatusCode.BadRequest);
                }

                eligibleTopicFilter = model.TopicUuids;
            }
            else
            {
                if (!string.IsNullOrEmpty(model.SubjectUuid))
                {
                    var subjectResp = await _subjectService.ReadAsync(new GenericRequest<string> { Data = model.SubjectUuid });
                    if (subjectResp.IsError())
                        return GetApiError(new[] { "Subject not found" }, (int)HttpStatusCode.BadRequest);
                }
                if (!string.IsNullOrEmpty(model.TopicUuid))
                {
                    var topicResp = await _topicService.ReadAsync(new GenericRequest<string> { Data = model.TopicUuid });
                    if (topicResp.IsError())
                        return GetApiError(new[] { "Topic not found" }, (int)HttpStatusCode.BadRequest);
                }

                eligibleTopicFilter = string.IsNullOrEmpty(model.TopicUuid)
                    ? Enumerable.Empty<string>()
                    : new[] { model.TopicUuid };
            }

            // Fetch eligible pool and validate selected UUIDs
            var pool = await _questionRepository.SearchEligibleAsync(
                model.GradeUuid, eligibleTopicFilter, model.SubjectUuid);

            var poolMap = pool.ToDictionary(p => p.Uuid, p => p.Difficulty);

            var selected = new List<(string Uuid, string Difficulty)>();
            foreach (var qUuid in model.SelectedQuestionUuids.Distinct())
            {
                if (!poolMap.TryGetValue(qUuid, out var difficulty))
                    return GetApiError(
                        new[] { $"Question '{qUuid}' is not eligible for the selected grade/filters" },
                        (int)HttpStatusCode.BadRequest);
                selected.Add((qUuid, difficulty));
            }

            // Validate time limit
            var timeMap = BuildTimeMap(model.TimeVeryEasy, model.TimeEasy, model.TimeMedium, model.TimeHard, model.TimeVeryHard);
            int minTime = selected.Sum(q => timeMap.GetValueOrDefault(q.Difficulty, model.TimeMedium));

            if (model.TimeLimitSeconds < minTime)
                return GetApiError(
                    new[] { $"TimeLimitSeconds ({model.TimeLimitSeconds}s) is less than the minimum required time ({minTime}s)" },
                    (int)HttpStatusCode.BadRequest);

            // Build quiz DTO
            var quizUuid = GenerateUuid(UidTableConstant.Quiz);

            var dto = new QuizDto
            {
                Uuid = quizUuid,
                Title = model.Title,
                AssessmentType = model.AssessmentType,
                ShowScoreImmediately = model.AssessmentType == "quiz",
                SubjectUuid = string.IsNullOrEmpty(model.SubjectUuid) ? null : model.SubjectUuid,
                TopicUuid = string.IsNullOrEmpty(model.TopicUuid) ? null : model.TopicUuid,
                GradeUuid = model.GradeUuid,
                QuestionCount = selected.Count,
                TimeLimitSeconds = model.TimeLimitSeconds,
                MinTimeSeconds = minTime,
                TimeVeryEasy = model.TimeVeryEasy,
                TimeEasy = model.TimeEasy,
                TimeMedium = model.TimeMedium,
                TimeHard = model.TimeHard,
                TimeVeryHard = model.TimeVeryHard,
                Questions = selected.Select((q, i) =>
                {
                    var qq = new QuizQuestionDto
                    {
                        Uuid = GenerateUuid(UidTableConstant.QuizQuestion),
                        QuizUuid = quizUuid,
                        QuestionUuid = q.Uuid,
                        QuestionOrder = i + 1,
                    };
                    PopulateCreatedFields(qq);
                    return qq;
                }).ToList(),
                Topics = model.AssessmentType == "daily_test"
                    ? model.TopicUuids.Distinct().Select(topicUuid =>
                    {
                        var qt = new QuizTopicDto
                        {
                            Uuid = GenerateUuid(UidTableConstant.QuizTopic),
                            QuizUuid = quizUuid,
                            TopicUuid = topicUuid,
                        };
                        PopulateCreatedFields(qt);
                        return qt;
                    }).ToList()
                    : new List<QuizTopicDto>(),
            };

            PopulateCreatedFields(dto);

            var response = await _quizService.CreateWithQuestionsAsync(dto);
            if (response.IsError())
                return GetApiError(response.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);

            return Created("", new BasicApiResponse { Uuid = response.Data.Uuid });
        }

        // ── DELETE /v1/quiz/{id} ───────────────────────────────────────────────
        [HttpDelete]
        [Authorize(Policy.Administrator)]
        [Route("/v{version:apiversion}/quiz/{id}")]
        public async Task<IActionResult> DeleteQuiz([FromRoute][Required] string id)
        {
            var existing = await _quizService.ReadAsync(new GenericRequest<string> { Data = id });
            if (existing.IsError())
                return GetApiError(existing.GetMessageErrorTextArray(), (int)HttpStatusCode.NotFound);

            var deleteResp = await _quizService.DeleteAsync(new GenericRequest<string> { Data = id });
            if (deleteResp.IsError())
                return GetApiError(deleteResp.GetMessageErrorTextArray(), (int)HttpStatusCode.BadRequest);

            return Ok();
        }

        // ── Helpers ────────────────────────────────────────────────────────────
        private static Dictionary<string, int> BuildTimeMap(
            int veryEasy, int easy, int medium, int hard, int veryHard) =>
            new()
            {
                ["very easy"] = veryEasy,
                ["easy"]      = easy,
                ["medium"]    = medium,
                ["hard"]      = hard,
                ["very hard"] = veryHard,
            };
    }
}
