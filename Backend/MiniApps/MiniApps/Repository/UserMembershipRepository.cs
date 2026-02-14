using AutoMapper;
using MA.Framework.Repository;
using MiniApps.DataAccess.Application;
using MiniApps.Dto;
using MiniApps.RepositoryInterface;

namespace MiniApps.Repository
{
    public class UserMembershipRepository : BaseRepository<ApplicationContext, ComUsermembership, UserMembershipDto, string>, IUserMembershipRepository
    {
        public UserMembershipRepository(ApplicationContext context, IMapper mapper)
            : base(context, mapper)
        {

        }
    }
}
