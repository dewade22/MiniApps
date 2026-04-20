import '../../domain/entities/school.dart';

class SchoolModel extends School {
  const SchoolModel({
    required super.uuid,
    required super.name,
    required super.code,
    required super.address,
    required super.city,
    required super.province,
    required super.postalCode,
    required super.phone,
    required super.email,
    super.website,
    required super.principalName,
    required super.accreditation,
    required super.schoolType,
    required super.educationLevel,
    required super.isActive,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      uuid:           (json['uuid'] ?? '').toString(),
      name:           json['name'] ?? '',
      code:           json['code'] ?? '',
      address:        json['address'] ?? '',
      city:           json['city'] ?? '',
      province:       json['province'] ?? '',
      postalCode:     json['postalCode'] ?? '',
      phone:          json['phone'] ?? '',
      email:          json['email'] ?? '',
      website:        json['website'],
      principalName:  json['principalName'] ?? '',
      accreditation:  json['accreditation'] ?? 'Not Yet',
      schoolType:     json['schoolType'] ?? 'Public',
      educationLevel: json['educationLevel'] ?? '',
      isActive:       json['isActive'] ?? true,
    );
  }
}
