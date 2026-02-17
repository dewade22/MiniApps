using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;

namespace MiniApps.ServiceInterface.Academic
{
    public interface ITopicService : IBaseService<TopicDto, string>
    {
        Task<GenericResponse<TopicDto>> ReadByNamAndSubject(string name, string subjectId);
    }
}
