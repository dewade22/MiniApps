import '../../domain/entities/subject.dart';
import '../../domain/repositories/subject_repository.dart';
import '../datasources/academic_remote_datasource.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final AcademicRemoteDataSource dataSource;
  SubjectRepositoryImpl(this.dataSource);

  @override
  Future<List<Subject>> getSubjects() => dataSource.getSubjects();

  @override
  Future<void> createSubject({required String name}) => dataSource.createSubject(name: name);

  @override
  Future<void> updateSubject({required String uuid, required String name}) =>
      dataSource.updateSubject(uuid: uuid, name: name);

  @override
  Future<void> deleteSubject(String uuid) => dataSource.deleteSubject(uuid);
}
