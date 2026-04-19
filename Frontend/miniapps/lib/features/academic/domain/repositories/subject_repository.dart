import '../entities/subject.dart';

abstract class SubjectRepository {
  Future<List<Subject>> getSubjects();
  Future<void> createSubject({required String name});
  Future<void> updateSubject({required String uuid, required String name});
  Future<void> deleteSubject(String uuid);
}
