using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;

namespace MiniApps.Repository.Academic
{
    public class QuizRepository : BaseRepository<ApplicationContext, AcdmQuiz, QuizDto, string>, IQuizRepository
    {
        public QuizRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override async Task<List<QuizDto>> SearchAsync()
        {
            var entities = await Context.Set<AcdmQuiz>()
                .AsNoTracking()
                .Include(q => q.GradeUu)
                .Include(q => q.SubjectUu)
                .Include(q => q.TopicUu)
                .Include(q => q.AcdmQuizTopics)
                    .ThenInclude(qt => qt.TopicUu)
                .OrderByDescending(q => q.Createdat)
                .ToListAsync();

            var dtos = new List<QuizDto>();
            foreach (var entity in entities)
            {
                var dto = new QuizDto();
                MapQuizToDto(entity, dto);
                dtos.Add(dto);
            }
            return dtos;
        }

        public async Task<QuizDto> ReadWithQuestionsAsync(string uuid)
        {
            var entity = await Context.Set<AcdmQuiz>()
                .Include(q => q.GradeUu)
                .Include(q => q.SubjectUu)
                .Include(q => q.TopicUu)
                .Include(q => q.AcdmQuizTopics)
                    .ThenInclude(qt => qt.TopicUu)
                .Include(q => q.AcdmQuizQuestions.OrderBy(qq => qq.QuestionOrder))
                    .ThenInclude(qq => qq.QuestionUu)
                        .ThenInclude(qst => qst.AcdmQuestionOptions)
                .Include(q => q.AcdmQuizQuestions)
                    .ThenInclude(qq => qq.QuestionUu)
                        .ThenInclude(qst => qst.AcdmQuestionGrades)
                            .ThenInclude(g => g.GradeUu)
                .FirstOrDefaultAsync(q => q.Uuid == uuid);

            if (entity == null) return null;

            var dto = new QuizDto();
            MapQuizToDto(entity, dto);

            dto.Questions = entity.AcdmQuizQuestions
                .OrderBy(qq => qq.QuestionOrder)
                .Select(qq => MapQuizQuestion(qq, entity.GradeUuid))
                .ToList();

            return dto;
        }

        public async Task<QuizDto> CreateWithQuestionsAsync(QuizDto dto)
        {
            var entity = new AcdmQuiz
            {
                Uuid = dto.Uuid,
                Title = dto.Title,
                SubjectUuid = dto.SubjectUuid,
                TopicUuid = dto.TopicUuid,
                GradeUuid = dto.GradeUuid,
                QuestionCount = dto.QuestionCount,
                TimeLimitSeconds = dto.TimeLimitSeconds,
                MinTimeSeconds = dto.MinTimeSeconds,
                TimeVeryEasy = dto.TimeVeryEasy,
                TimeEasy = dto.TimeEasy,
                TimeMedium = dto.TimeMedium,
                TimeHard = dto.TimeHard,
                TimeVeryHard = dto.TimeVeryHard,
                AssessmentType = dto.AssessmentType,
                ShowScoreImmediately = dto.ShowScoreImmediately,
                Createdby = dto.CreatedBy,
                Createdat = dto.CreatedAt,
                Updatedby = dto.UpdatedBy,
                Updatedat = dto.UpdatedAt,
            };

            foreach (var qqDto in dto.Questions)
            {
                entity.AcdmQuizQuestions.Add(new AcdmQuizQuestion
                {
                    Uuid = qqDto.Uuid,
                    QuizUuid = entity.Uuid,
                    QuestionUuid = qqDto.QuestionUuid,
                    QuestionOrder = qqDto.QuestionOrder,
                    Createdby = qqDto.CreatedBy,
                    Createdat = qqDto.CreatedAt,
                    Updatedby = qqDto.UpdatedBy,
                    Updatedat = qqDto.UpdatedAt,
                });
            }

            foreach (var topicDto in dto.Topics)
            {
                entity.AcdmQuizTopics.Add(new AcdmQuizTopic
                {
                    Uuid = topicDto.Uuid,
                    QuizUuid = entity.Uuid,
                    TopicUuid = topicDto.TopicUuid,
                    Createdby = topicDto.CreatedBy,
                    Createdat = topicDto.CreatedAt,
                    Updatedby = topicDto.UpdatedBy,
                    Updatedat = topicDto.UpdatedAt,
                });
            }

            Context.Set<AcdmQuiz>().Add(entity);
            await Context.SaveChangesAsync();

            return dto;
        }

        private static void MapQuizToDto(AcdmQuiz entity, QuizDto dto)
        {
            dto.Uuid = entity.Uuid;
            dto.Title = entity.Title;
            dto.SubjectUuid = entity.SubjectUuid;
            dto.SubjectName = entity.SubjectUu?.Name;
            dto.TopicUuid = entity.TopicUuid;
            dto.TopicName = entity.TopicUu?.Name;
            dto.GradeUuid = entity.GradeUuid;
            dto.GradeName = entity.GradeUu?.Name;
            dto.QuestionCount = entity.QuestionCount;
            dto.TimeLimitSeconds = entity.TimeLimitSeconds;
            dto.MinTimeSeconds = entity.MinTimeSeconds;
            dto.TimeVeryEasy = entity.TimeVeryEasy;
            dto.TimeEasy = entity.TimeEasy;
            dto.TimeMedium = entity.TimeMedium;
            dto.TimeHard = entity.TimeHard;
            dto.TimeVeryHard = entity.TimeVeryHard;
            dto.AssessmentType = entity.AssessmentType;
            dto.ShowScoreImmediately = entity.ShowScoreImmediately;
            dto.Topics = entity.AcdmQuizTopics
                .Select(qt => new QuizTopicDto
                {
                    Uuid = qt.Uuid,
                    QuizUuid = qt.QuizUuid,
                    TopicUuid = qt.TopicUuid,
                    TopicName = qt.TopicUu?.Name,
                    CreatedBy = qt.Createdby,
                    CreatedAt = qt.Createdat,
                    UpdatedBy = qt.Updatedby,
                    UpdatedAt = qt.Updatedat,
                })
                .OrderBy(t => t.TopicName)
                .ToList();
            dto.CreatedBy = entity.Createdby;
            dto.CreatedAt = entity.Createdat;
            dto.UpdatedBy = entity.Updatedby;
            dto.UpdatedAt = entity.Updatedat;
        }

        private static QuizQuestionDto MapQuizQuestion(AcdmQuizQuestion qq, string gradeUuid)
        {
            var gradeAssignment = qq.QuestionUu?.AcdmQuestionGrades
                .FirstOrDefault(g => g.GradeUuid == gradeUuid);

            return new QuizQuestionDto
            {
                Uuid = qq.Uuid,
                QuizUuid = qq.QuizUuid,
                QuestionUuid = qq.QuestionUuid,
                QuestionOrder = qq.QuestionOrder,
                QuestionText = qq.QuestionUu?.QuestionText,
                CorrectOption = qq.QuestionUu?.CorrectOption,
                Difficulty = gradeAssignment?.Difficulty ?? "medium",
                Options = qq.QuestionUu?.AcdmQuestionOptions
                    .OrderBy(o => o.Label)
                    .Select(o => new QuestionOptionDto
                    {
                        Uuid = o.Uuid,
                        Label = o.Label,
                        OptionText = o.OptionText,
                    })
                    .ToList() ?? new List<QuestionOptionDto>(),
                CreatedBy = qq.Createdby,
                CreatedAt = qq.Createdat,
                UpdatedBy = qq.Updatedby,
                UpdatedAt = qq.Updatedat,
            };
        }
    }
}
