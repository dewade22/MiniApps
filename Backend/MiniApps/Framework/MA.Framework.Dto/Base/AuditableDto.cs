namespace MA.Framework.Dto.Base
{
#nullable disable

    public abstract class AuditableDto<T> : BaseDto<T>
    {
        public string CreatedBy { get; set; }

        public DateTime CreatedAt { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime UpdatedAt { get; set; }
    }
}
