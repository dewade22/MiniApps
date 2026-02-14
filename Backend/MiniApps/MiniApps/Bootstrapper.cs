using MiniApps.Repository;
using MiniApps.RepositoryInterface;
using MiniApps.Service;
using MiniApps.ServiceInterface;

namespace MiniApps
{
    public class Bootstrapper
    {
        public static void SetupRepositories(IServiceCollection services)
        {
            services.AddTransient<IJwtTokenManagerRepository, JwtTokenManagerRepository>();
            services.AddTransient<IRoleRepository, RoleRepository>();
            services.AddTransient<IUserAccountRepository, UserAccountRepository>();
            services.AddTransient<IUserInRoleRepository, UserInRoleRepository>();
            services.AddTransient<IUserMembershipRepository, UserMembershipRepository>();
            services.AddTransient<IUserRefreshTokenRepository, UserRefreshTokenRepository>();
        }

        public static void SetupServices(IServiceCollection services)
        {
            services.AddScoped<IRoleService, RoleService>();
            services.AddScoped<IUserAccountService, UserAccountService>();
            services.AddScoped<IUserInRoleService, UserInRoleService>();
            services.AddScoped<IUserMembershipService, UserMembershipService>();
            services.AddScoped<IUserRefreshTokenService, UserRefreshTokenService>();
        }
    }
}
