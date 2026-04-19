import '../repositories/subject_repository.dart';

class DeleteSubjectUseCase {
  final SubjectRepository repository;
  DeleteSubjectUseCase(this.repository);
  Future<void> call(String uuid) => repository.deleteSubject(uuid);
}
