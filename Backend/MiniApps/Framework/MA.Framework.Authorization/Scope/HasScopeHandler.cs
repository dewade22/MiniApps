#nullable disable

using Microsoft.AspNetCore.Authorization;

namespace MA.Framework.Authorization.Scope
{
    public class HasScopeHandler : AuthorizationHandler<HasScopeRequirement>
    {
        protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, HasScopeRequirement requirement)
        {
            if (!context.User.HasClaim(c => requirement.Issuers.Contains(c.Issuer)))
            {
                return Task.CompletedTask;
            }

            var scopes = new List<string>();

            // split scope string into list
            if (context.User.HasClaim(c => c.Type == "scope" && requirement.Issuers.Contains(c.Issuer)))
            {
                scopes = context.User.FindFirst(c => c.Type == "scope" && requirement.Issuers.Contains(c.Issuer)).Value.Split(' ').ToList();
            }

            // use if in token has permission per user
            if (context.User.HasClaim(c => c.Type == "permissions" && requirement.Issuers.Contains(c.Issuer)))
            {
                scopes.AddRange(context.User.Claims.Where(c => c.Type == "permissions" && requirement.Issuers.Contains(c.Issuer)).Select(c => c.Value));
            }
            // succeed if the scope array contain the required scope
            if (scopes.Any(s => s == requirement.Scope))
            {
                context.Succeed(requirement);
            }

            return Task.CompletedTask;
        }
    }
}
