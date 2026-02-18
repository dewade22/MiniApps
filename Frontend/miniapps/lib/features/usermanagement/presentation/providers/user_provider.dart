import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';

class UserProvider extends ChangeNotifier {
  final GetUsersUseCase getUsersUseCase;

  UserProvider(this.getUsersUseCase);

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
      error = e.toString().replaceFirst("Exception: ", "");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}