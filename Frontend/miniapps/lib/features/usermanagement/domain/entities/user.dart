class User {
  final String uuid;
  final String emailAddress;
  final String firstName;
  final String lastName;
  final String fullName;
  final String roleName;
  final String timeZoneId;
  final bool isArchived;

  const User({
    required this.uuid,
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.roleName,
    required this.timeZoneId,
    required this.isArchived,
  });
}
