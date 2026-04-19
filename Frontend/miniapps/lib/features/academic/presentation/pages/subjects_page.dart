import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subject_provider.dart';
import '../../data/datasources/academic_remote_datasource.dart';
import '../../data/repositories/subject_repository_impl.dart';
import '../../domain/entities/subject.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/create_subject_usecase.dart';
import '../../domain/usecases/update_subject_usecase.dart';
import '../../domain/usecases/delete_subject_usecase.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = AcademicRemoteDataSource();
    final repo = SubjectRepositoryImpl(ds);
    return ChangeNotifierProvider(
      create: (_) => SubjectProvider(
        getSubjectsUseCase: GetSubjectsUseCase(repo),
        createSubjectUseCase: CreateSubjectUseCase(repo),
        updateSubjectUseCase: UpdateSubjectUseCase(repo),
        deleteSubjectUseCase: DeleteSubjectUseCase(repo),
      )..load(),
      child: const _SubjectsView(),
    );
  }
}

class _SubjectsView extends StatelessWidget {
  const _SubjectsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Subjects')),
      body: Consumer<SubjectProvider>(
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
                  ElevatedButton(onPressed: provider.load, child: const Text('Retry')),
                ],
              ),
            );
          }
          if (provider.subjects.isEmpty) {
            return const Center(child: Text('No subjects found'));
          }
          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.subjects.length,
              itemBuilder: (context, index) =>
                  _SubjectTile(subject: provider.subjects[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => _SubjectFormDialog(provider: context.read<SubjectProvider>()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  final Subject subject;
  const _SubjectTile({required this.subject});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SubjectProvider>();
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.book)),
      title: Text(subject.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _SubjectFormDialog(provider: provider, subject: subject),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(context, provider),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, SubjectProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Delete "${subject.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.delete(subject.uuid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'Subject deleted' : provider.error ?? 'Failed'),
                  backgroundColor: ok ? Colors.green : Colors.red,
                ));
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SubjectFormDialog extends StatefulWidget {
  final SubjectProvider provider;
  final Subject? subject;
  const _SubjectFormDialog({required this.provider, this.subject});

  @override
  State<_SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<_SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  bool _isSaving = false;

  bool get _isEdit => widget.subject != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.subject?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Subject' : 'Add Subject'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Subject Name'),
          autofocus: true,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
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
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final ok = _isEdit
        ? await widget.provider.update(uuid: widget.subject!.uuid, name: _nameCtrl.text.trim())
        : await widget.provider.create(name: _nameCtrl.text.trim());

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? (_isEdit ? 'Subject updated' : 'Subject created')
            : widget.provider.error ?? 'Operation failed'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ));
    }
  }
}
