import '../repositories/subject_repository.dart';

class CreateSubjectUseCase {
  final SubjectRepository repository;
  CreateSubjectUseCase(this.repository);
  Future<void> call({required String name}) => repository.createSubject(name: name);
}
