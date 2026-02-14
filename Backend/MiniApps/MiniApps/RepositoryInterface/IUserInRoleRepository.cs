using MA.Framework.RepositoryInterface;
using MiniApps.Dto;

namespace MiniApps.RepositoryInterface
{
    public interface IUserInRoleRepository : IBaseRepository<UserInRoleDto>
    {
        Task<UserInRoleDto> ReadByUserUuidAsync(string userUuid);

        Task<List<UserInRoleDto>> SearchByUserUuidAsync(string userUuid);

        Task<UserInRoleDto> ReadByUserUuidRoleUuidAsync(string userUuid, string roleUuid);
    }
}
