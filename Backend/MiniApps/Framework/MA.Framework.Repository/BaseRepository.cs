#nullable disable

using AutoMapper;
using MA.Framework.Dto.Base;
using MA.Framework.RepositoryInterface;
using Microsoft.EntityFrameworkCore;

namespace MA.Framework.Repository
{
    public abstract class BaseRepository<TContext, TEntity, TDto, TDtoType> : IBaseRepository<TDto>
        where TContext : DbContext, new()
        where TEntity : class, new()
        where TDto : BaseDto<TDtoType>, new()
    {
        protected IMapper Mapper { get; }

        protected TContext Context { get; }

        protected BaseRepository(TContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        #region Public Async

        public virtual async Task<TDto> DeleteAsync(object primaryKey)
        {
            try
            {
                var dbSet = this.Context.Set<TEntity>();
                var entity = await dbSet.FindAsync(primaryKey);
                if (entity == null) return null;

                var dto = new TDto();
                EntityToDto(entity, dto);

                dbSet.Remove(entity);
                await this.Context.SaveChangesAsync();

                return dto;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        public virtual async Task<TDto> InsertAsync(TDto dto)
        {
            try
            {
                var entity = new TEntity();
                DtoToEntity(dto, entity);

                var dbSet = this.Context.Set<TEntity>();
                dbSet.Add(entity);
                var numObj = await this.Context.SaveChangesAsync();
                if (numObj > 0)
                {
                    var type = entity.GetType();
                    var prop = type.GetProperty("Uuid");
                    dto.Uuid = (TDtoType)Convert.ChangeType(prop.GetValue(entity).ToString(), typeof(TDtoType));
                }

                return dto;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        public virtual async Task<TDto> ReadAsync(object primaryKey)
        {
            var dbSet = this.Context.Set<TEntity>();
            var entity = await dbSet.FindAsync(primaryKey);
            if (entity == null) return null;

            var dto = new TDto();
            EntityToDto(entity, dto);
            return dto;
        }

        public async Task<TDto> UpdateAsync(TDto dto)
        {
            try
            {
                var dbSet = this.Context.Set<TEntity>();

                var entity = await dbSet.FindAsync(dto.Uuid);
                if (entity == null) return null;

                DtoToEntity(dto, entity);
                dbSet.Update(entity);

                await this.Context.SaveChangesAsync();

                return dto;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        public virtual async Task<List<TDto>> SearchAsync()
        {
            try
            {
                var dbSet = this.Context.Set<TEntity>();

                var entities = await dbSet.AsNoTracking().ToListAsync();
                if (entities == null) return null;
                var dtos = new List<TDto>();
                foreach (var entity in entities)
                {
                    var dto = new TDto();
                    EntityToDto(entity, dto);
                    dtos.Add(dto);
                }

                return dtos;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        #endregion

        #region Public Sync

        public virtual TDto Delete(object primaryKey)
        {
            try
            {
                var dbSet = this.Context.Set<TEntity>();
                var entity = dbSet.Find(primaryKey);
                if (entity == null) return null;

                var dto = new TDto();
                EntityToDto(entity, dto);

                dbSet.Remove(entity);
                this.Context.SaveChanges();

                return dto;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        public virtual TDto Insert(TDto dto)
        {
            try
            {
                var entity = new TEntity();
                DtoToEntity(dto, entity);

                var dbSet = this.Context.Set<TEntity>();
                dbSet.Add(entity);
                var numObj = this.Context.SaveChanges();
                if (numObj > 0)
                {
                    var type = entity.GetType();
                    var prop = type.GetProperty("Uuid");
                    dto.Uuid = (TDtoType)Convert.ChangeType(prop.GetValue(entity).ToString(), typeof(TDtoType));
                }

                return dto;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        public virtual TDto Read(object primaryKey)
        {
            var dbSet = this.Context.Set<TEntity>();
            var entity = dbSet.Find(primaryKey);
            if (entity == null) return null;

            var dto = new TDto();
            EntityToDto(entity, dto);
            return dto;
        }

        public virtual TDto Update(TDto dto)
        {
            try
            {
                var dbSet = this.Context.Set<TEntity>();

                var entity = dbSet.Find(dto.Uuid);
                if (entity == null) return null;

                DtoToEntity(dto, entity);
                dbSet.Update(entity);

                this.Context.SaveChanges();

                return dto;
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
        }

        #endregion

        #region Protected

        protected virtual void DtoToEntity(TDto dto, TEntity entity)
        {
            Mapper.Map(dto, entity);
        }

        protected virtual void EntityToDto(TEntity entity, TDto dto)
        {
            Mapper.Map(entity, dto);
        }

        protected virtual void EntityToDtoWithRelation(TEntity entity, TDto dto)
        {
            Mapper.Map(entity, dto);
        }

        #endregion
    }
}
