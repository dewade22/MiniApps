import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/academic_remote_datasource.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final AcademicRemoteDataSource dataSource;
  QuestionRepositoryImpl(this.dataSource);

  @override
  Future<List<Question>> getQuestionsByTopic(String topicUuid) =>
      dataSource.getQuestionsByTopic(topicUuid);

  @override
  Future<void> createQuestion({
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) =>
      dataSource.createQuestion(
        questionText: questionText,
        topicUuid: topicUuid,
        correctOption: correctOption,
        options: options,
        grades: grades,
      );

  @override
  Future<void> updateQuestion({
    required String uuid,
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) =>
      dataSource.updateQuestion(
        uuid: uuid,
        questionText: questionText,
        topicUuid: topicUuid,
        correctOption: correctOption,
        options: options,
        grades: grades,
      );

  @override
  Future<void> deleteQuestion(String uuid) => dataSource.deleteQuestion(uuid);
}
