import '../repositories/subject_repository.dart';

class UpdateSubjectUseCase {
  final SubjectRepository repository;
  UpdateSubjectUseCase(this.repository);
  Future<void> call({required String uuid, required String name}) =>
      repository.updateSubject(uuid: uuid, name: name);
}
