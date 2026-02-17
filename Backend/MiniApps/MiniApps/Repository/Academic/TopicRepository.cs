using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;

namespace MiniApps.Repository.Academic
{
    public class TopicRepository : BaseRepository<ApplicationContext, AcdmTopic, TopicDto, string>, ITopicRepository
    {
        public TopicRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public async Task<TopicDto> ReadByNameAndSubject(string name, string subjectId)
        {
            var dbSet = Context.Set<AcdmTopic>();
            var entity = await dbSet.FirstOrDefaultAsync(x => x.Name == name && x.SubjectUuid == subjectId);
            if (entity == null)
            {
                return null;
            }

            var dto = new TopicDto();
            EntityToDto(entity, dto);

            return dto;
        }

        public async Task<List<TopicDto>> SearchAsync(string subjectId)
        {
            var dbSet = Context.Set<AcdmTopic>();
            var entities = await dbSet.Where(x =>x.SubjectUuid == subjectId).AsNoTracking().ToListAsync();
            if (entities == null || !entities.Any())
            {
                return null;
            }

            var result = new List<TopicDto>();
            foreach (var entity in entities)
            {
                var dto = new TopicDto();
                EntityToDto(entity, dto);
                result.Add(dto);
            }

            return result;
        }
    }
}
