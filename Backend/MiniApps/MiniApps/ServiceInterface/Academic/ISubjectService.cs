using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;

namespace MiniApps.ServiceInterface.Academic
{
    public interface ISubjectService : IBaseService<SubjectDto, string>
    {
        Task<GenericResponse<SubjectDto>> ReadByName(string gradeName);
    }
}
