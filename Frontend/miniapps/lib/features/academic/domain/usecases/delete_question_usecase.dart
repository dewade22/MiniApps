import '../repositories/question_repository.dart';

class DeleteQuestionUseCase {
  final QuestionRepository repository;
  DeleteQuestionUseCase(this.repository);
  Future<void> call(String uuid) => repository.deleteQuestion(uuid);
}
