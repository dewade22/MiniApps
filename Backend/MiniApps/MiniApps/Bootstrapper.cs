using MiniApps.Repository.Academic;
using MiniApps.Repository.Common;
using MiniApps.RepositoryInterface.Academic;
using MiniApps.RepositoryInterface.Common;
using MiniApps.Service.Academic;
using MiniApps.Service.Common;
using MiniApps.ServiceInterface.Academic;
using MiniApps.ServiceInterface.Common;

namespace MiniApps
{
    public class Bootstrapper
    {
        public static void SetupRepositories(IServiceCollection services)
        {
            services.AddTransient<IGradeRepository, GradeRepository>();
            services.AddTransient<IJwtTokenManagerRepository, JwtTokenManagerRepository>();
            services.AddTransient<IRoleRepository, RoleRepository>();
            services.AddTransient<IUserAccountRepository, UserAccountRepository>();
            services.AddTransient<IUserInRoleRepository, UserInRoleRepository>();
            services.AddTransient<IUserMembershipRepository, UserMembershipRepository>();
            services.AddTransient<IUserRefreshTokenRepository, UserRefreshTokenRepository>();
        }

        public static void SetupServices(IServiceCollection services)
        {
            services.AddScoped<IGradeService, GradeService>();
            services.AddScoped<IRoleService, RoleService>();
            services.AddScoped<IUserAccountService, UserAccountService>();
            services.AddScoped<IUserInRoleService, UserInRoleService>();
            services.AddScoped<IUserMembershipService, UserMembershipService>();
            services.AddScoped<IUserRefreshTokenService, UserRefreshTokenService>();
        }
    }
}
