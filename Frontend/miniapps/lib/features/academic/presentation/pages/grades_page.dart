import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/grade_provider.dart';
import '../../data/datasources/academic_remote_datasource.dart';
import '../../data/repositories/grade_repository_impl.dart';
import '../../domain/entities/grade.dart';
import '../../domain/usecases/get_grades_usecase.dart';
import '../../domain/usecases/create_grade_usecase.dart';
import '../../domain/usecases/update_grade_usecase.dart';
import '../../domain/usecases/delete_grade_usecase.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = AcademicRemoteDataSource();
    final repo = GradeRepositoryImpl(ds);
    return ChangeNotifierProvider(
      create: (_) => GradeProvider(
        getGradesUseCase: GetGradesUseCase(repo),
        createGradeUseCase: CreateGradeUseCase(repo),
        updateGradeUseCase: UpdateGradeUseCase(repo),
        deleteGradeUseCase: DeleteGradeUseCase(repo),
      )..load(),
      child: const _GradesView(),
    );
  }
}

class _GradesView extends StatelessWidget {
  const _GradesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Grades')),
      body: Consumer<GradeProvider>(
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
          if (provider.grades.isEmpty) {
            return const Center(child: Text('No grades found'));
          }
          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.grades.length,
              itemBuilder: (context, index) =>
                  _GradeTile(grade: provider.grades[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog(BuildContext context, {Grade? grade}) {
    showDialog(
      context: context,
      builder: (_) => _GradeFormDialog(
        provider: context.read<GradeProvider>(),
        grade: grade,
      ),
    );
  }
}

class _GradeTile extends StatelessWidget {
  final Grade grade;
  const _GradeTile({required this.grade});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<GradeProvider>();
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.school)),
      title: Text(grade.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _GradeFormDialog(provider: provider, grade: grade),
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

  void _confirmDelete(BuildContext context, GradeProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Grade'),
        content: Text('Delete "${grade.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.delete(grade.uuid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'Grade deleted' : provider.error ?? 'Failed'),
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

class _GradeFormDialog extends StatefulWidget {
  final GradeProvider provider;
  final Grade? grade;
  const _GradeFormDialog({required this.provider, this.grade});

  @override
  State<_GradeFormDialog> createState() => _GradeFormDialogState();
}

class _GradeFormDialogState extends State<_GradeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  bool _isSaving = false;

  bool get _isEdit => widget.grade != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.grade?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Grade' : 'Add Grade'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Grade Name'),
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
        ? await widget.provider.update(uuid: widget.grade!.uuid, name: _nameCtrl.text.trim())
        : await widget.provider.create(name: _nameCtrl.text.trim());

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? (_isEdit ? 'Grade updated' : 'Grade created')
            : widget.provider.error ?? 'Operation failed'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ));
    }
  }
}
