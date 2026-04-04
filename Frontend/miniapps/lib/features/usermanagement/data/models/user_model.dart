import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uuid,
    required super.emailAddress,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.roleName,
    required super.timeZoneId,
    required super.isArchived,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uuid: (json['uuid'] ?? '').toString(),
      emailAddress: json['emailAddress'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      roleName: json['roleName'] ?? '',
      timeZoneId: json['timeZoneId'] ?? 'UTC',
      isArchived: json['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'emailAddress': emailAddress,
        'firstName': firstName,
        'lastName': lastName,
        'roleName': roleName,
        'timeZoneId': timeZoneId,
        'isArchived': isArchived,
      };
}
