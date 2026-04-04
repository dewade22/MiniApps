import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = UserRepositoryImpl(UserRemoteDataSource());
    return ChangeNotifierProvider(
      create: (_) => UserProvider(
        getUsersUseCase: GetUsersUseCase(repo),
        createUserUseCase: CreateUserUseCase(repo),
        updateUserUseCase: UpdateUserUseCase(repo),
        deleteUserUseCase: DeleteUserUseCase(repo),
      )..loadUsers(),
      child: const _ManageUsersView(),
    );
  }
}

class _ManageUsersView extends StatelessWidget {
  const _ManageUsersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: Consumer<UserProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.loadUsers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.users.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return RefreshIndicator(
            onRefresh: provider.loadUsers,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return _UserTile(user: user);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _UserFormDialog(
        provider: context.read<UserProvider>(),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserProvider>();
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?'),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(label: Text(user.role)),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _UserFormDialog(
                provider: provider,
                user: user,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(context, provider, user),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, UserProvider provider, User user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Delete "${user.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.deleteUser(user.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? 'User deleted' : provider.error ?? 'Failed'),
                    backgroundColor: ok ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _UserFormDialog extends StatefulWidget {
  final UserProvider provider;
  final User? user;

  const _UserFormDialog({required this.provider, this.user});

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  String _selectedRole = 'User';
  bool _isSaving = false;

  static const _roles = ['Admin', 'User', 'Manager'];

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
    _passwordCtrl = TextEditingController();
    _selectedRole = _isEdit
        ? (_roles.contains(widget.user!.role) ? widget.user!.role : _roles.first)
        : _roles.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit User' : 'Add User'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              if (!_isEdit) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Min 6 characters' : null,
                ),
              ],
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: _roles
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedRole = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    bool ok;
    if (_isEdit) {
      ok = await widget.provider.updateUser(
        id: widget.user!.id,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        role: _selectedRole,
      );
    } else {
      ok = await widget.provider.createUser(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        role: _selectedRole,
      );
    }

    setState(() => _isSaving = false);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? (_isEdit ? 'User updated' : 'User created')
              : widget.provider.error ?? 'Operation failed'),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
    }
  }
}
