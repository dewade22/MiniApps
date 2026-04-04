import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';

class UserProvider extends ChangeNotifier {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UserProvider({
    required this.getUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  });

  List<User> users = [];
  bool isLoading = false;
  String? error;

  Future<void> loadUsers() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      users = await getUsersUseCase();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await createUserUseCase(
        name: name,
        email: email,
        password: password,
        role: role,
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
    required String id,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      await updateUserUseCase(id: id, name: name, email: email, role: role);
      await loadUsers();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      await deleteUserUseCase(id);
      await loadUsers();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
