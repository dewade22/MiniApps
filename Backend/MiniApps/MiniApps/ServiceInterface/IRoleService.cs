using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto;

namespace MiniApps.ServiceInterface
{
    public interface IRoleService : IBaseService<RolesDto, string>
    {
        Task<GenericResponse<RolesDto>> ReadByName(string name);
    }
}
