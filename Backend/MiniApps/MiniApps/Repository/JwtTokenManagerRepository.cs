using MA.Framework.Core.Constant;
using Microsoft.IdentityModel.Tokens;
using MiniApps.Model.Authentication;
using MiniApps.Model.Request;
using MiniApps.RepositoryInterface;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace MiniApps.Repository
{
    public class JwtTokenManagerRepository : IJwtTokenManagerRepository
    {
        private readonly IConfiguration _configuration;

        public JwtTokenManagerRepository(IConfiguration configuration)
        {
            this._configuration = configuration;
        }

        public Token GenerateRefreshToken(TokenRequest model)
        {
            return this.GenerateJwtTokens(model);
        }

        public Token GenerateToken(TokenRequest model)
        {
            return this.GenerateJwtTokens(model);
        }

        public Token GenerateJwtTokens(TokenRequest model)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var tokenKey = Encoding.UTF8.GetBytes(this._configuration["JWT:Key"]);
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new Claim[]
                    {
                         new Claim(ClaimTypes.Name, model.EmailAddress),
                         new Claim(ClaimTypes.Role, model.Role),
                         new Claim(ClaimTypes.NameIdentifier, CoreConstant.NameIdentifier),
                         new Claim(ClaimConstant.Uuid, model.UserUuid),
                         new Claim("scope", "read,write")
                    }),

                    Audience = this._configuration["JWT:Audience"],
                    Issuer = this._configuration["JWT:Issuer"],
                    Expires = DateTime.UtcNow.AddMinutes(15),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(tokenKey), SecurityAlgorithms.HmacSha256Signature)
                };

                var token = tokenHandler.CreateToken(tokenDescriptor);
                var refreshToken = this.GenerateRefreshToken();

                return new Token
                {
                    AccessToken = tokenHandler.WriteToken(token),
                    RefreshToken = refreshToken,
                };
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GenerateRefreshToken()
        {
            var randomNumber = new byte[32];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
                return Convert.ToBase64String(randomNumber);
            }
        }

        public ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
        {
            var Key = Encoding.UTF8.GetBytes(this._configuration["JWT:Key"]);

            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = false,
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(Key),
                ClockSkew = TimeSpan.Zero
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out SecurityToken securityToken);
            JwtSecurityToken jwtSecurityToken = securityToken as JwtSecurityToken;
            if (jwtSecurityToken == null || !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
            {
                throw new SecurityTokenException("Invalid token");
            }

            return principal;
        }
    }
}
