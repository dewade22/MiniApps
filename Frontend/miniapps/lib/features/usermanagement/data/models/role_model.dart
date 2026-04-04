class RoleModel {
  final String uuid;
  final String roleName;

  const RoleModel({required this.uuid, required this.roleName});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      uuid: (json['uuid'] ?? '').toString(),
      roleName: json['roleName'] ?? '',
    );
  }
}
