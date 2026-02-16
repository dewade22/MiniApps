using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Common;

namespace MiniApps.ServiceInterface.Common
{
    public interface IUserInRoleService : IBaseService<UserInRoleDto, string>
    {
        Task<GenericResponse<UserInRoleDto>> ReadByUserUuidAsync(string userUuid);

        Task<GenericCollectionResponse<UserInRoleDto>> SearchByUserUuidAsync(string userUuid);

        Task<GenericResponse<UserInRoleDto>> ReadByUserUuidRoleUuidAsync(string userUuid, string roleUuid);
    }
}
