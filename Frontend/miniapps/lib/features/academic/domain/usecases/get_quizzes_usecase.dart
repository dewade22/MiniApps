import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuizzesUseCase {
  final QuizRepository repository;
  GetQuizzesUseCase(this.repository);
  Future<List<Quiz>> call() => repository.getQuizzes();
}
