namespace MA.Framework.ServiceInterface.Response
{
#nullable disable

    public class GenericCollectionResponse<TDto> : BasicResponse
    {
        private List<TDto> _dtoList;

        public GenericCollectionResponse()
        {
        }

        public GenericCollectionResponse(int capacity)
        {
            this._dtoList = new List<TDto>(capacity);
        }

        public ICollection<TDto> DtoCollection
        {
            get { return this._dtoList ?? (this._dtoList = new List<TDto>()); }
        }
    }
}
