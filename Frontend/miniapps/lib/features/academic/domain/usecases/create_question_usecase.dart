import '../repositories/question_repository.dart';

class CreateQuestionUseCase {
  final QuestionRepository repository;
  CreateQuestionUseCase(this.repository);
  Future<void> call({
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) =>
      repository.createQuestion(
        questionText: questionText,
        topicUuid: topicUuid,
        correctOption: correctOption,
        options: options,
        grades: grades,
      );
}
