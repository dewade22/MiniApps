import '../repositories/school_repository.dart';

class DeleteSchoolUseCase {
  final SchoolRepository repository;
  DeleteSchoolUseCase(this.repository);
  Future<void> call(String uuid) => repository.deleteSchool(uuid);
}
