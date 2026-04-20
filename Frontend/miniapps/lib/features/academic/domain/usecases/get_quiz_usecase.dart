import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuizUseCase {
  final QuizRepository repository;
  GetQuizUseCase(this.repository);
  Future<Quiz> call(String uuid) => repository.getQuiz(uuid);
}
