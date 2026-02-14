using Newtonsoft.Json;

namespace MA.Framework.Application.Model
{
#nullable disable
    public class ApiErrorModel
    {
        [JsonProperty("errorMessages")]
        public string[] ErrorMessages { get; set; }
    }
}
