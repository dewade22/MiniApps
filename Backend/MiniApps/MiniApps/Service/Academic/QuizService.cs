using MA.Framework.Core.Resource;
using MA.Framework.Service;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.ServiceInterface.Academic;

namespace MiniApps.Service.Academic
{
    public class QuizService : BaseService<QuizDto, string, IQuizRepository>, IQuizService
    {
        public QuizService(IQuizRepository repository)
            : base(repository)
        {
        }

        public async Task<GenericResponse<QuizDto>> ReadWithQuestionsAsync(string uuid)
        {
            var response = new GenericResponse<QuizDto>();
            var dto = await this._repository.ReadWithQuestionsAsync(uuid);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_NotFound);
                return response;
            }
            response.Data = dto;
            return response;
        }

        public async Task<GenericResponse<QuizDto>> CreateWithQuestionsAsync(QuizDto dto)
        {
            var response = new GenericResponse<QuizDto>();
            var result = await this._repository.CreateWithQuestionsAsync(dto);
            if (result == null)
            {
                response.AddErrorMessage(GeneralResource.General_RequestInvalid);
                return response;
            }
            response.Data = result;
            return response;
        }
    }
}
