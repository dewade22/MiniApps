using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.ServiceInterface.Academic;

namespace MiniApps.Service.Academic
{
    public class GradeService : BaseService<GradeDto, string, IGradeRepository>, IGradeService
    {
        public GradeService(IGradeRepository repository)
            : base(repository)
        {
        }

        public async Task<GenericResponse<GradeDto>> ReadByName(string name)
        {
            var response = new GenericResponse<GradeDto>();
            var dto = await this._repository.ReadByName(name);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_NotFound);
                return response;
            }

            response.Data = dto;
            return response;
        }
    }
}
