using MA.Framework.ServiceInterface;
using MiniApps.Dto;

namespace MiniApps.ServiceInterface
{
    public interface IUserMembershipService : IBaseService<UserMembershipDto, string>
    {
    }
}
