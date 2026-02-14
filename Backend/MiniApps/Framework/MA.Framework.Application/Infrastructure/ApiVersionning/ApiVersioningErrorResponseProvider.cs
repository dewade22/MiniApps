using MA.Framework.Application.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Versioning;
using System.Net;

namespace MA.Framework.Application.Infrastructure.ApiVersionning
{
    public class ApiVersioningErrorResponseProvider : DefaultErrorResponseProvider
    {
        public override IActionResult CreateResponse(ErrorResponseContext context)
        {
            var responseObj = new ApiErrorModel
            {
                ErrorMessages = new string[] { context.Message }
            };

            var response = new ObjectResult(responseObj);
            response.StatusCode = (int)HttpStatusCode.BadRequest;

            return response;
        }
    }
}
