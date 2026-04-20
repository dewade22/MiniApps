import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/question_provider.dart';
import '../../data/datasources/academic_remote_datasource.dart';
import '../../data/repositories/grade_repository_impl.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../domain/entities/grade.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/topic.dart';
import '../../domain/usecases/get_grades_usecase.dart';
import '../../domain/usecases/get_questions_usecase.dart';
import '../../domain/usecases/create_question_usecase.dart';
import '../../domain/usecases/update_question_usecase.dart';
import '../../domain/usecases/delete_question_usecase.dart';

class QuestionsPage extends StatelessWidget {
  final Topic topic;
  const QuestionsPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final ds = AcademicRemoteDataSource();
    final repo = QuestionRepositoryImpl(ds);
    final gradeRepo = GradeRepositoryImpl(ds);
    return ChangeNotifierProvider(
      create: (_) => QuestionProvider(
        getQuestionsUseCase: GetQuestionsUseCase(repo),
        createQuestionUseCase: CreateQuestionUseCase(repo),
        updateQuestionUseCase: UpdateQuestionUseCase(repo),
        deleteQuestionUseCase: DeleteQuestionUseCase(repo),
        getGradesUseCase: GetGradesUseCase(gradeRepo),
        topicUuid: topic.uuid,
      )..load(),
      child: _QuestionsView(topic: topic),
    );
  }
}

