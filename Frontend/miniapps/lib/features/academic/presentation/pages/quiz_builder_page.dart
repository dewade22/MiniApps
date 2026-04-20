import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../../data/datasources/academic_remote_datasource.dart';
import '../../data/repositories/grade_repository_impl.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../data/repositories/subject_repository_impl.dart';
import '../../data/repositories/topic_repository_impl.dart';
import '../../domain/entities/grade.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/topic.dart';
import '../../domain/usecases/get_grades_usecase.dart';
import '../../domain/usecases/get_quizzes_usecase.dart';
import '../../domain/usecases/get_quiz_usecase.dart';
import '../../domain/usecases/create_quiz_usecase.dart';
import '../../domain/usecases/delete_quiz_usecase.dart';
import '../../domain/usecases/preview_quiz_usecase.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/get_topics_usecase.dart';
import '../../domain/usecases/get_eligible_questions_usecase.dart';

class QuizBuilderPage extends StatelessWidget {
  const QuizBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = AcademicRemoteDataSource();
    final quizRepo = QuizRepositoryImpl(ds);
    final gradeRepo = GradeRepositoryImpl(ds);
    final subjectRepo = SubjectRepositoryImpl(ds);
    final topicRepo = TopicRepositoryImpl(ds);

    return ChangeNotifierProvider(
      create: (_) => QuizProvider(
        getQuizzesUseCase: GetQuizzesUseCase(quizRepo),
        getQuizUseCase: GetQuizUseCase(quizRepo),
        createQuizUseCase: CreateQuizUseCase(quizRepo),
        deleteQuizUseCase: DeleteQuizUseCase(quizRepo),
        previewQuizUseCase: PreviewQuizUseCase(quizRepo),
        getGradesUseCase: GetGradesUseCase(gradeRepo),
        getSubjectsUseCase: GetSubjectsUseCase(subjectRepo),
        getTopicsUseCase: GetTopicsUseCase(topicRepo),
        getEligibleQuestionsUseCase: GetEligibleQuestionsUseCase(quizRepo),
      )..load(),
      child: const _QuizBuilderView(),
    );
  }
}

// ── List view ─────────────────────────────────────────────────────────────────

