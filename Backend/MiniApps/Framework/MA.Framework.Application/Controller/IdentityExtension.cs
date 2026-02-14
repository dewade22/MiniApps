using MA.Framework.Core.Constant;
using System.Security.Claims;
using System.Security.Principal;

namespace MA.Framework.Application.Controller
{
    public static class IdentityExtension
    {
        public static List<string> GetRole(this IIdentity identity)
        {
            var claim = ((ClaimsIdentity)identity).FindFirst(ClaimConstant.Role);
            return (claim != null) ? claim.Value.Split(",").ToList() : new List<string>();
        }
    }
}
