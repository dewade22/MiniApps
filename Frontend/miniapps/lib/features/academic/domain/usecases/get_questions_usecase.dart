import '../entities/question.dart';
import '../repositories/question_repository.dart';

class GetQuestionsUseCase {
  final QuestionRepository repository;
  GetQuestionsUseCase(this.repository);
  Future<List<Question>> call(String topicUuid) => repository.getQuestionsByTopic(topicUuid);
}
