import '../entities/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestionsByTopic(String topicUuid);
  Future<void> createQuestion({
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  });
  Future<void> updateQuestion({
    required String uuid,
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  });
  Future<void> deleteQuestion(String uuid);
}
