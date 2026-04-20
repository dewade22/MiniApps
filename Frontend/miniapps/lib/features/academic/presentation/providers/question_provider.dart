import 'package:flutter/material.dart';
import '../../domain/entities/grade.dart';
import '../../domain/entities/question.dart';
import '../../domain/usecases/get_grades_usecase.dart';
import '../../domain/usecases/get_questions_usecase.dart';
import '../../domain/usecases/create_question_usecase.dart';
import '../../domain/usecases/update_question_usecase.dart';
import '../../domain/usecases/delete_question_usecase.dart';

class QuestionProvider extends ChangeNotifier {
  final GetQuestionsUseCase getQuestionsUseCase;
  final CreateQuestionUseCase createQuestionUseCase;
  final UpdateQuestionUseCase updateQuestionUseCase;
  final DeleteQuestionUseCase deleteQuestionUseCase;
  final GetGradesUseCase getGradesUseCase;
  final String topicUuid;

  QuestionProvider({
    required this.getQuestionsUseCase,
    required this.createQuestionUseCase,
    required this.updateQuestionUseCase,
    required this.deleteQuestionUseCase,
    required this.getGradesUseCase,
    required this.topicUuid,
  });

  List<Question> _questions = [];
  List<Grade> _grades = [];
  bool _isLoading = false;
  String? _error;

  List<Question> get questions => _questions;
  List<Grade> get grades => _grades;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        getQuestionsUseCase(topicUuid),
        getGradesUseCase(),
      ]);
      _questions = results[0] as List<Question>;
      _grades = (results[1] as List<Grade>)..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create({
    required String questionText,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) async {
    _error = null;
    try {
      await createQuestionUseCase(
        questionText: questionText,
        topicUuid: topicUuid,
        correctOption: correctOption,
        options: options,
        grades: grades,
      );
      await load();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> update({
    required String uuid,
    required String questionText,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) async {
    _error = null;
    try {
      await updateQuestionUseCase(
        uuid: uuid,
        questionText: questionText,
        topicUuid: topicUuid,
        correctOption: correctOption,
        options: options,
        grades: grades,
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
      await deleteQuestionUseCase(uuid);
      await load();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
