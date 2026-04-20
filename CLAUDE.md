# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Layout

```
E:\C#\MiniApp\
├── Backend\MiniApps\          # .NET 8 Web API (solution root)
│   ├── MiniApps\              # Main API project
│   ├── DataAccess\
│   │   └── DatabaseUpgradeScript\   # DbUp migration runner
│   └── Framework\             # Shared internal libraries (MA.Framework.*)
└── Frontend\miniapps\         # Flutter application
```

---

## Backend (.NET 8 Web API)

### Run / Build

```bash
# From Backend\MiniApps\
dotnet run --project MiniApps/MiniApps.csproj
# Default port: 5220 (http://localhost:5220)
# Swagger UI: http://localhost:5220/api-docs

dotnet build MiniApps.sln
```

### Database Migrations (DbUp)

```bash
# From Backend\MiniApps\DataAccess\DatabaseUpgradeScript\
dotnet run   # uses dbup.appsetting.local.json by default
```

- Scripts are **embedded resources** — every new `.sql` file must be registered in `DatabaseUpgradeScript.csproj` as `<EmbeddedResource>`.
- Execution order is **alphabetical by full embedded resource path**, so name scripts `Script001`, `Script002`, … within each folder.
- DbUp records applied scripts; re-running is safe (skips already-applied scripts).
- Connection strings live in `dbup.appsetting.local.json` (local) / `dbup.appsetting.development.json` (dev). The main API reads `appsettings.json` or `appsettings.Local.json`.

### Architecture

The backend follows a strict layered pattern. Every new domain entity requires touching these layers in order:

| Layer | Location | Base class / interface |
|---|---|---|
| Entity (EF model) | `MiniApps/DataAccess/Application/` | plain `partial class` |
| DbContext | `MiniApps/DataAccess/Application/ApplicationContext.cs` | Add `DbSet<>` + Fluent API config in `OnModelCreating` |
| DTO | `MiniApps/Dto/<Domain>/` | extends `AuditableDto<string>` |
| AutoMapper | `MiniApps/DataAccess/AutoMapperProfile.cs` | `CreateMap<Entity, Dto>().ReverseMap()` |
| Repository interface | `MiniApps/RepositoryInterface/<Domain>/` | extends `IBaseRepository<TDto>` |
| Repository impl | `MiniApps/Repository/<Domain>/` | extends `BaseRepository<ApplicationContext, TEntity, TDto, string>` |
| Service interface | `MiniApps/ServiceInterface/<Domain>/` | extends `IBaseService<TDto, string>` |
| Service impl | `MiniApps/Service/<Domain>/` | extends `BaseService<TDto, string, IRepo>` |
| Request model | `MiniApps/Model/Request/<Domain>/` | plain class with DataAnnotations |
| Controller | `MiniApps/Controllers/<Domain>/` | extends `BaseController` |
| DI registration | `MiniApps/Bootstrapper.cs` | `AddTransient` (repos) / `AddScoped` (services) |
| UUID constant | `Framework/MA.Framework.Core/Constant/UidTableConstant.cs` | `public const string Name = "prefix"` |

**Key framework types:**
- `AuditableDto<T>` has `CreatedBy`, `CreatedAt`, `UpdatedBy`, `UpdatedAt` (PascalCase). EF entities use lowercase `Createdby`, `Createdat`, etc. — never mix them.
- `BaseController.GenerateUuid(UidTableConstant.X)` generates prefixed UUIDs.
- `BaseController.PopulateCreatedFields(dto)` / `PopulatedUpdatedFields(dto)` fill audit fields from the current JWT user.
- `EntityToDto` uses AutoMapper only. `EntityToDtoWithRelation` must be overridden manually when navigation properties (e.g. collections) need custom mapping.
- Responses: `GenericResponse<T>` (single), `GenericCollectionResponse<T>` (list). Check `response.IsError()` before using `.Data` / `.DtoCollection`.

