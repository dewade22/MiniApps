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
            services.AddTransient<IUserAccountRepository, UserAccountRepository>();
        }

        public static void SetupServices(IServiceCollection services)
        {
            services.AddScoped<IUserAccountService, UserAccountService>();
        }
    }
}
