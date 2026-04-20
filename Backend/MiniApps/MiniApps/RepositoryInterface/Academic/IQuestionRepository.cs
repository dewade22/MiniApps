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
        /// <summary>
        /// Returns (uuid, difficulty) pairs for questions eligible for the given grade.
        /// Optionally filtered by one or more topicUuids (OR logic) or subjectUuid.
        /// </summary>
        Task<List<(string Uuid, string Difficulty)>> SearchEligibleAsync(
            string gradeUuid, IEnumerable<string> topicUuids, string subjectUuid);

        /// <summary>Same filter as SearchEligibleAsync but returns full QuestionDto with options.</summary>
        Task<List<QuestionDto>> SearchEligibleWithDetailsAsync(
            string gradeUuid, IEnumerable<string> topicUuids, string subjectUuid);
    }
}
