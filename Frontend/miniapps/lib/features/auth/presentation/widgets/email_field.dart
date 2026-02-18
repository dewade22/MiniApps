import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return TextField(
      onChanged: provider.setEmail,
      decoration: InputDecoration(
        labelText: "Email",
        border: const OutlineInputBorder(),
        errorText: provider.emailError,
      ),
    );
  }
}