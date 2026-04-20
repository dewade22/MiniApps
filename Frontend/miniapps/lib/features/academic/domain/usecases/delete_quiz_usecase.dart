import '../repositories/quiz_repository.dart';

class DeleteQuizUseCase {
  final QuizRepository repository;
  DeleteQuizUseCase(this.repository);
  Future<void> call(String uuid) => repository.deleteQuiz(uuid);
}
