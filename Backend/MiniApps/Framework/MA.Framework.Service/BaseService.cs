#nullable disable

using MA.Framework.Core.Resource;
using MA.Framework.Dto.Base;
using MA.Framework.RepositoryInterface;
using MA.Framework.ServiceInterface;
using MA.Framework.ServiceInterface.Request;
using MA.Framework.ServiceInterface.Response;

namespace MA.Framework.Service
{
    public abstract class BaseService<TDto, TDtoType, TRepository> : IBaseService<TDto, TDtoType>
        where TDto : AuditableDto<TDtoType>
        where TRepository : IBaseRepository<TDto>
    {
        protected readonly TRepository _repository;

        protected BaseService(TRepository repository)
        {
            _repository = repository;
        }

        #region Public Async

        public virtual async Task<GenericResponse<TDto>> DeleteAsync(GenericRequest<TDtoType> request)
        {
            var response = new GenericResponse<TDto>();
            if (response.IsError()) return response;

            var dto = await _repository.DeleteAsync(request.Data);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_DeleteNotFound);
                return response;
            }

            response.Data = dto;
            response.AddInfoMessage(GeneralResource.Info_Deleted);

            return response;
        }

        public virtual async Task<GenericResponse<TDto>> InsertAsync(GenericRequest<TDto> request)
        {
            var response = new GenericResponse<TDto>();
            if (response.IsError()) return response;

            var result = await _repository.InsertAsync(request.Data);

            response.Data = result;
            response.AddInfoMessage(GeneralResource.Info_Saved);

            return response;
        }

        public virtual async Task<GenericResponse<TDto>> ReadAsync(GenericRequest<TDtoType> request)
        {
            var response = new GenericResponse<TDto>();

            var dto = await _repository.ReadAsync(request.Data);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_NotFound);
                return response;
            }

            response.Data = dto;

            return response;
        }

        public virtual async Task<GenericResponse<TDto>> UpdateAsync(GenericRequest<TDto> request)
        {
            var response = new GenericResponse<TDto>();
            if (response.IsError()) return response;

            var dto = await _repository.UpdateAsync(request.Data);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_UpdateNotFound);
                return response;
            }

            response.Data = dto;
            response.AddInfoMessage(GeneralResource.Info_Saved);

            return response;
        }

        #endregion

        #region Public Sync

        public virtual GenericResponse<TDto> Delete(GenericRequest<TDto> request)
        {
            var response = new GenericResponse<TDto>();
            if (response.IsError()) return response;

            var dto = _repository.Delete(request.Data);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_DeleteNotFound);
                return response;
            }

            response.Data = dto;
            response.AddInfoMessage(GeneralResource.Info_Deleted);

            return response;
        }

        public virtual GenericResponse<TDto> Insert(GenericRequest<TDto> request)
        {
            var response = new GenericResponse<TDto>();
            if (response.IsError()) return response;

            var result = _repository.Insert(request.Data);

            response.Data = result;
            response.AddInfoMessage(GeneralResource.Info_Saved);

            return response;
        }

        public virtual GenericResponse<TDto> Read(GenericRequest<TDtoType> request)
        {
            var response = new GenericResponse<TDto>();

            var dto = _repository.Read(request.Data);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_NotFound);
                return response;
            }

            response.Data = dto;

            return response;
        }

        public virtual GenericResponse<TDto> Update(GenericRequest<TDto> request)
        {
            var response = new GenericResponse<TDto>();
            if (response.IsError()) return response;

            var dto = _repository.Update(request.Data);
            if (dto == null)
            {
                response.AddErrorMessage(GeneralResource.Item_UpdateNotFound);
                return response;
            }

            response.Data = dto;
            response.AddInfoMessage(GeneralResource.Info_Saved);

            return response;
        }

        #endregion
    }
}
