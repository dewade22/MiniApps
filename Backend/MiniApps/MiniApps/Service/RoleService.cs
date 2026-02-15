using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;
using MiniApps.ServiceInterface;

namespace MiniApps.Service
{
    public class RoleService : BaseService<RolesDto, string, IRoleRepository>, IRoleService
    {
        public RoleService(IRoleRepository repository)
            : base(repository)
        {

        }

        public async Task<GenericResponse<RolesDto>> ReadByName(string name)
        {
            var response = new GenericResponse<RolesDto>();
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
