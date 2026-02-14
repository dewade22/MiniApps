using MA.Framework.ServiceInterface.Request;
using MA.Framework.ServiceInterface.Response;

namespace MA.Framework.ServiceInterface
{
    public interface IBaseService<TDto, TDtoType>
    {
        #region Public Async

        Task<GenericResponse<TDto>> InsertAsync(GenericRequest<TDto> request);

        Task<GenericResponse<TDto>> ReadAsync(GenericRequest<TDtoType> request);

        Task<GenericResponse<TDto>> UpdateAsync(GenericRequest<TDto> request);

        Task<GenericResponse<TDto>> DeleteAsync(GenericRequest<TDtoType> request);

        #endregion

        #region Public Sync

        GenericResponse<TDto> Insert(GenericRequest<TDto> request);

        GenericResponse<TDto> Read(GenericRequest<TDtoType> request);

        GenericResponse<TDto> Update(GenericRequest<TDto> request);

        GenericResponse<TDto> Delete(GenericRequest<TDto> request);

        #endregion
    }
}