class _QuizBuilderView extends StatelessWidget {
  const _QuizBuilderView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Builder')),
      body: Consumer<QuizProvider>(
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
          if (provider.quizzes.isEmpty) {
            return const Center(child: Text('No quizzes yet. Tap + to build one.'));
          }
          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.quizzes.length,
              itemBuilder: (context, i) =>
                  _QuizTile(quiz: provider.quizzes[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<QuizProvider>(),
              child: const _QuizFormPage(),
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Quiz tile ─────────────────────────────────────────────────────────────────

class _QuizTile extends StatelessWidget {
  final Quiz quiz;
  const _QuizTile({required this.quiz});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final limitMin = quiz.timeLimitSeconds ~/ 60;
    final limitSec = quiz.timeLimitSeconds % 60;
    final minMin = quiz.minTimeSeconds ~/ 60;
    final minSec = quiz.minTimeSeconds % 60;
    final typeInfo = _assessmentTypeInfo(quiz.assessmentType);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _QuizDetailPage(quizUuid: quiz.uuid),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Assessment type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: typeInfo.$2.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: typeInfo.$2.withOpacity(0.5)),
                    ),
                    child: Text(typeInfo.$1,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: typeInfo.$2)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(quiz.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                  // Score visibility icon
                  Tooltip(
                    message: quiz.showScoreImmediately
                        ? 'Score shown immediately'
                        : 'Score hidden from students',
                    child: Icon(
                      quiz.showScoreImmediately
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 16,
                      color: quiz.showScoreImmediately
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _confirmDelete(context, provider),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _InfoChip(Icons.school, quiz.gradeName),
                  if (quiz.subjectName != null)
                    _InfoChip(Icons.book, quiz.subjectName!),
                  // daily_test: show all topics
                  if (quiz.assessmentType == 'daily_test')
                    ...quiz.topics.map(
                      (t) => _InfoChip(Icons.topic, t.topicName),
                    )
                  else if (quiz.topicName != null)
                    _InfoChip(Icons.topic, quiz.topicName!),
                  _InfoChip(Icons.quiz, '${quiz.questionCount} questions'),
                  _InfoChip(
                      Icons.timer,
                      '${limitMin}m ${limitSec}s  ·  min ${minMin}m ${minSec}s'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, QuizProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: Text('Delete "${quiz.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.delete(quiz.uuid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'Quiz deleted' : provider.error ?? 'Failed'),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// ── Quiz detail page ──────────────────────────────────────────────────────────

class _QuizDetailPage extends StatefulWidget {
  final String quizUuid;
  const _QuizDetailPage({required this.quizUuid});

  @override
  State<_QuizDetailPage> createState() => _QuizDetailPageState();
}

// Maps questionUuid → shuffled list of (label, optionText)
typedef _ShuffledOpts = Map<String, List<(String, String)>>;

class _QuizDetailPageState extends State<_QuizDetailPage> {
  Quiz? _quiz;
  bool _loading = true;
  String? _error;
  _ShuffledOpts _shuffledOpts = {};

  late final GetQuizUseCase _getQuizUseCase;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    final ds = AcademicRemoteDataSource();
    _getQuizUseCase = GetQuizUseCase(QuizRepositoryImpl(ds));
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _quiz = await _getQuizUseCase(widget.quizUuid);
      _buildShuffledOpts(_quiz!);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _buildShuffledOpts(Quiz quiz) {
    const labels = ['A', 'B', 'C', 'D', 'E'];
    _shuffledOpts = {};
    for (final q in quiz.questions) {
      final texts = q.options.map((o) => o.optionText).toList()..shuffle(_rng);
      _shuffledOpts[q.questionUuid] = [
        for (int i = 0; i < texts.length; i++) (labels[i], texts[i]),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Detail')),
        body: Center(
            child: Text(_error ?? 'Not found',
                style: const TextStyle(color: Colors.red))),
      );
    }

    final quiz = _quiz!;
    final limitMin = quiz.timeLimitSeconds ~/ 60;
    final limitSec = quiz.timeLimitSeconds % 60;
    final minMin = quiz.minTimeSeconds ~/ 60;
    final minSec = quiz.minTimeSeconds % 60;

    return Scaffold(
      appBar: AppBar(title: Text(quiz.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Summary card ──────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow('Type', _assessmentTypeInfo(quiz.assessmentType).$1),
                  _DetailRow('Score', quiz.showScoreImmediately
                      ? 'Shown immediately'
                      : 'Hidden from students'),
                  _DetailRow('Grade', quiz.gradeName),
                  if (quiz.subjectName != null)
                    _DetailRow('Subject', quiz.subjectName!),
                  // daily_test: show all topics
                  if (quiz.assessmentType == 'daily_test' &&
                      quiz.topics.isNotEmpty)
                    _DetailRow('Topics',
                        quiz.topics.map((t) => t.topicName).join(', '))
                  else if (quiz.topicName != null)
                    _DetailRow('Topic', quiz.topicName!),
                  _DetailRow('Questions', '${quiz.questionCount}'),
                  _DetailRow('Time Limit', '${limitMin}m ${limitSec}s'),
                  _DetailRow('Min Required', '${minMin}m ${minSec}s'),
                  const Divider(height: 20),
                  const Text('Difficulty time values',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _DiffChip('Very Easy', quiz.timeVeryEasy, Colors.teal),
                      _DiffChip('Easy', quiz.timeEasy, Colors.green),
                      _DiffChip('Medium', quiz.timeMedium, Colors.orange),
                      _DiffChip('Hard', quiz.timeHard, Colors.red),
                      _DiffChip('Very Hard', quiz.timeVeryHard, Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Questions ─────────────────────────────────────────────────
          Text('Questions (${quiz.questions.length})',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 8),
          ...quiz.questions.map((q) {
            final diffColor = _difficultyColor(q.difficulty);
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 13,
                          child: Text('${q.questionOrder}',
                              style: const TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(q.questionText,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                        ),
                        Chip(
                          label: Text(q.difficulty,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white)),
                          backgroundColor: diffColor,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...(_shuffledOpts[q.questionUuid] ?? []).map((entry) {
                      final label = entry.$1;
                      final text = entry.$2;
                      final isCorrect = text == q.correctOption;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: Text(label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect
                                        ? Colors.white
                                        : Colors.black87,
                                  )),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(text,
                                    style: const TextStyle(fontSize: 13))),
                            if (isCorrect)
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 15),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text('$label:',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _DiffChip extends StatelessWidget {
  final String label;
  final int seconds;
  final Color color;
  const _DiffChip(this.label, this.seconds, this.color);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: ${seconds}s',
          style: const TextStyle(fontSize: 11, color: Colors.white)),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

Color _difficultyColor(String d) {
  switch (d) {
    case 'very easy':
      return Colors.teal;
    case 'easy':
      return Colors.green;
    case 'hard':
      return Colors.red;
    case 'very hard':
      return Colors.purple;
    default:
      return Colors.orange;
  }
}

// ── Assessment type helpers ────────────────────────────────────────────────────

/// Returns (label, color) for an assessment type string.
(String, Color) _assessmentTypeInfo(String type) {
  switch (type) {
    case 'daily_test':
      return ('Ulangan Harian', Colors.orange);
    case 'semester_test':
      return ('Ulangan Semester', Colors.purple);
    default:
      return ('Quiz', Colors.blue);
  }
}

// ── Quiz Form (Build a new quiz) ──────────────────────────────────────────────

class _QuizFormPage extends StatefulWidget {
  const _QuizFormPage();

  @override
  State<_QuizFormPage> createState() => _QuizFormPageState();
}

class _QuizFormPageState extends State<_QuizFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _timeLimitCtrl = TextEditingController();

  // Assessment type
  String _assessmentType = 'quiz';

  // Difficulty time controllers (seconds)
  final _timeCtrl = {
    'very easy': TextEditingController(text: '30'),
    'easy': TextEditingController(text: '45'),
    'medium': TextEditingController(text: '60'),
    'hard': TextEditingController(text: '90'),
    'very hard': TextEditingController(text: '120'),
  };

  Grade? _selectedGrade;
  // quiz / semester_test: optional single subject + single topic
  Subject? _selectedSubject;
  Topic? _selectedTopic;
  // daily_test: required multi-topic selection (topic UUIDs)
  final Set<String> _selectedTopicUuids = {};

  // Selected question UUIDs
  final Set<String> _selectedQuestionUuids = {};

  bool _isSaving = false;
  bool _questionsLoaded = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _timeLimitCtrl.dispose();
    for (final c in _timeCtrl.values) c.dispose();
    super.dispose();
  }

  int _parseSeconds(String key) =>
      int.tryParse(_timeCtrl[key]!.text.trim()) ?? 0;

  Map<String, int> _timeMap() => {
        'very easy': _parseSeconds('very easy'),
        'easy': _parseSeconds('easy'),
        'medium': _parseSeconds('medium'),
        'hard': _parseSeconds('hard'),
        'very hard': _parseSeconds('very hard'),
      };

  int _calcMinTime(List<Question> eligible) {
    final timeMap = _timeMap();
    int total = 0;
    for (final q in eligible) {
      if (!_selectedQuestionUuids.contains(q.uuid)) continue;
      final gradeEntry =
          q.grades.where((g) => g.gradeUuid == _selectedGrade?.uuid);
      if (gradeEntry.isEmpty) continue;
      total += timeMap[gradeEntry.first.difficulty] ?? _parseSeconds('medium');
    }
    return total;
  }

  void _onFilterChanged() {
    setState(() {
      _selectedQuestionUuids.clear();
      _questionsLoaded = false;
    });
    context.read<QuizProvider>().clearEligibleQuestions();
  }

  Future<void> _loadQuestions() async {
    if (_selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a grade first')),
      );
      return;
    }
    if (_assessmentType == 'daily_test' && _selectedTopicUuids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Select at least one topic for Ulangan Harian')),
      );
      return;
    }
    final provider = context.read<QuizProvider>();
    setState(() {
      _selectedQuestionUuids.clear();
      _questionsLoaded = false;
    });
    await provider.loadEligibleQuestions(
      gradeUuid: _selectedGrade!.uuid,
      subjectUuid:
          _assessmentType != 'daily_test' ? _selectedSubject?.uuid : null,
      topicUuids: _assessmentType == 'daily_test'
          ? _selectedTopicUuids.toList()
          : (_selectedTopic != null ? [_selectedTopic!.uuid] : null),
    );
    if (mounted) setState(() => _questionsLoaded = true);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a grade')));
      return;
    }
    if (_assessmentType == 'daily_test' && _selectedTopicUuids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Select at least one topic for Ulangan Harian')));
      return;
    }
    if (_selectedQuestionUuids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one question')));
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<QuizProvider>();
    final typeLabel = _assessmentTypeInfo(_assessmentType).$1;

    final ok = await provider.create(
      title: _titleCtrl.text.trim(),
      assessmentType: _assessmentType,
      gradeUuid: _selectedGrade!.uuid,
      subjectUuid:
          _assessmentType != 'daily_test' ? _selectedSubject?.uuid : null,
      topicUuid:
          _assessmentType != 'daily_test' ? _selectedTopic?.uuid : null,
      topicUuids: _assessmentType == 'daily_test'
          ? _selectedTopicUuids.toList()
          : null,
      selectedQuestionUuids: _selectedQuestionUuids.toList(),
      timeLimitSeconds: int.parse(_timeLimitCtrl.text.trim()),
      timeVeryEasy: _parseSeconds('very easy'),
      timeEasy: _parseSeconds('easy'),
      timeMedium: _parseSeconds('medium'),
      timeHard: _parseSeconds('hard'),
      timeVeryHard: _parseSeconds('very hard'),
    );

    setState(() => _isSaving = false);
    if (mounted) {
      if (ok) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$typeLabel created'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(provider.error ?? 'Failed to create $typeLabel'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final filteredTopics = provider.topicsForSubject(_selectedSubject?.uuid);
    final eligible = provider.eligibleQuestions;
    final minTime = _calcMinTime(eligible);
    final minMin = minTime ~/ 60;
    final minSec = minTime % 60;
    final typeInfo = _assessmentTypeInfo(_assessmentType);

    return Scaffold(
      appBar: AppBar(title: const Text('Build Assessment')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Assessment type selector ───────────────────────────────
            const Text('Assessment Type',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'quiz',
                    label: Text('Quiz'),
                    icon: Icon(Icons.quiz, size: 16)),
                ButtonSegment(
                    value: 'daily_test',
                    label: Text('Ulangan\nHarian', textAlign: TextAlign.center),
                    icon: Icon(Icons.assignment, size: 16)),
                ButtonSegment(
                    value: 'semester_test',
                    label:
                        Text('Ulangan\nSemester', textAlign: TextAlign.center),
                    icon: Icon(Icons.school, size: 16)),
              ],
              selected: {_assessmentType},
              onSelectionChanged: (v) {
                setState(() {
                  _assessmentType = v.first;
                  _selectedSubject = null;
                  _selectedTopic = null;
                  _selectedTopicUuids.clear();
                });
                _onFilterChanged();
              },
            ),
            // score visibility hint
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  _assessmentType == 'quiz'
                      ? Icons.visibility
                      : Icons.visibility_off,
                  size: 14,
                  color: _assessmentType == 'quiz'
                      ? Colors.green
                      : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  _assessmentType == 'quiz'
                      ? 'Score shown to students immediately'
                      : 'Score hidden from students until released',
                  style: TextStyle(
                    fontSize: 12,
                    color: _assessmentType == 'quiz'
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Title ──────────────────────────────────────────────────
            TextFormField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: '${typeInfo.$1} Title',
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),

            // ── Grade ──────────────────────────────────────────────────
            DropdownButtonFormField<Grade>(
              value: _selectedGrade,
              decoration: const InputDecoration(
                labelText: 'Grade *',
                border: OutlineInputBorder(),
              ),
              items: provider.grades
                  .map((g) => DropdownMenuItem(value: g, child: Text(g.name)))
                  .toList(),
              onChanged: (g) {
                setState(() {
                  _selectedGrade = g;
                  _selectedSubject = null;
                  _selectedTopic = null;
                  _selectedTopicUuids.clear();
                });
                _onFilterChanged();
              },
              validator: (v) => v == null ? 'Grade is required' : null,
            ),
            const SizedBox(height: 16),

            // ── Topic selector (changes by type) ───────────────────────
            if (_assessmentType == 'daily_test') ...[
              // Subject filter (to narrow topic list)
              DropdownButtonFormField<Subject?>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Filter by Subject (optional)',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('— All subjects —')),
                  ...provider.subjects.map(
                    (s) => DropdownMenuItem(value: s, child: Text(s.name)),
                  ),
                ],
                onChanged: (s) => setState(() {
                  _selectedSubject = s;
                  // Clear topic selection when subject filter changes
                  _selectedTopicUuids.clear();
                  _onFilterChanged();
                }),
              ),
              const SizedBox(height: 12),
              // Required multi-topic checkboxes
              Row(
                children: [
                  const Text('Topics *',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    '(${_selectedTopicUuids.length} selected)',
                    style: TextStyle(
                        fontSize: 12,
                        color: _selectedTopicUuids.isEmpty
                            ? Colors.red
                            : Colors.green.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Select all topics this ulangan covers.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ...filteredTopics.map((t) {
                final checked = _selectedTopicUuids.contains(t.uuid);
                return CheckboxListTile(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(t.name,
                      style: const TextStyle(fontSize: 13)),
                  value: checked,
                  onChanged: (_) {
                    setState(() {
                      if (checked) {
                        _selectedTopicUuids.remove(t.uuid);
                      } else {
                        _selectedTopicUuids.add(t.uuid);
                      }
                    });
                    _onFilterChanged();
                  },
                );
              }),
              if (filteredTopics.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('No topics available.',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
              const SizedBox(height: 8),
            ] else ...[
              // quiz / semester_test: optional subject + topic
              DropdownButtonFormField<Subject?>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Subject (optional)',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('— All subjects —')),
                  ...provider.subjects.map(
                    (s) => DropdownMenuItem(value: s, child: Text(s.name)),
                  ),
                ],
                onChanged: (s) {
                  setState(() {
                    _selectedSubject = s;
                    _selectedTopic = null;
                  });
                  _onFilterChanged();
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Topic?>(
                value: _selectedTopic,
                decoration: const InputDecoration(
                  labelText: 'Topic (optional)',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('— All topics —')),
                  ...filteredTopics.map(
                    (t) => DropdownMenuItem(value: t, child: Text(t.name)),
                  ),
                ],
                onChanged: (t) {
                  setState(() => _selectedTopic = t);
                  _onFilterChanged();
                },
              ),
              const SizedBox(height: 16),
            ],

            // ── Difficulty time values ─────────────────────────────────
            const Text('Seconds per Difficulty Level',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 4),
            const Text(
              'Each question contributes its difficulty time to the minimum duration.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ...[
              ('very easy', Colors.teal),
              ('easy', Colors.green),
              ('medium', Colors.orange),
              ('hard', Colors.red),
              ('very hard', Colors.purple),
            ].map((entry) {
              final key = entry.$1;
              final color = entry.$2;
              final label = key[0].toUpperCase() + key.substring(1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                        width: 90,
                        child: Text(label,
                            style: const TextStyle(fontSize: 13))),
                    Expanded(
                      child: TextFormField(
                        controller: _timeCtrl[key],
                        decoration: const InputDecoration(
                          suffixText: 'sec',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          if (n == null || n < 1) return 'Min 1';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),

            // ── Load Questions button ──────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    provider.isLoadingEligible ? null : _loadQuestions,
                icon: provider.isLoadingEligible
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.search),
                label: const Text('Load Eligible Questions'),
              ),
            ),
            const SizedBox(height: 12),

            // ── Eligible question list ─────────────────────────────────
            if (provider.eligibleError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(provider.eligibleError!,
                    style:
                        const TextStyle(color: Colors.red, fontSize: 13)),
              )
            else if (_questionsLoaded && eligible.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                    'No eligible questions found for the selected filters.',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              )
            else if (eligible.isNotEmpty) ...[
              // Selection summary bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedQuestionUuids.isEmpty
                      ? Colors.grey.shade100
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedQuestionUuids.isEmpty
                        ? Colors.grey.shade300
                        : Colors.blue.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_box,
                        size: 16,
                        color: _selectedQuestionUuids.isEmpty
                            ? Colors.grey
                            : Colors.blue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${_selectedQuestionUuids.length} of ${eligible.length} selected',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedQuestionUuids.isEmpty
                              ? Colors.grey
                              : Colors.blue.shade800,
                        ),
                      ),
                    ),
                    if (_selectedQuestionUuids.isNotEmpty)
                      Text(
                        'Min: ${minMin}m ${minSec}s',
                        style: TextStyle(
                            fontSize: 12, color: Colors.blue.shade700),
                      ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => setState(() {
                        if (_selectedQuestionUuids.length ==
                            eligible.length) {
                          _selectedQuestionUuids.clear();
                        } else {
                          _selectedQuestionUuids
                              .addAll(eligible.map((q) => q.uuid));
                        }
                      }),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _selectedQuestionUuids.length == eligible.length
                            ? 'Clear all'
                            : 'Select all',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Question checklist
              ...eligible.map((q) {
                final selected = _selectedQuestionUuids.contains(q.uuid);
                final gradeEntry = q.grades
                    .where((g) => g.gradeUuid == _selectedGrade?.uuid);
                final difficulty = gradeEntry.isEmpty
                    ? 'medium'
                    : gradeEntry.first.difficulty;
                final diffColor = _difficultyColor(difficulty);

                return Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  color: selected ? Colors.blue.shade50 : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: selected
                          ? Colors.blue.shade300
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() {
                      if (selected) {
                        _selectedQuestionUuids.remove(q.uuid);
                      } else {
                        _selectedQuestionUuids.add(q.uuid);
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: selected,
                            onChanged: (_) => setState(() {
                              if (selected) {
                                _selectedQuestionUuids.remove(q.uuid);
                              } else {
                                _selectedQuestionUuids.add(q.uuid);
                              }
                            }),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(q.questionText,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color:
                                            diffColor.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        border: Border.all(
                                            color:
                                                diffColor.withOpacity(0.5)),
                                      ),
                                      child: Text(difficulty,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: diffColor,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                        '${_timeMap()[difficulty] ?? 60}s',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],

            // ── Time limit ─────────────────────────────────────────────
            TextFormField(
              controller: _timeLimitCtrl,
              decoration: InputDecoration(
                labelText: 'Time Limit (seconds)',
                border: const OutlineInputBorder(),
                helperText: _selectedQuestionUuids.isNotEmpty
                    ? 'Minimum required: ${minMin}m ${minSec}s (${minTime}s)'
                    : 'Must be ≥ calculated minimum time',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 1)
                  return 'Enter a valid time in seconds';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ── Submit ─────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: typeInfo.$2,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(
                        _selectedQuestionUuids.isEmpty
                            ? 'Build ${typeInfo.$1}'
                            : 'Build ${typeInfo.$1} (${_selectedQuestionUuids.length} questions)',
                        style: const TextStyle(fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
