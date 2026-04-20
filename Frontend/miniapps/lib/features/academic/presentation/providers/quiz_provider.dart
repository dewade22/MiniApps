import 'package:flutter/material.dart';
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

class QuizProvider extends ChangeNotifier {
  final GetQuizzesUseCase getQuizzesUseCase;
  final GetQuizUseCase getQuizUseCase;
  final CreateQuizUseCase createQuizUseCase;
  final DeleteQuizUseCase deleteQuizUseCase;
  final PreviewQuizUseCase previewQuizUseCase;
  final GetGradesUseCase getGradesUseCase;
  final GetSubjectsUseCase getSubjectsUseCase;
  final GetTopicsUseCase getTopicsUseCase;
  final GetEligibleQuestionsUseCase getEligibleQuestionsUseCase;

  QuizProvider({
    required this.getQuizzesUseCase,
    required this.getQuizUseCase,
    required this.createQuizUseCase,
    required this.deleteQuizUseCase,
    required this.previewQuizUseCase,
    required this.getGradesUseCase,
    required this.getSubjectsUseCase,
    required this.getTopicsUseCase,
    required this.getEligibleQuestionsUseCase,
  });

  List<Quiz> _quizzes = [];
  List<Grade> _grades = [];
  List<Subject> _subjects = [];
  List<Topic> _topics = [];
  List<Question> _eligibleQuestions = [];
  Map<String, dynamic>? _preview;
  bool _isLoading = false;
  bool _isLoadingEligible = false;
  String? _error;
  String? _eligibleError;

  List<Quiz> get quizzes => _quizzes;
  List<Grade> get grades => _grades;
  List<Subject> get subjects => _subjects;
  List<Topic> get topics => _topics;
  List<Question> get eligibleQuestions => _eligibleQuestions;
  Map<String, dynamic>? get preview => _preview;
  bool get isLoading => _isLoading;
  bool get isLoadingEligible => _isLoadingEligible;
  String? get error => _error;
  String? get eligibleError => _eligibleError;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        getQuizzesUseCase(),
        getGradesUseCase(),
        getSubjectsUseCase(),
        getTopicsUseCase(),
      ]);
      _quizzes = results[0] as List<Quiz>;
      _grades = (results[1] as List<Grade>)..sort((a, b) => a.name.compareTo(b.name));
      _subjects = (results[2] as List<Subject>)..sort((a, b) => a.name.compareTo(b.name));
      _topics = (results[3] as List<Topic>)..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Topic> topicsForSubject(String? subjectUuid) {
    if (subjectUuid == null) return _topics;
    return _topics.where((t) => t.subjectUuid == subjectUuid).toList();
  }

  void clearEligibleQuestions() {
    _eligibleQuestions = [];
    _eligibleError = null;
    notifyListeners();
  }

  Future<void> loadEligibleQuestions({
    required String gradeUuid,
    String? subjectUuid,
    List<String>? topicUuids,
  }) async {
    _isLoadingEligible = true;
    _eligibleError = null;
    _eligibleQuestions = [];
    notifyListeners();
    try {
      _eligibleQuestions = await getEligibleQuestionsUseCase(
        gradeUuid: gradeUuid,
        subjectUuid: subjectUuid,
        topicUuids: topicUuids,
      );
    } catch (e) {
      _eligibleError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingEligible = false;
      notifyListeners();
    }
  }

  Future<void> fetchPreview({
    required String gradeUuid,
    String? subjectUuid,
    String? topicUuid,
    required int questionCount,
    required int timeVeryEasy,
    required int timeEasy,
    required int timeMedium,
    required int timeHard,
    required int timeVeryHard,
  }) async {
    _isLoading = true;
    _preview = null;
    notifyListeners();
    try {
      _preview = await previewQuizUseCase(
        gradeUuid: gradeUuid,
        subjectUuid: subjectUuid,
        topicUuid: topicUuid,
        questionCount: questionCount,
        timeVeryEasy: timeVeryEasy,
        timeEasy: timeEasy,
        timeMedium: timeMedium,
        timeHard: timeHard,
        timeVeryHard: timeVeryHard,
      );
    } catch (_) {
      _preview = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create({
    required String title,
    required String assessmentType,
    String? subjectUuid,
    String? topicUuid,
    List<String>? topicUuids,
    required String gradeUuid,
    required List<String> selectedQuestionUuids,
    required int timeLimitSeconds,
    required int timeVeryEasy,
    required int timeEasy,
    required int timeMedium,
    required int timeHard,
    required int timeVeryHard,
  }) async {
    _error = null;
    try {
      await createQuizUseCase(
        title: title,
        assessmentType: assessmentType,
        subjectUuid: subjectUuid,
        topicUuid: topicUuid,
        topicUuids: topicUuids,
        gradeUuid: gradeUuid,
        selectedQuestionUuids: selectedQuestionUuids,
        timeLimitSeconds: timeLimitSeconds,
        timeVeryEasy: timeVeryEasy,
        timeEasy: timeEasy,
        timeMedium: timeMedium,
        timeHard: timeHard,
        timeVeryHard: timeVeryHard,
      );
      await load();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String uuid) async {
    _error = null;
    try {
      await deleteQuizUseCase(uuid);
      await load();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
