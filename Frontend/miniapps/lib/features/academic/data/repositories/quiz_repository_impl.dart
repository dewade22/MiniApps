import '../../domain/entities/question.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/academic_remote_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  final AcademicRemoteDataSource dataSource;
  QuizRepositoryImpl(this.dataSource);

  @override
  Future<List<Quiz>> getQuizzes() => dataSource.getQuizzes();

  @override
  Future<Quiz> getQuiz(String uuid) => dataSource.getQuiz(uuid);

  @override
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
  }) =>
      dataSource.createQuiz(
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

  @override
  Future<void> deleteQuiz(String uuid) => dataSource.deleteQuiz(uuid);

  @override
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
  }) =>
      dataSource.previewQuiz(
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

  @override
  Future<List<Question>> getEligibleQuestions({
    required String gradeUuid,
    String? subjectUuid,
    List<String>? topicUuids,
  }) =>
      dataSource.getEligibleQuestions(
        gradeUuid: gradeUuid,
        subjectUuid: subjectUuid,
        topicUuids: topicUuids,
      );
}
