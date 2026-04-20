using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Academic;

namespace MiniApps.RepositoryInterface.Academic
{
    public interface IQuestionRepository : IBaseRepository<QuestionDto>
    {
        Task<List<QuestionDto>> SearchByTopicAsync(string topicUuid);
        Task<QuestionDto> ReadWithOptionsAsync(string uuid);
        Task<QuestionDto> InsertWithOptionsAsync(QuestionDto dto);
        Task<QuestionDto> UpdateWithOptionsAsync(QuestionDto dto);
    }
}
