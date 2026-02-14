namespace MA.Framework.RepositoryInterface
{
    public interface IBaseRepository<TDto>
    {
        #region Public Async

        Task<TDto> InsertAsync(TDto dto);

        Task<TDto> ReadAsync(object primaryKey);

        Task<TDto> UpdateAsync(TDto dto);

        Task<TDto> DeleteAsync(object primaryKey);

        #endregion

        #region Public Sync

        TDto Insert(TDto dto);

        TDto Read(object primaryKey);

        TDto Update(TDto dto);

        TDto Delete(object primaryKey);

        #endregion

    }
}
