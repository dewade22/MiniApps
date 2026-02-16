using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Common;

namespace MiniApps.RepositoryInterface.Common
{
    public interface IUserInRoleRepository : IBaseRepository<UserInRoleDto>
    {
        Task<UserInRoleDto> ReadByUserUuidAsync(string userUuid);

        Task<List<UserInRoleDto>> SearchByUserUuidAsync(string userUuid);

        Task<UserInRoleDto> ReadByUserUuidRoleUuidAsync(string userUuid, string roleUuid);
    }
}
