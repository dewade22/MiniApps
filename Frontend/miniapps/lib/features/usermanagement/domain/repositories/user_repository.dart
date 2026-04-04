import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> createUser({required String name, required String email, required String password, required String role});
  Future<void> updateUser({required String id, required String name, required String email, required String role});
  Future<void> deleteUser(String id);
}