import '../entities/grade.dart';
import '../repositories/grade_repository.dart';

class GetGradesUseCase {
  final GradeRepository repository;
  GetGradesUseCase(this.repository);
  Future<List<Grade>> call() => repository.getGrades();
}
