import '../repositories/grade_repository.dart';

class CreateGradeUseCase {
  final GradeRepository repository;
  CreateGradeUseCase(this.repository);
  Future<void> call({required String name}) => repository.createGrade(name: name);
}
