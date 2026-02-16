using AutoMapper;
using MA.Framework.Repository;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Common;
using MiniApps.RepositoryInterface.Common;

namespace MiniApps.Repository.Common
{
    public class UserMembershipRepository : BaseRepository<ApplicationContext, ComUsermembership, UserMembershipDto, string>, IUserMembershipRepository
    {
        public UserMembershipRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {

        }
    }
}
