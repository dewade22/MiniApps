using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Core.Resource.UserAccount;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;
using MiniApps.ServiceInterface;

namespace MiniApps.Service
{
    public class UserInRoleService : BaseService<UserInRoleDto, string, IUserInRoleRepository>, IUserInRoleService
    {
        public UserInRoleService(IUserInRoleRepository repository)
            : base(repository)
        {
        }

        public async Task<GenericResponse<UserInRoleDto>> ReadByUserUuidAsync(string userUuid)
        {
            var response = new GenericResponse<UserInRoleDto>();

            var result = await this._repository.ReadByUserUuidAsync(userUuid);
            if (result == null)
            {
                response.AddErrorMessage(UserAccountResource.UserInRole_NotFound);
                return response;
            }

            response.Data = result;

            return response;
        }

        public async Task<GenericCollectionResponse<UserInRoleDto>> SearchByUserUuidAsync(string userUuid)
        {
            var response = new GenericCollectionResponse<UserInRoleDto>();
            var dtos = await this._repository.SearchByUserUuidAsync(userUuid);
            if (dtos == null || !dtos.Any())
            {
                response.AddErrorMessage(UserAccountResource.UserInRole_NotFound);
                return response;
            }

            foreach (var dto in dtos)
            {
                response.DtoCollection.Add(dto);
            }

            return response;
        }

        public async Task<GenericResponse<UserInRoleDto>> ReadByUserUuidRoleUuidAsync(string userUuid, string roleUuid)
        {
            var response = new GenericResponse<UserInRoleDto>();
            var dto = await this._repository.ReadByUserUuidRoleUuidAsync(userUuid, roleUuid);
            if (dto == null)
            {
                response.AddErrorMessage(UserAccountResource.UserInRole_NotFound);
                return response;
            }

            response.Data = dto;
            return response;
        }
    }
}
