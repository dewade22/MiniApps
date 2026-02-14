# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["MiniApps/MiniApps.csproj", "MiniApps/"]
COPY ["Framework/MA.Framework.Application/MA.Framework.Application.csproj", "Framework/MA.Framework.Application/"]
COPY ["Framework/MA.Framework.Dto/MA.Framework.Dto.csproj", "Framework/MA.Framework.Dto/"]
COPY ["Framework/MA.Framework.ServiceInterface/MA.Framework.ServiceInterface.csproj", "Framework/MA.Framework.ServiceInterface/"]
COPY ["Framework/MA.Framework.Core/MA.Framework.Core.csproj", "Framework/MA.Framework.Core/"]
COPY ["Framework/MA.Framework.Authorization/MA.Framework.Authorization.csproj", "Framework/MA.Framework.Authorization/"]
COPY ["Framework/MA.Framework.RepositoryInterface/MA.Framework.RepositoryInterface.csproj", "Framework/MA.Framework.RepositoryInterface/"]
COPY ["Framework/MA.Framework.Repository/MA.Framework.Repository.csproj", "Framework/MA.Framework.Repository/"]
COPY ["Framework/MA.Framework.Service/MA.Framework.Service.csproj", "Framework/MA.Framework.Service/"]
RUN dotnet restore "./MiniApps/MiniApps.csproj"
COPY . .
WORKDIR "/src/MiniApps"
RUN dotnet build "./MiniApps.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./MiniApps.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MiniApps.dll"]