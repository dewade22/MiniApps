using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;

namespace MiniApps.ServiceInterface.Academic
{
    public interface IQuestionService : IBaseService<QuestionDto, string>
    {
        Task<GenericCollectionResponse<QuestionDto>> SearchByTopicAsync(string topicUuid);
        Task<GenericResponse<QuestionDto>> ReadWithOptionsAsync(string uuid);
        Task<GenericResponse<QuestionDto>> InsertWithOptionsAsync(QuestionDto dto);
        Task<GenericResponse<QuestionDto>> UpdateWithOptionsAsync(QuestionDto dto);
    }
}
