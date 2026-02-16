using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;

namespace MiniApps.Repository.Academic
{
    public class SubjectRepository : BaseRepository<ApplicationContext, AcdmSubject, SubjectDto, string>, ISubjectRepository
    {
        public SubjectRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public async Task<SubjectDto> ReadByName(string name)
        {
            var dbSet = Context.Set<AcdmSubject>();
            var entity = await dbSet.FirstOrDefaultAsync(x => x.Name == name);
            if (entity == null)
            {
                return null;
            }

            var dto = new SubjectDto();
            EntityToDto(entity, dto);

            return dto;
        }
    }
}
