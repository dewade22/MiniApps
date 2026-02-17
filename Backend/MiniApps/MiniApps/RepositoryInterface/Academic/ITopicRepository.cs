using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Academic;

namespace MiniApps.RepositoryInterface.Academic
{
    public interface ITopicRepository : IBaseRepository<TopicDto>
    {
        Task<TopicDto> ReadByNameAndSubject(string name, string subjectId);
    }
}
