import '../repositories/quiz_repository.dart';

class PreviewQuizUseCase {
  final QuizRepository repository;
  PreviewQuizUseCase(this.repository);
  Future<Map<String, dynamic>> call({
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
      repository.previewQuiz(
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
}
