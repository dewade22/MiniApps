using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.ServiceInterface.Academic;

namespace MiniApps.Service.Academic
{
    public class QuestionService : BaseService<QuestionDto, string, IQuestionRepository>, IQuestionService
    {
        public QuestionService(IQuestionRepository repository)
            : base(repository)
        {
        }

        public async Task<GenericCollectionResponse<QuestionDto>> SearchByTopicAsync(string topicUuid)
        {
            var response = new GenericCollectionResponse<QuestionDto>();
            var dtos = await this._repository.SearchByTopicAsync(topicUuid);
            if (dtos != null)
            {
                foreach (var dto in dtos)
                {
                    response.DtoCollection.Add(dto);
                }
            }

            return response;
        }

        public async Task<GenericResponse<QuestionDto>> ReadWithOptionsAsync(string uuid)
        {
            var response = new GenericResponse<QuestionDto>();
            var dto = await this._repository.ReadWithOptionsAsync(uuid);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_NotFound);
                return response;
            }

            response.Data = dto;
            return response;
        }

        public async Task<GenericResponse<QuestionDto>> InsertWithOptionsAsync(QuestionDto dto)
        {
            var response = new GenericResponse<QuestionDto>();
            var result = await this._repository.InsertWithOptionsAsync(dto);
            if (result == null)
            {
                response.AddErrorMessage(GeneralResource.General_RequestInvalid);
                return response;
            }

            response.Data = result;
            return response;
        }

        public async Task<GenericResponse<QuestionDto>> UpdateWithOptionsAsync(QuestionDto dto)
        {
            var response = new GenericResponse<QuestionDto>();
            var result = await this._repository.UpdateWithOptionsAsync(dto);
            if (result == null)
            {
                response.AddErrorMessage(GeneralResource.Item_NotFound);
                return response;
            }

            response.Data = result;
            return response;
        }
    }
}
