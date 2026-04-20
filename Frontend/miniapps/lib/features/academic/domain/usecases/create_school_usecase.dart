import '../repositories/school_repository.dart';

class CreateSchoolUseCase {
  final SchoolRepository repository;
  CreateSchoolUseCase(this.repository);

  Future<void> call({
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
      repository.createSchool(
        name: name,
        code: code,
        address: address,
        city: city,
        province: province,
        postalCode: postalCode,
        phone: phone,
        email: email,
        website: website,
        principalName: principalName,
        accreditation: accreditation,
        schoolType: schoolType,
        educationLevel: educationLevel,
        isActive: isActive,
      );
}
