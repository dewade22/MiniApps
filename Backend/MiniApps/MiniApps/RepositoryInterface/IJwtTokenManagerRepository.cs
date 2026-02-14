using MiniApps.Model.Authentication;
using MiniApps.Model.Request;
using System.Security.Claims;

namespace MiniApps.RepositoryInterface
{
    public interface IJwtTokenManagerRepository
    {
        Token GenerateToken(TokenRequest model);

        Token GenerateRefreshToken(TokenRequest model);

        ClaimsPrincipal GetPrincipalFromExpiredToken(string token);
    }
}
