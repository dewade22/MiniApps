namespace MA.Framework.ServiceInterface.Response
{
#nullable disable

    public class GenericResponse<T> : BasicResponse
    {
        public T Data { get; set; }
    }
}
