import '../repositories/grade_repository.dart';

class UpdateGradeUseCase {
  final GradeRepository repository;
  UpdateGradeUseCase(this.repository);
  Future<void> call({required String uuid, required String name}) =>
      repository.updateGrade(uuid: uuid, name: name);
}
