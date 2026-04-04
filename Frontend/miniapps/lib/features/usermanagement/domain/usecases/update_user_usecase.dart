import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call({
    required String id,
    required String name,
    required String email,
    required String role,
  }) {
    return repository.updateUser(id: id, name: name, email: email, role: role);
  }
}
