import '../entities/grade.dart';

abstract class GradeRepository {
  Future<List<Grade>> getGrades();
  Future<void> createGrade({required String name});
  Future<void> updateGrade({required String uuid, required String name});
  Future<void> deleteGrade(String uuid);
}
