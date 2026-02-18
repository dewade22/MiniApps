import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}
class _PasswordFieldState extends State<PasswordField> {
    bool obscure = true;

    @override
    Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return TextField(
      obscureText: obscure,
      onChanged: provider.setPassword,
      decoration: InputDecoration(
        labelText: "Password",
        border: const OutlineInputBorder(),
        errorText: provider.passwordError,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() => obscure = !obscure);
          },
        ),
      ),
    );
  }
}