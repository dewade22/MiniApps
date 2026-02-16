using MA.Framework.Service;
using MiniApps.Dto.Common;
using MiniApps.RepositoryInterface.Common;
using MiniApps.ServiceInterface.Common;

namespace MiniApps.Service.Common
{
    public class UserMembershipService : BaseService<UserMembershipDto, string, IUserMembershipRepository>, IUserMembershipService
    {
        public UserMembershipService(IUserMembershipRepository repository)
            : base(repository)
        {

        }
    }
}
