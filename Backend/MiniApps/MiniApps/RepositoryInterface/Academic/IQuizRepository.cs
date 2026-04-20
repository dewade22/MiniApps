using MA.Framework.RepositoryInterface;
using MiniApps.Dto.Academic;

namespace MiniApps.RepositoryInterface.Academic
{
    public interface IQuizRepository : IBaseRepository<QuizDto>
    {
        Task<QuizDto> ReadWithQuestionsAsync(string uuid);
        Task<QuizDto> CreateWithQuestionsAsync(QuizDto dto);
    }
}
