import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/login_button.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/services/session_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(
        LoginUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSource(),
          ),
        ),
      SessionService(),
    ),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;

            return Center(
              child: Container(
                width: width > 600 ? 400 : width * 0.9,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    EmailField(),
                    SizedBox(height: 16),
                    PasswordField(),
                    SizedBox(height: 24),
                    Consumer<LoginProvider>(
                      builder: (context, provider, _) {
                        if (provider.loginError != null) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              provider.loginError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    LoginButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}