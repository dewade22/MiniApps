class School {
  final String uuid;
  final String name;
  final String code;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final String phone;
  final String email;
  final String? website;
  final String principalName;
  final String accreditation;
  final String schoolType;
  final String educationLevel;
  final bool isActive;

  const School({
    required this.uuid,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.phone,
    required this.email,
    this.website,
    required this.principalName,
    required this.accreditation,
    required this.schoolType,
    required this.educationLevel,
    required this.isActive,
  });
}
