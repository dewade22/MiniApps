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
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    return remoteDataSource.createUser(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }

  @override
  Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    required String role,
  }) {
    return remoteDataSource.updateUser(
      id: id,
      name: name,
      email: email,
      role: role,
    );
  }

  @override
  Future<void> deleteUser(String id) {
    return remoteDataSource.deleteUser(id);
  }
}
