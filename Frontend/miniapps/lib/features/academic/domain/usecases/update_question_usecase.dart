import '../repositories/question_repository.dart';

class UpdateQuestionUseCase {
  final QuestionRepository repository;
  UpdateQuestionUseCase(this.repository);
  Future<void> call({
    required String uuid,
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) =>
      repository.updateQuestion(
        uuid: uuid,
        questionText: questionText,
        topicUuid: topicUuid,
        correctOption: correctOption,
        options: options,
        grades: grades,
      );
}
