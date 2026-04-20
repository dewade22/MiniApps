import '../entities/question.dart';
import '../repositories/quiz_repository.dart';

class GetEligibleQuestionsUseCase {
  final QuizRepository repository;
  GetEligibleQuestionsUseCase(this.repository);
  Future<List<Question>> call({
    required String gradeUuid,
    String? subjectUuid,
    List<String>? topicUuids,
  }) =>
      repository.getEligibleQuestions(
        gradeUuid: gradeUuid,
        subjectUuid: subjectUuid,
        topicUuids: topicUuids,
      );
}
