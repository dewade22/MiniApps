import '../../domain/entities/school.dart';
import '../../domain/repositories/school_repository.dart';
import '../datasources/academic_remote_datasource.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final AcademicRemoteDataSource dataSource;
  SchoolRepositoryImpl(this.dataSource);

  @override
  Future<List<School>> getSchools() => dataSource.getSchools();

  @override
  Future<void> createSchool({
    required String name,
    required String code,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    required String email,
    String? website,
    required String principalName,
    required String accreditation,
    required String schoolType,
    required String educationLevel,
    required bool isActive,
  }) =>
      dataSource.createSchool(
        name: name, code: code, address: address, city: city,
        province: province, postalCode: postalCode, phone: phone, email: email,
        website: website, principalName: principalName,
        accreditation: accreditation, schoolType: schoolType,
        educationLevel: educationLevel, isActive: isActive,
      );

  @override
  Future<void> updateSchool({
    required String uuid,
    required String name,
    required String code,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    required String email,
    String? website,
    required String principalName,
    required String accreditation,
    required String schoolType,
    required String educationLevel,
    required bool isActive,
  }) =>
      dataSource.updateSchool(
        uuid: uuid, name: name, code: code, address: address, city: city,
        province: province, postalCode: postalCode, phone: phone, email: email,
        website: website, principalName: principalName,
        accreditation: accreditation, schoolType: schoolType,
        educationLevel: educationLevel, isActive: isActive,
      );

  @override
  Future<void> deleteSchool(String uuid) => dataSource.deleteSchool(uuid);
}
