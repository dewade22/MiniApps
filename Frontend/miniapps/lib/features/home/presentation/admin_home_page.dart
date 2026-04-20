import 'package:flutter/material.dart';
import '../../../features/usermanagement/presentation/pages/users_page.dart';
import '../../../features/academic/presentation/pages/grades_page.dart';
import '../../../features/academic/presentation/pages/subjects_page.dart';
import '../../../features/academic/presentation/pages/topics_page.dart';
import '../../../features/academic/presentation/pages/question_bank_page.dart';
import '../../../features/academic/presentation/pages/quiz_builder_page.dart';
import '../../../features/academic/presentation/pages/schools_page.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../core/services/session_service.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  static const _adminMenus = [
    _MenuItem(title: 'Manage Users',  icon: Icons.people,             adminOnly: true),
    _MenuItem(title: 'Schools',       icon: Icons.account_balance,    adminOnly: true),
    _MenuItem(title: 'Grades',        icon: Icons.school),
    _MenuItem(title: 'Subjects',      icon: Icons.book),
    _MenuItem(title: 'Topics',        icon: Icons.topic),
    _MenuItem(title: 'Question Bank', icon: Icons.quiz),
    _MenuItem(title: 'Quiz Builder',  icon: Icons.build_circle),
  ];

  static Widget _pageFor(String title) {
    switch (title) {
      case 'Manage Users':  return const ManageUsersPage();
      case 'Schools':       return const SchoolsPage();
      case 'Grades':        return const GradesPage();
      case 'Subjects':      return const SubjectsPage();
      case 'Topics':        return const TopicsPage();
      case 'Question Bank': return const QuestionBankPage();
      case 'Quiz Builder':  return const QuizBuilderPage();
      default:              return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
      body: FutureBuilder<String?>(
        future: SessionService().getUserRole(),
        builder: (context, snapshot) {
          final role = snapshot.data?.toLowerCase() ?? '';
          final isAdmin = role == 'admin';
          final visibleMenus = _adminMenus
              .where((m) => !m.adminOnly || isAdmin)
              .toList();

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1,
            ),
            itemCount: visibleMenus.length,
            itemBuilder: (context, index) {
              final menu = visibleMenus[index];
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _pageFor(menu.title)),
                ),
                borderRadius: BorderRadius.circular(15),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(menu.icon, size: 50,
                          color: Theme.of(context).primaryColor),
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
          );
        },
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final bool adminOnly;

  const _MenuItem({
    required this.title,
    required this.icon,
    this.adminOnly = false,
  });
}