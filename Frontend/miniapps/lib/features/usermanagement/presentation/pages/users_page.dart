import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/models/role_model.dart';
import '../../data/models/timezone_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/assign_role_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = UserRemoteDataSource();
    final repo = UserRepositoryImpl(dataSource);
    return ChangeNotifierProvider(
      create: (_) => UserProvider(
        getUsersUseCase: GetUsersUseCase(repo),
        createUserUseCase: CreateUserUseCase(repo),
        updateUserUseCase: UpdateUserUseCase(repo),
        assignRoleUseCase: AssignRoleUseCase(repo),
        deleteUserUseCase: DeleteUserUseCase(repo),
        dataSource: dataSource,
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
    final isSelf = provider.currentUserUuid != null &&
        provider.currentUserUuid == user.uuid;
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?'),
      ),
      title: Text(user.fullName),
      subtitle: Text(user.emailAddress),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(label: Text(user.roleName.isNotEmpty ? user.roleName : 'No Role')),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.manage_accounts, color: Colors.orange),
            tooltip: 'Assign Role',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _AssignRoleDialog(provider: provider, user: user),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: 'Edit User',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _UserFormDialog(
                provider: provider,
                user: user,
              ),
            ),
          ),
          if (!isSelf)
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
        content: Text('Delete "${user.fullName}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.deleteUser(user.uuid);
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
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  RoleModel? _selectedRole;
  TimeZoneModel? _selectedTimeZone;
  bool _isSaving = false;

  bool get _isEdit => widget.user != null;

  List<RoleModel> get _roles => widget.provider.roles;
  List<TimeZoneModel> get _timeZones => widget.provider.timeZones;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: widget.user?.lastName ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.emailAddress ?? '');
    _passwordCtrl = TextEditingController();

    if (_isEdit && widget.user!.timeZoneId.isNotEmpty) {
      _selectedTimeZone = _timeZones.where((tz) => tz.id == widget.user!.timeZoneId).firstOrNull;
    }
    _selectedTimeZone ??= _timeZones.where((tz) => tz.id == 'UTC').firstOrNull
        ?? (_timeZones.isNotEmpty ? _timeZones.first : null);

    if (!_isEdit) {
      _selectedRole = _roles.isNotEmpty ? _roles.first : null;
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
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
                controller: _firstNameCtrl,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'First name is required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameCtrl,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Last name is required' : null,
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
              if (_timeZones.isEmpty)
                const Text('Loading time zones...', style: TextStyle(color: Colors.grey))
              else
                DropdownButtonFormField<TimeZoneModel>(
                  value: _selectedTimeZone,
                  decoration: const InputDecoration(labelText: 'Time Zone'),
                  isExpanded: true,
                  items: _timeZones
                      .map((tz) => DropdownMenuItem(
                            value: tz,
                            child: Text(tz.displayName, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTimeZone = v),
                  validator: (v) => v == null ? 'Time zone is required' : null,
                ),
              if (!_isEdit) ...[
                const SizedBox(height: 8),
                if (_roles.isEmpty)
                  const Text('Loading roles...', style: TextStyle(color: Colors.grey))
                else
                  DropdownButtonFormField<RoleModel>(
                    value: _selectedRole,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: _roles
                        .map((r) => DropdownMenuItem(value: r, child: Text(r.roleName)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedRole = v),
                    validator: (v) => v == null ? 'Role is required' : null,
                  ),
              ],
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
        uuid: widget.user!.uuid,
        emailAddress: _emailCtrl.text.trim(),
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        timeZoneId: _selectedTimeZone!.id,
      );
    } else {
      ok = await widget.provider.createUser(
        emailAddress: _emailCtrl.text.trim(),
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        timeZoneId: _selectedTimeZone!.id,
        password: _passwordCtrl.text,
        roleUuid: _selectedRole!.uuid,
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

class _AssignRoleDialog extends StatefulWidget {
  final UserProvider provider;
  final User user;

  const _AssignRoleDialog({required this.provider, required this.user});

  @override
  State<_AssignRoleDialog> createState() => _AssignRoleDialogState();
}

class _AssignRoleDialogState extends State<_AssignRoleDialog> {
  RoleModel? _selectedRole;
  bool _isSaving = false;

  List<RoleModel> get _roles => widget.provider.roles;

  @override
  void initState() {
    super.initState();
    _selectedRole = _roles
        .where((r) => r.roleName == widget.user.roleName)
        .firstOrNull ?? (_roles.isNotEmpty ? _roles.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign Role — ${widget.user.fullName}'),
      content: _roles.isEmpty
          ? const Text('No roles available.', style: TextStyle(color: Colors.grey))
          : DropdownButtonFormField<RoleModel>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items: _roles
                  .map((r) => DropdownMenuItem(value: r, child: Text(r.roleName)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedRole = v),
            ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (_isSaving || _selectedRole == null) ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Assign'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);

    final ok = await widget.provider.assignRole(
      emailAddress: widget.user.emailAddress,
      roleUuid: _selectedRole!.uuid,
    );

    setState(() => _isSaving = false);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Role assigned' : widget.provider.error ?? 'Failed'),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
    }
  }
}
