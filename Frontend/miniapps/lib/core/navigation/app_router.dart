import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/admin_home_page.dart';

Widget appRouter(String? role) {
  switch (role) {
    case 'Admin':
      return const AdminHomePage();
    default:
      return const LoginPage();
  }
}