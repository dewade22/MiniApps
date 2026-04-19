import '../repositories/user_repository.dart';

class AssignRoleUseCase {
  final UserRepository repository;

  AssignRoleUseCase(this.repository);

  Future<void> call({
    required String emailAddress,
    required String roleUuid,
  }) {
    return repository.assignRole(
      emailAddress: emailAddress,
      roleUuid: roleUuid,
    );
  }
}
