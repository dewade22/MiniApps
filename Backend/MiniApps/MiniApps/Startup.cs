#nullable disable

using MA.Framework.Application.Infrastructure.ApiVersionning;
using MA.Framework.Application.Model;
using MA.Framework.Authorization;
using MA.Framework.Authorization.Scope;
using MA.Framework.Core.Constant;
using MA.Framework.Core.Resource;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ApiExplorer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using MiniApps.DataAccess;
using MiniApps.Infrastructure.Swagger;
using Newtonsoft.Json;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Collections.ObjectModel;
using System.Text;

namespace MiniApps
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            this.Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services.AddApiVersioning(v =>
            {
                v.DefaultApiVersion = new ApiVersion(1, 0);
                v.AssumeDefaultVersionWhenUnspecified = true;
                v.ErrorResponses = new ApiVersioningErrorResponseProvider();
            });

            services.AddVersionedApiExplorer(setup =>
            {
                setup.GroupNameFormat = "'v'VVV";
                setup.SubstituteApiVersionInUrl = true;
            });

            services.AddTransient<IConfigureOptions<SwaggerGenOptions>, ConfigureSwaggerOptions>();

            services.AddSwaggerGen(options =>
            {
                options.OperationFilter<SwaggerDefaultValue>();
                var securitySchema = new OpenApiSecurityScheme
                {
                    Description = "Using the Authorization header with the Bearer schema.",
                    Name = "Authorization",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.Http,
                    Scheme = "bearer",
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme,
                        Id = "bearer",
                    },
                };

                options.AddSecurityDefinition("bearer", securitySchema);

                options.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {securitySchema, new[] { "bearer" } },
                });
            });

            // Add Authentication Schema Here
            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer("LocalIdentity", options =>
            {
                var key = Encoding.UTF8.GetBytes(this.Configuration["JWT:Key"]);

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidIssuer = this.Configuration["JWT:Issuer"],
                    ValidAudience = this.Configuration["JWT:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ClockSkew = TimeSpan.Zero
                };

                options.Events = new JwtBearerEvents
                {
                    OnChallenge = context =>
                    {
                        context.HandleResponse();

                        if (string.IsNullOrEmpty(context.Error))
                        {
                            return this.BuildAuthErrorResponse(context.Response, 401, GeneralResource.General_TokenIsRequired);
                        }

                        return this.BuildAuthErrorResponse(context.Response, 401, GeneralResource.General_TokenInvalid);
                    },
                    OnForbidden = context =>
                    {
                        return this.BuildAuthErrorResponse(context.Response, 403, GeneralResource.General_NoAuthorizedAPI);
                    }
                };
            });

            // Add Authorization service Here
            services.AddAuthorization(options =>
            {
                options.DefaultPolicy = new AuthorizationPolicyBuilder()
                    .RequireAuthenticatedUser()
                    .AddAuthenticationSchemes("LocalIdentity")
                    .Build();

                options.AddPolicy(Policy.AllRoles, new AuthorizationPolicyBuilder()
                    .RequireAuthenticatedUser()
                    .AddAuthenticationSchemes("LocalIdentity")
                    .RequireClaim(
                        "http://schemas.microsoft.com/ws/2008/06/identity/claims/role",
                        new List<string>()
                        {
                            Policy.Administrator
                        })
                    .Build());

                options.AddPolicy(Policy.Administrator, new AuthorizationPolicyBuilder()
                    .RequireAuthenticatedUser()
                    .AddAuthenticationSchemes("LocalIdentity")
                    .RequireClaim(
                        "http://schemas.microsoft.com/ws/2008/06/identity/claims/role",
                        new List<string>()
                        {
                            Policy.Administrator,
                        })
                    .Build());
            });

            services.AddSingleton<IAuthorizationHandler, HasScopeHandler>();
            services.Configure<InternalJwtConfig>(this.Configuration.GetSection(InternalJwtConfig.jwt));


            //services.AddDbContext<ApplicationContext>(options =>
            //    options.UseSqlServer(this.Configuration.GetConnectionString("DefaultConnection")));
            services.AddAutoMapper(typeof(AutoMapperProfile));

            // Add DI here
            Bootstrapper.SetupRepositories(services);
            Bootstrapper.SetupServices(services);
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IApiVersionDescriptionProvider provider)
        {
            if (!env.IsProduction())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger(option => { option.RouteTemplate = "api-docs/{documentName}/docs.json"; });
                app.UseSwaggerUI(options =>
                {
                    options.RoutePrefix = "api-docs";
                    foreach (var description in provider.ApiVersionDescriptions)
                    {
                        options.SwaggerEndpoint($"/api-docs/{description.GroupName}/docs.json", description.GroupName.ToUpperInvariant());
                    }
                });

                app.UseCors("AllowOrigin");
            }

            app.UseExceptionHandler("/error");
            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }

        private Task BuildAuthErrorResponse(HttpResponse response, int statusCode, string errorMessage)
        {
            var errorMessages = new Collection<string>();
            errorMessages.Add(errorMessage);

            var responseObj = new ApiErrorModel
            {
                ErrorMessages = errorMessages.ToArray(),
            };

            response.ContentType = "application/json";
            response.StatusCode = statusCode;

            return response.WriteAsync(JsonConvert.SerializeObject(responseObj).ToString());
        }
    }
}
