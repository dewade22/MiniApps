import '../entities/school.dart';

abstract class SchoolRepository {
  Future<List<School>> getSchools();
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
  });
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
  });
  Future<void> deleteSchool(String uuid);
}
