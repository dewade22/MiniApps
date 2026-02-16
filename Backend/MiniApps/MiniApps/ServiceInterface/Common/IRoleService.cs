using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Common;

namespace MiniApps.ServiceInterface.Common
{
    public interface IRoleService : IBaseService<RolesDto, string>
    {
        Task<GenericResponse<RolesDto>> ReadByName(string name);
    }
}
