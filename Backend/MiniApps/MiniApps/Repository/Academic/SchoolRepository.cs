using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;

namespace MiniApps.Repository.Academic
{
    public class SchoolRepository : BaseRepository<ApplicationContext, AcdmSchool, SchoolDto, string>, ISchoolRepository
    {
        public SchoolRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override async Task<List<SchoolDto>> SearchAsync()
        {
            var entities = await Context.Set<AcdmSchool>()
                .AsNoTracking()
                .OrderBy(s => s.Name)
                .ToListAsync();

            return Mapper.Map<List<SchoolDto>>(entities);
        }
    }
}
