import '../repositories/grade_repository.dart';

class DeleteGradeUseCase {
  final GradeRepository repository;
  DeleteGradeUseCase(this.repository);
  Future<void> call(String uuid) => repository.deleteGrade(uuid);
}
