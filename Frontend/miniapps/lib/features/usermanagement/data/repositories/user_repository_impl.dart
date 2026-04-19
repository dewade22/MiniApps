import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<User>> getUsers() {
    return remoteDataSource.getUsers();
  }

  @override
  Future<void> createUser({
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
    required String password,
    required String roleUuid,
  }) {
    return remoteDataSource.createUser(
      emailAddress: emailAddress,
      firstName: firstName,
      lastName: lastName,
      timeZoneId: timeZoneId,
      password: password,
      roleUuid: roleUuid,
    );
  }

  @override
  Future<void> updateUser({
    required String uuid,
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
  }) {
    return remoteDataSource.updateUser(
      uuid: uuid,
      emailAddress: emailAddress,
      firstName: firstName,
      lastName: lastName,
      timeZoneId: timeZoneId,
    );
  }

  @override
  Future<void> assignRole({
    required String emailAddress,
    required String roleUuid,
  }) {
    return remoteDataSource.assignRole(
      emailAddress: emailAddress,
      roleUuid: roleUuid,
    );
  }

  @override
  Future<void> deleteUser(String uuid) {
    return remoteDataSource.deleteUser(uuid);
  }
}
