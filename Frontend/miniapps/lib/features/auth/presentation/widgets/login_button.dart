import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/navigation/app_router.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: provider.isValid && !provider.isLoading
            ? () async {
              bool success = await provider.login();
              if (success && context.mounted) {
                final role = await SessionService().getUserRole();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => appRouter(role)),
                  );
                }
            }
            : null,
        child: provider.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text("Login"),
      ),
    );
  }
}