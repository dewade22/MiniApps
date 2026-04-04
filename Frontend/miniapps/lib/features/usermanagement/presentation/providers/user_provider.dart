import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/models/role_model.dart';

class UserProvider extends ChangeNotifier {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final UserRemoteDataSource _dataSource;

  UserProvider({
    required this.getUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required UserRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  List<User> users = [];
  List<RoleModel> roles = [];
  bool isLoading = false;
  String? error;

  Future<void> loadUsers() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final results = await Future.wait([
        getUsersUseCase(),
        _dataSource.getRoles(),
      ]);
      users = results[0] as List<User>;
      roles = results[1] as List<RoleModel>;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser({
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
    required String password,
    required String roleUuid,
  }) async {
    try {
      await createUserUseCase(
        emailAddress: emailAddress,
        firstName: firstName,
        lastName: lastName,
        timeZoneId: timeZoneId,
        password: password,
        roleUuid: roleUuid,
      );
      await loadUsers();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser({
    required String uuid,
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
    required String roleUuid,
  }) async {
    try {
      await updateUserUseCase(
        uuid: uuid,
        emailAddress: emailAddress,
        firstName: firstName,
        lastName: lastName,
        timeZoneId: timeZoneId,
        roleUuid: roleUuid,
      );
      await loadUsers();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String uuid) async {
    try {
      await deleteUserUseCase(uuid);
      await loadUsers();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
