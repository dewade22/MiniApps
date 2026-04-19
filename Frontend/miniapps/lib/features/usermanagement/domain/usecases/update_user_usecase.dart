import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call({
    required String uuid,
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
  }) {
    return repository.updateUser(
      uuid: uuid,
      emailAddress: emailAddress,
      firstName: firstName,
      lastName: lastName,
      timeZoneId: timeZoneId,
    );
  }
}
