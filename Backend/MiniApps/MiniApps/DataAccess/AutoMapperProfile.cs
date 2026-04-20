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
            this.CreateMap<AcdmSubject, SubjectDto>().ReverseMap();
            this.CreateMap<AcdmTopic, TopicDto>().ReverseMap();
            this.CreateMap<AcdmQuestion, QuestionDto>().ReverseMap();
            this.CreateMap<AcdmQuestionOption, QuestionOptionDto>().ReverseMap();
            this.CreateMap<AcdmQuestionGrade, QuestionGradeDto>().ReverseMap();
            this.CreateMap<AcdmQuiz, QuizDto>().ReverseMap();
            this.CreateMap<AcdmQuizQuestion, QuizQuestionDto>().ReverseMap();
            this.CreateMap<AcdmQuizTopic, QuizTopicDto>().ReverseMap();
            this.CreateMap<AcdmSchool, SchoolDto>().ReverseMap();
        }
    }
}
