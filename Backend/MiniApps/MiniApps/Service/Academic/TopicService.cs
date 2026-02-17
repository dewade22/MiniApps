using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.ServiceInterface.Academic;

namespace MiniApps.Service.Academic
{
    public class TopicService : BaseService<TopicDto, string, ITopicRepository>, ITopicService
    {
        public TopicService(ITopicRepository repository)
            : base(repository)
        {
        }

        public async Task<GenericResponse<TopicDto>> ReadByNamAndSubject(string name, string subjectId)
        {
            var response = new GenericResponse<TopicDto>();
            var dto = await this._repository.ReadByNameAndSubject(name, subjectId);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_NotFound);
                return response;
            }

            response.Data = dto;
            return response;
        }
    }
}
