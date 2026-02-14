using DbUp;
using Microsoft.Extensions.Configuration;
using System.Reflection;

namespace DatabaseUpgradeScript
{
    class Program
    {
        static int Main(string[] args)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory());

#if DEVELOPMENT
            builder.AddJsonFile("dbup.appsetting.development.json", optional: true, reloadOnChange:true);
#else
            builder.AddJsonFile("dbup.appsetting.local.json", optional: true, reloadOnChange: true);
#endif
            IConfigurationRoot configuration = builder.Build();
            var connectionString = configuration.GetConnectionString("DefaultConnection");

            var connectionInfo = connectionString.Split(';');

            foreach (var info in connectionInfo)
            {
                switch (info.Split('=')[0])
                {
                    case "server":
                        Console.WriteLine("Data Source : " + info.Split('=')[1]);
                        break;
                    case "database":
                        Console.WriteLine("DB Name : " + info.Split('=')[1]);
                        break;
                    default:
                        break;
                }
            }

            Console.WriteLine("================================================================================================");

            var upgrader = DeployChanges.To
                .PostgresqlDatabase(connectionString)
                .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
                .WithTransaction()
                .LogToConsole()
                .Build();

            var result = upgrader.PerformUpgrade();

            if (!result.Successful)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(result.Error);
                Console.ResetColor();
                Console.ReadLine();
                return -1;
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Success!");
            Console.ResetColor();
#if DEBUG
            Console.ReadLine();
#endif
            return 0;
        }
    }
}