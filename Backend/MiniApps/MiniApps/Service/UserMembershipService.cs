using MA.Framework.Service;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;
using MiniApps.ServiceInterface;

namespace MiniApps.Service
{
    public class UserMembershipService : BaseService<UserMembershipDto, string, IUserMembershipRepository>, IUserMembershipService
    {
        public UserMembershipService(IUserMembershipRepository repository)
            : base(repository)
        {

        }
    }
}
