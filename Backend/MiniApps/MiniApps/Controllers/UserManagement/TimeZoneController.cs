using MA.Framework.Application.Controller;
using MA.Framework.Core.Constant;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MiniApps.Controllers.UserManagement
{
    [ApiController]
    [Route("v/{version:apiversion}/[controller]")]
    [ApiVersion("1.0")]
    public class TimeZoneController : BaseController
    {
        [HttpGet]
        [Authorize(Policy.AllRoles)]
        [Route("/v{version:apiversion}/timezones")]
        public IActionResult GetTimeZones()
        {
            var timeZones = TimeZoneInfo.GetSystemTimeZones()
                .Select(tz => new
                {
                    id = tz.Id,
                    displayName = tz.DisplayName,
                })
                .ToList();

            return Ok(timeZones);
        }
    }
}
