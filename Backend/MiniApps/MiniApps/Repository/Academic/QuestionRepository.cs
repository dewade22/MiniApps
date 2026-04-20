using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;

namespace MiniApps.Repository.Academic
{
    public class QuestionRepository : BaseRepository<ApplicationContext, AcdmQuestion, QuestionDto, string>, IQuestionRepository
    {
        public QuestionRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override async Task<List<QuestionDto>> SearchAsync()
        {
            var entities = await Context.Set<AcdmQuestion>()
                .AsNoTracking()
                .Include(q => q.AcdmQuestionOptions)
                .Include(q => q.AcdmQuestionGrades)
                    .ThenInclude(g => g.GradeUu)
                .ToListAsync();

            var dtos = new List<QuestionDto>();
            if (entities == null) return dtos;

            foreach (var entity in entities)
            {
                var dto = new QuestionDto();
                EntityToDtoWithRelation(entity, dto);
                dtos.Add(dto);
            }

            return dtos;
        }

        public async Task<List<QuestionDto>> SearchByTopicAsync(string topicUuid)
        {
            var entities = await Context.Set<AcdmQuestion>()
                .AsNoTracking()
                .Include(q => q.AcdmQuestionOptions)
                .Include(q => q.AcdmQuestionGrades)
                    .ThenInclude(g => g.GradeUu)
                .Where(q => q.TopicUuid == topicUuid)
                .ToListAsync();

            var dtos = new List<QuestionDto>();
            if (entities == null) return dtos;

            foreach (var entity in entities)
            {
                var dto = new QuestionDto();
                EntityToDtoWithRelation(entity, dto);
                dtos.Add(dto);
            }

            return dtos;
        }

        public async Task<QuestionDto> ReadWithOptionsAsync(string uuid)
        {
            var entity = await Context.Set<AcdmQuestion>()
                .Include(q => q.AcdmQuestionOptions)
                .Include(q => q.AcdmQuestionGrades)
                    .ThenInclude(g => g.GradeUu)
                .FirstOrDefaultAsync(q => q.Uuid == uuid);

            if (entity == null) return null;

            var dto = new QuestionDto();
            EntityToDtoWithRelation(entity, dto);
            return dto;
        }

        public async Task<QuestionDto> InsertWithOptionsAsync(QuestionDto dto)
        {
            var entity = new AcdmQuestion();
            DtoToEntity(dto, entity);

            foreach (var optionDto in dto.Options)
            {
                entity.AcdmQuestionOptions.Add(new AcdmQuestionOption
                {
                    Uuid = optionDto.Uuid,
                    QuestionUuid = entity.Uuid,
                    Label = optionDto.Label,
                    OptionText = optionDto.OptionText,
                    Createdby = optionDto.CreatedBy,
                    Createdat = optionDto.CreatedAt,
                    Updatedby = optionDto.UpdatedBy,
                    Updatedat = optionDto.UpdatedAt,
                });
            }

            foreach (var gradeDto in dto.Grades)
            {
                entity.AcdmQuestionGrades.Add(new AcdmQuestionGrade
                {
                    Uuid = gradeDto.Uuid,
                    QuestionUuid = entity.Uuid,
                    GradeUuid = gradeDto.GradeUuid,
                    Difficulty = gradeDto.Difficulty,
                    Createdby = gradeDto.CreatedBy,
                    Createdat = gradeDto.CreatedAt,
                    Updatedby = gradeDto.UpdatedBy,
                    Updatedat = gradeDto.UpdatedAt,
                });
            }

            Context.Set<AcdmQuestion>().Add(entity);
            await Context.SaveChangesAsync();

            return dto;
        }

        public async Task<QuestionDto> UpdateWithOptionsAsync(QuestionDto dto)
        {
            var entity = await Context.Set<AcdmQuestion>()
                .Include(q => q.AcdmQuestionOptions)
                .Include(q => q.AcdmQuestionGrades)
                .FirstOrDefaultAsync(q => q.Uuid == dto.Uuid);

            if (entity == null) return null;

            DtoToEntity(dto, entity);

            // Replace options
            entity.AcdmQuestionOptions.Clear();
            foreach (var optionDto in dto.Options)
            {
                entity.AcdmQuestionOptions.Add(new AcdmQuestionOption
                {
                    Uuid = optionDto.Uuid,
                    QuestionUuid = entity.Uuid,
                    Label = optionDto.Label,
                    OptionText = optionDto.OptionText,
                    Createdby = optionDto.CreatedBy,
                    Createdat = optionDto.CreatedAt,
                    Updatedby = optionDto.UpdatedBy,
                    Updatedat = optionDto.UpdatedAt,
                });
            }

            // Replace grade assignments
            entity.AcdmQuestionGrades.Clear();
            foreach (var gradeDto in dto.Grades)
            {
                entity.AcdmQuestionGrades.Add(new AcdmQuestionGrade
                {
                    Uuid = gradeDto.Uuid,
                    QuestionUuid = entity.Uuid,
                    GradeUuid = gradeDto.GradeUuid,
                    Difficulty = gradeDto.Difficulty,
                    Createdby = gradeDto.CreatedBy,
                    Createdat = gradeDto.CreatedAt,
                    Updatedby = gradeDto.UpdatedBy,
                    Updatedat = gradeDto.UpdatedAt,
                });
            }

            Context.Set<AcdmQuestion>().Update(entity);
            await Context.SaveChangesAsync();

            return dto;
        }

