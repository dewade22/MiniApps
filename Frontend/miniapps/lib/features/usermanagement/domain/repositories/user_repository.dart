import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> createUser({
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
    required String password,
    required String roleUuid,
  });
  Future<void> updateUser({
    required String uuid,
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
  });
  Future<void> assignRole({
    required String emailAddress,
    required String roleUuid,
  });
  Future<void> deleteUser(String uuid);
}
