using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.ServiceInterface.Academic;

namespace MiniApps.Service.Academic
{
    public class SubjectService : BaseService<SubjectDto, string, ISubjectRepository>, ISubjectService
    {
        public SubjectService(ISubjectRepository repository)
            : base(repository)
        {
        }

        public async Task<GenericResponse<SubjectDto>> ReadByName(string name)
        {
            var response = new GenericResponse<SubjectDto>();
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
