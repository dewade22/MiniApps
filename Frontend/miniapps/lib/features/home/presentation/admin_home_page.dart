import 'package:flutter/material.dart';
import '../../../features/usermanagement/presentation/pages/users_page.dart';
import '../../../features/academic/presentation/pages/grades_page.dart';
import '../../../features/academic/presentation/pages/subjects_page.dart';
import '../../../features/academic/presentation/pages/topics_page.dart';
import '../../../features/academic/presentation/pages/question_bank_page.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../core/services/session_service.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      _MenuItem(title: 'Manage Users', icon: Icons.people, page: const ManageUsersPage()),
      _MenuItem(title: 'Grades', icon: Icons.school, page: const GradesPage()),
      _MenuItem(title: 'Subjects', icon: Icons.book, page: const SubjectsPage()),
      _MenuItem(title: 'Topics', icon: Icons.topic, page: const TopicsPage()),
      _MenuItem(title: 'Question Bank', icon: Icons.quiz, page: const QuestionBankPage()),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await SessionService().clearSession();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => menu.page),
              );
            },
            borderRadius: BorderRadius.circular(15),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    menu.icon,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    menu.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class _MenuItem {
  final String title;
  final IconData icon;
  final Widget page;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}