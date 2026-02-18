import 'package:flutter/material.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../../../core/services/session_service.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SessionService sessionService;

  LoginProvider(this.loginUseCase, this.sessionService);

  String _email = '';
  String _password = '';

  String? emailError;
  String? passwordError;
  String? loginError;

  bool isLoading = false;

  bool get isValid =>
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      emailError == null &&
      passwordError == null;

  void setEmail(String value) {
    _email = value;
    emailError = value.contains('@') ? null : "Email not valid";
    loginError = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    passwordError = value.length >= 6 ? null : "Minimum 6 character length";
    loginError = null;
    notifyListeners();
  }

  Future<bool> login() async {
    try {
      isLoading = true;
      notifyListeners();

      final session = await loginUseCase(_email, _password);

      await sessionService.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      return true;
    }
    catch (e)
    {
      loginError = e.toString().replaceFirst("Exception: ", "");
      return false;
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }
}