**Authorization policies** (defined in `Policy.cs` and wired in `Startup.cs`):
- `Policy.AllRoles` — Admin, Teacher, Student (read endpoints)
- `Policy.Administrator` — Admin only (write endpoints)

**JWT claims:**
- `ClaimTypes.Name` → email address
- `ClaimTypes.Role` → role name (e.g. `"Admin"`)
- `"http://ticketingapp.info/useraccount/uuid"` → user UUID

### Adding a New Migration Script

1. Create the `.sql` file in `DataAccess/DatabaseUpgradeScript/<Domain>/<Folder>/Script00N - Description.sql`
2. Register it in `DatabaseUpgradeScript.csproj`:
   ```xml
   <EmbeddedResource Include="<Domain>\<Folder>\Script00N - Description.sql" />
   ```
3. Run `dotnet run` from the `DatabaseUpgradeScript` project folder.

---

## Frontend (Flutter)

### Run / Build

```bash
# From Frontend\miniapps\
flutter pub get
flutter run                      # default device
flutter run -d chrome            # web
flutter build apk                # Android release
```

### Configuration

API base URL is set in `Frontend/miniapps/.env`:
```
API_BASE_URL=http://localhost:5220
```
The `.env` file is declared as a Flutter asset in `pubspec.yaml` and loaded via `flutter_dotenv` at startup.

### Architecture

Flutter follows **Clean Architecture** with Provider state management. Every feature lives under `lib/features/<feature>/` and has the same structure:

```
features/<feature>/
├── domain/
│   ├── entities/          # Plain Dart classes (no JSON logic)
│   ├── repositories/      # Abstract repository interfaces
│   └── usecases/          # One class per operation, calls repository
├── data/
│   ├── models/            # Extend entities, add fromJson factory
│   ├── datasources/       # Dio HTTP calls (throws Exception on error)
│   └── repositories/      # Implement domain repository, delegate to datasource
└── presentation/
    ├── providers/          # ChangeNotifier, holds state + calls use cases
    └── pages/              # Scaffold + Consumer<Provider>, inline widgets
```

**Key conventions:**
- Pages self-wire their own dependencies: each `Page` widget creates its own `DataSource`, `RepositoryImpl`, `UseCase`s, and wraps with `ChangeNotifierProvider` (no global DI container).
- Error messages from the API are in `e.response?.data?['errorMessages']?[0]`.
- `ApiClient` (singleton `Dio` instance) auto-attaches the Bearer token from `SharedPreferences` on every request and transparently retries with a refreshed token on HTTP 401.
- `SessionService` reads JWT claims via `jwt_decode`: role at `payload['role']`, user UUID at `payload['http://ticketingapp.info/useraccount/uuid']`.
- Route guards live in `lib/core/navigation/app_router.dart` — role `"Admin"` → `AdminHomePage`, anything else → `LoginPage`.

**Current features:**
- `auth` — login, token refresh
- `usermanagement` — CRUD users, assign roles, timezone dropdown
- `academic` — Grades, Subjects, Topics, Questions (per-topic question bank)
- `home` — `AdminHomePage` grid menu

**Adding a new feature** checklist:
1. Entity → Model (`fromJson`) → DataSource method → Repository impl → Use case(s) → Provider → Page
2. Add API calls to the relevant `*_remote_datasource.dart` (one datasource per feature domain).
3. Register the page in `AdminHomePage` menu list if it needs a top-level entry point.

### State Pattern

Providers always follow this shape:
```dart
Future<void> load() async {
  _isLoading = true; _error = null; notifyListeners();
  try { _items = await useCase(); }
  catch (e) { _error = e.toString().replaceFirst('Exception: ', ''); }
  finally { _isLoading = false; notifyListeners(); }
}

Future<bool> create(...) async {
  // on success: await load(); return true;
  // on error:   _error = ...; notifyListeners(); return false;
}
```

Pages check `provider.isLoading`, then `provider.error`, then render data. Mutations show a `SnackBar` based on the `bool` return value.
