using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;

namespace MiniApps.ServiceInterface.Academic
{
    public interface IQuizService : IBaseService<QuizDto, string>
    {
        Task<GenericResponse<QuizDto>> ReadWithQuestionsAsync(string uuid);
        Task<GenericResponse<QuizDto>> CreateWithQuestionsAsync(QuizDto dto);
    }
}
