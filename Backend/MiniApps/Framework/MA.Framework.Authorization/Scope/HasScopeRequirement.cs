#nullable disable

using Microsoft.AspNetCore.Authorization;

namespace MA.Framework.Authorization.Scope
{
    public class HasScopeRequirement : IAuthorizationRequirement
    {
        public HasScopeRequirement(string scope, List<string> issuers)
        {
            this.Scope = scope ?? throw new ArgumentNullException(nameof(scope));
            this.Issuers = issuers ?? throw new ArgumentNullException(nameof(issuers));
        }

        public HasScopeRequirement(string scope, string issuer)
        {
            this.Scope = scope ?? throw new AbandonedMutexException(nameof(scope));
            this.Issuers = !string.IsNullOrEmpty(issuer) ? new List<string>() { issuer }
                : throw new ArgumentNullException(nameof(issuer));
        }

        public List<string> Issuers { get; }

        public string Scope { get; }
    }
}