class _QuestionsView extends StatelessWidget {
  final Topic topic;
  const _QuestionsView({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Questions — ${topic.name}')),
      body: Consumer<QuestionProvider>(
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
          if (provider.questions.isEmpty) {
            return const Center(child: Text('No questions yet. Tap + to add one.'));
          }
          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.questions.length,
              itemBuilder: (context, index) =>
                  _QuestionCard(question: provider.questions[index], index: index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => _QuestionFormDialog(provider: context.read<QuestionProvider>()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Difficulty helpers ────────────────────────────────────────────────────────

Color _difficultyColor(String difficulty) {
  switch (difficulty) {
    case 'very easy':
      return Colors.teal;
    case 'easy':
      return Colors.green;
    case 'hard':
      return Colors.red;
    case 'very hard':
      return Colors.purple;
    default: // medium
      return Colors.orange;
  }
}

// ── Question Card ─────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  const _QuestionCard({required this.question, required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuestionProvider>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ─────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) =>
                        _QuestionFormDialog(provider: provider, question: question),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _confirmDelete(context, provider),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Options — correctOption now holds the answer text ──────────
            ...question.options.map((opt) {
              final isCorrect = opt.optionText == question.correctOption;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        opt.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.white : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(opt.optionText)),
                    if (isCorrect)
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  ],
                ),
              );
            }),

            // ── Grade chips ────────────────────────────────────────────────
            if (question.grades.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: question.grades.map((g) {
                  final color = _difficultyColor(g.difficulty);
                  return Chip(
                    label: Text(
                      '${g.gradeName} · ${g.difficulty}',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                    backgroundColor: color,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, QuestionProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Delete this question? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.delete(question.uuid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'Question deleted' : provider.error ?? 'Failed'),
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

// ── Question Form Dialog ──────────────────────────────────────────────────────

class _QuestionFormDialog extends StatefulWidget {
  final QuestionProvider provider;
  final Question? question;
  const _QuestionFormDialog({required this.provider, this.question});

  @override
  State<_QuestionFormDialog> createState() => _QuestionFormDialogState();
}

class _QuestionFormDialogState extends State<_QuestionFormDialog> {
  // A–E labels; options count is always 5
  static const _labels = ['A', 'B', 'C', 'D', 'E'];
  static const _difficulties = ['very easy', 'easy', 'medium', 'hard', 'very hard'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionCtrl;
  late final List<TextEditingController> _optionCtrls;

  /// Index into _optionCtrls of the correct answer (0–4).
  late int _correctIndex;

  bool _isSaving = false;

  // Grade assignments: gradeUuid -> difficulty
  late final Map<String, String> _gradeAssignments;

  bool get _isEdit => widget.question != null;
  List<Grade> get _availableGrades => widget.provider.grades;

  @override
  void initState() {
    super.initState();
    _questionCtrl = TextEditingController(text: widget.question?.questionText ?? '');
    _optionCtrls = List.generate(5, (_) => TextEditingController());

    if (_isEdit) {
      final q = widget.question!;
      // Fill option text fields in A–E order
      for (var i = 0; i < _labels.length; i++) {
        final match = q.options.where((o) => o.label == _labels[i]).firstOrNull;
        _optionCtrls[i].text = match?.optionText ?? '';
      }
      // Determine which index holds the correct answer text
      final correctIdx = q.options.indexWhere((o) => o.optionText == q.correctOption);
      _correctIndex = correctIdx >= 0 ? correctIdx : 0;

      _gradeAssignments = {for (final g in q.grades) g.gradeUuid: g.difficulty};
    } else {
      _correctIndex = 0;
      _gradeAssignments = {};
    }
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    for (final c in _optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  List<Map<String, String>> get _buildOptions => List.generate(
        5,
        (i) => {'label': _labels[i], 'optionText': _optionCtrls[i].text.trim()},
      );

  List<Map<String, String>> get _buildGrades => _gradeAssignments.entries
      .map((e) => {'gradeUuid': e.key, 'difficulty': e.value})
      .toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Question' : 'Add Question'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Question text ──────────────────────────────────────────────
            TextFormField(
              controller: _questionCtrl,
              decoration: const InputDecoration(labelText: 'Question Text'),
              maxLines: 3,
              minLines: 1,
              autofocus: true,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Question text is required' : null,
            ),
            const SizedBox(height: 16),

            // ── Options A–E with radio for correct answer ──────────────────
            const Text('Options', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text(
              'Tap the circle to mark the correct answer.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ...List.generate(5, (i) {
              final isCorrect = _correctIndex == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Radio button — tap to set this option as correct answer
                    GestureDetector(
                      onTap: () => setState(() => _correctIndex = i),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCorrect ? Colors.green : Colors.transparent,
                          border: Border.all(
                            color: isCorrect ? Colors.green : Colors.grey,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _labels[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _optionCtrls[i],
                        decoration: InputDecoration(
                          labelText: 'Option ${_labels[i]}',
                          isDense: true,
                          suffixIcon: isCorrect
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green, size: 18)
                              : null,
                        ),
                        onChanged: (_) => setState(() {}), // refresh suffix icon
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Option ${_labels[i]} is required'
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // ── Grade assignments ──────────────────────────────────────────
            if (_availableGrades.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Grade Assignments',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text(
                'Select which grades use this question and the difficulty for each.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ..._availableGrades.map((grade) {
                final isAssigned = _gradeAssignments.containsKey(grade.uuid);
                final difficulty = _gradeAssignments[grade.uuid] ?? 'medium';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isAssigned,
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _gradeAssignments[grade.uuid] = 'medium';
                            } else {
                              _gradeAssignments.remove(grade.uuid);
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Text(grade.name,
                            style: const TextStyle(fontSize: 14)),
                      ),
                      if (isAssigned)
                        SizedBox(
                          width: 110,
                          child: DropdownButtonFormField<String>(
                            value: difficulty,
                            isDense: true,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              border: OutlineInputBorder(),
                            ),
                            items: _difficulties
                                .map((d) => DropdownMenuItem(
                                      value: d,
                                      child: Text(
                                        d[0].toUpperCase() + d.substring(1),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _gradeAssignments[grade.uuid] = v);
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
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

    // correctOption = teks dari opsi yang dipilih, bukan labelnya
    final correctOptionText = _optionCtrls[_correctIndex].text.trim();

    final ok = _isEdit
        ? await widget.provider.update(
            uuid: widget.question!.uuid,
            questionText: _questionCtrl.text.trim(),
            correctOption: correctOptionText,
            options: _buildOptions,
            grades: _buildGrades,
          )
        : await widget.provider.create(
            questionText: _questionCtrl.text.trim(),
            correctOption: correctOptionText,
            options: _buildOptions,
            grades: _buildGrades,
          );

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? (_isEdit ? 'Question updated' : 'Question created')
            : widget.provider.error ?? 'Operation failed'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ));
    }
  }
}
