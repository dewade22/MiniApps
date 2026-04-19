import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/topic_provider.dart';
import '../../data/datasources/academic_remote_datasource.dart';
import '../../data/repositories/topic_repository_impl.dart';
import '../../domain/entities/topic.dart';
import '../../domain/entities/subject.dart';
import '../../domain/usecases/get_topics_usecase.dart';
import '../../domain/usecases/create_topic_usecase.dart';
import '../../domain/usecases/update_topic_usecase.dart';
import '../../domain/usecases/delete_topic_usecase.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = AcademicRemoteDataSource();
    final repo = TopicRepositoryImpl(ds);
    return ChangeNotifierProvider(
      create: (_) => TopicProvider(
        getTopicsUseCase: GetTopicsUseCase(repo),
        createTopicUseCase: CreateTopicUseCase(repo),
        updateTopicUseCase: UpdateTopicUseCase(repo),
        deleteTopicUseCase: DeleteTopicUseCase(repo),
        dataSource: ds,
      )..load(),
      child: const _TopicsView(),
    );
  }
}

class _TopicsView extends StatelessWidget {
  const _TopicsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Topics')),
      body: Consumer<TopicProvider>(
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
          if (provider.topics.isEmpty) {
            return const Center(child: Text('No topics found'));
          }
          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.topics.length,
              itemBuilder: (context, index) =>
                  _TopicTile(topic: provider.topics[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => _TopicFormDialog(provider: context.read<TopicProvider>()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  final Topic topic;
  const _TopicTile({required this.topic});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TopicProvider>();
    final subjectName = provider.subjects
        .where((s) => s.uuid == topic.subjectUuid)
        .map((s) => s.name)
        .firstOrNull ?? 'Unknown Subject';

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.topic)),
      title: Text(topic.name),
      subtitle: Text(subjectName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _TopicFormDialog(provider: provider, topic: topic),
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

  void _confirmDelete(BuildContext context, TopicProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Topic'),
        content: Text('Delete "${topic.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.delete(topic.uuid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'Topic deleted' : provider.error ?? 'Failed'),
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

class _TopicFormDialog extends StatefulWidget {
  final TopicProvider provider;
  final Topic? topic;
  const _TopicFormDialog({required this.provider, this.topic});

  @override
  State<_TopicFormDialog> createState() => _TopicFormDialogState();
}

class _TopicFormDialogState extends State<_TopicFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  Subject? _selectedSubject;
  bool _isSaving = false;

  bool get _isEdit => widget.topic != null;
  List<Subject> get _subjects => widget.provider.subjects;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.topic?.name ?? '');

    if (_isEdit) {
      _selectedSubject = _subjects
          .where((s) => s.uuid == widget.topic!.subjectUuid)
          .firstOrNull;
    }
    _selectedSubject ??= _subjects.isNotEmpty ? _subjects.first : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Topic' : 'Add Topic'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Topic Name'),
              autofocus: true,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            if (_subjects.isEmpty)
              const Text('No subjects available.', style: TextStyle(color: Colors.grey))
            else
              DropdownButtonFormField<Subject>(
                value: _selectedSubject,
                decoration: const InputDecoration(labelText: 'Subject'),
                isExpanded: true,
                items: _subjects
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedSubject = v),
                validator: (v) => v == null ? 'Subject is required' : null,
              ),
          ],
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
        ? await widget.provider.update(
            uuid: widget.topic!.uuid,
            name: _nameCtrl.text.trim(),
            subjectUuid: _selectedSubject!.uuid,
          )
        : await widget.provider.create(
            name: _nameCtrl.text.trim(),
            subjectUuid: _selectedSubject!.uuid,
          );

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? (_isEdit ? 'Topic updated' : 'Topic created')
            : widget.provider.error ?? 'Operation failed'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ));
    }
  }
}
