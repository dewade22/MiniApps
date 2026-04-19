import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/assign_role_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/models/role_model.dart';
import '../../data/models/timezone_model.dart';
import '../../../../core/services/session_service.dart';

class UserProvider extends ChangeNotifier {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final AssignRoleUseCase assignRoleUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final UserRemoteDataSource _dataSource;

  UserProvider({
    required this.getUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.assignRoleUseCase,
    required this.deleteUserUseCase,
    required UserRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  List<User> users = [];
  List<RoleModel> roles = [];
  List<TimeZoneModel> timeZones = [];
  bool isLoading = false;
  String? error;
  String? currentUserUuid;

  Future<void> loadUsers() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final results = await Future.wait([
        getUsersUseCase(),
        _dataSource.getRoles(),
        _dataSource.getTimeZones(),
        SessionService().getCurrentUserUuid(),
      ]);
      users = results[0] as List<User>;
      roles = results[1] as List<RoleModel>;
      timeZones = results[2] as List<TimeZoneModel>;
      currentUserUuid = results[3] as String?;
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
  }) async {
    try {
      await updateUserUseCase(
        uuid: uuid,
        emailAddress: emailAddress,
        firstName: firstName,
        lastName: lastName,
        timeZoneId: timeZoneId,
      );
      await loadUsers();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> assignRole({
    required String emailAddress,
    required String roleUuid,
  }) async {
    try {
      await assignRoleUseCase(
        emailAddress: emailAddress,
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
