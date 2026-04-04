import '../repositories/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<void> call({
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
    required String password,
    required String roleUuid,
  }) {
    return repository.createUser(
      emailAddress: emailAddress,
      firstName: firstName,
      lastName: lastName,
      timeZoneId: timeZoneId,
      password: password,
      roleUuid: roleUuid,
    );
  }
}
