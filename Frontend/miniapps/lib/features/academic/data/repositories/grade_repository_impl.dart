import '../../domain/entities/grade.dart';
import '../../domain/repositories/grade_repository.dart';
import '../datasources/academic_remote_datasource.dart';

class GradeRepositoryImpl implements GradeRepository {
  final AcademicRemoteDataSource dataSource;
  GradeRepositoryImpl(this.dataSource);

  @override
  Future<List<Grade>> getGrades() => dataSource.getGrades();

  @override
  Future<void> createGrade({required String name}) => dataSource.createGrade(name: name);

  @override
  Future<void> updateGrade({required String uuid, required String name}) =>
      dataSource.updateGrade(uuid: uuid, name: name);

  @override
  Future<void> deleteGrade(String uuid) => dataSource.deleteGrade(uuid);
}