        public async Task<List<QuestionDto>> SearchEligibleWithDetailsAsync(
            string gradeUuid, IEnumerable<string> topicUuids, string subjectUuid)
        {
            var topicList = topicUuids?.Where(t => !string.IsNullOrEmpty(t)).ToList()
                            ?? new List<string>();

            var query = Context.Set<AcdmQuestion>()
                .AsNoTracking()
                .Include(q => q.AcdmQuestionOptions)
                .Include(q => q.AcdmQuestionGrades)
                    .ThenInclude(g => g.GradeUu)
                .Where(q => q.AcdmQuestionGrades.Any(g => g.GradeUuid == gradeUuid));

            if (topicList.Any())
            {
                query = query.Where(q => topicList.Contains(q.TopicUuid));
            }
            else if (!string.IsNullOrEmpty(subjectUuid))
            {
                query = query.Where(q =>
                    Context.Set<AcdmTopic>()
                        .Any(t => t.Uuid == q.TopicUuid && t.SubjectUuid == subjectUuid));
            }

            var entities = await query.ToListAsync();

            var dtos = new List<QuestionDto>();
            foreach (var entity in entities)
            {
                var dto = new QuestionDto();
                EntityToDtoWithRelation(entity, dto);
                dtos.Add(dto);
            }
            return dtos;
        }

        public async Task<List<(string Uuid, string Difficulty)>> SearchEligibleAsync(
            string gradeUuid, IEnumerable<string> topicUuids, string subjectUuid)
        {
            var topicList = topicUuids?.Where(t => !string.IsNullOrEmpty(t)).ToList()
                            ?? new List<string>();

            var query = Context.Set<AcdmQuestion>()
                .AsNoTracking()
                .Include(q => q.AcdmQuestionGrades)
                .Where(q => q.AcdmQuestionGrades.Any(g => g.GradeUuid == gradeUuid));

            if (topicList.Any())
            {
                query = query.Where(q => topicList.Contains(q.TopicUuid));
            }
            else if (!string.IsNullOrEmpty(subjectUuid))
            {
                query = query.Where(q =>
                    Context.Set<AcdmTopic>()
                        .Any(t => t.Uuid == q.TopicUuid && t.SubjectUuid == subjectUuid));
            }

            var entities = await query.ToListAsync();

            return entities
                .Select(q => (
                    q.Uuid,
                    q.AcdmQuestionGrades.First(g => g.GradeUuid == gradeUuid).Difficulty
                ))
                .ToList();
        }

        protected override void EntityToDtoWithRelation(AcdmQuestion entity, QuestionDto dto)
        {
            Mapper.Map(entity, dto);

            dto.Options = entity.AcdmQuestionOptions
                .Select(o => new QuestionOptionDto
                {
                    Uuid = o.Uuid,
                    QuestionUuid = o.QuestionUuid,
                    Label = o.Label,
                    OptionText = o.OptionText,
                    CreatedBy = o.Createdby,
                    CreatedAt = o.Createdat,
                    UpdatedBy = o.Updatedby,
                    UpdatedAt = o.Updatedat,
                })
                .OrderBy(o => o.Label)
                .ToList();

            dto.Grades = entity.AcdmQuestionGrades
                .Select(g => new QuestionGradeDto
                {
                    Uuid = g.Uuid,
                    QuestionUuid = g.QuestionUuid,
                    GradeUuid = g.GradeUuid,
                    GradeName = g.GradeUu?.Name,
                    Difficulty = g.Difficulty,
                    CreatedBy = g.Createdby,
                    CreatedAt = g.Createdat,
                    UpdatedBy = g.Updatedby,
                    UpdatedAt = g.Updatedat,
                })
                .OrderBy(g => g.GradeName)
                .ToList();
        }
    }
}
