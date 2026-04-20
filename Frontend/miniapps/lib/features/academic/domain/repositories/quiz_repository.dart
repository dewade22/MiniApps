import '../entities/question.dart';
import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<List<Quiz>> getQuizzes();
  Future<Quiz> getQuiz(String uuid);
  Future<String> createQuiz({
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
  });
  Future<void> deleteQuiz(String uuid);
  Future<Map<String, dynamic>> previewQuiz({
    required String gradeUuid,
    String? subjectUuid,
    String? topicUuid,
    required int questionCount,
    required int timeVeryEasy,
    required int timeEasy,
    required int timeMedium,
    required int timeHard,
    required int timeVeryHard,
  });
  Future<List<Question>> getEligibleQuestions({
    required String gradeUuid,
    String? subjectUuid,
    List<String>? topicUuids,
  });
}
