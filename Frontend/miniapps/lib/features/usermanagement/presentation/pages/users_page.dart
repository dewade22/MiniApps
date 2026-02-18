import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_users_usecase.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(
        GetUsersUseCase(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      )..loadUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Users'),
        ),
        body: Consumer<UserProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }

            if (provider.users.isEmpty) {
              return const _EmptyState();
            }

            return RefreshIndicator(
              onRefresh: provider.loadUsers,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: provider.users.length,
                itemBuilder: (context, index) {
                  final user = provider.users[index];

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Text(user.role),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // future: add user
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No users found'),
    );
  }
}