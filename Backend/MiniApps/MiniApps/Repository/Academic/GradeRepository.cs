using AutoMapper;
using MA.Framework.Repository;
using Microsoft.EntityFrameworkCore;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Academic;
using MiniApps.Dto.Common;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.RepositoryInterface.Common;

namespace MiniApps.Repository.Academic
{
    public class GradeRepository : BaseRepository<ApplicationContext, AcdmGrade, GradeDto, string>, IGradeRepository
    {
        public GradeRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public async Task<GradeDto> ReadByName(string name)
        {
            var dbSet = Context.Set<AcdmGrade>();
            var entity = await dbSet.FirstOrDefaultAsync(x => x.Name == name);
            if (entity == null)
            {
                return null;
            }

            var dto = new GradeDto();
            EntityToDto(entity, dto);

            return dto;
        }
    }
}
