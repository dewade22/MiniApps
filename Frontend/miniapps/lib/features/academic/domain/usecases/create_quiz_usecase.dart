import '../repositories/quiz_repository.dart';

class CreateQuizUseCase {
  final QuizRepository repository;
  CreateQuizUseCase(this.repository);
  Future<String> call({
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
      repository.createQuiz(
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
}
