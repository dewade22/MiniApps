using AutoMapper;
using MiniApps.DataAccess.Application;
using MiniApps.Dto.Academic;
using MiniApps.Dto.Common;

namespace MiniApps.DataAccess
{
    public class AutoMapperProfile : Profile
    {
        public AutoMapperProfile()
        {
            this.CreateMap<ComUseraccount, UserAccountDto>().ReverseMap();
            this.CreateMap<ComUserinrole, UserInRoleDto>().ReverseMap();
            this.CreateMap<ComRole, RolesDto>().ReverseMap();
            this.CreateMap<ComUsermembership, UserMembershipDto>().ReverseMap();
            this.CreateMap<ComUserrefreshtoken, UserRefreshTokenDto>().ReverseMap();

            this.CreateMap<AcdmGrade, GradeDto>().ReverseMap();
        }
    }
}
