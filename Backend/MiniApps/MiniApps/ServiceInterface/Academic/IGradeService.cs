using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Response;
using MiniApps.Dto.Academic;

namespace MiniApps.ServiceInterface.Academic
{
    public interface IGradeService : IBaseService<GradeDto, string>
    {
        Task<GenericResponse<GradeDto>> ReadByName(string gradeName);
    }
}
