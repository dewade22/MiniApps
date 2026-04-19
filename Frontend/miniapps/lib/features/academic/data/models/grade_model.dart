import '../../domain/entities/grade.dart';

class GradeModel extends Grade {
  const GradeModel({required super.uuid, required super.name});

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      uuid: (json['uuid'] ?? '').toString(),
      name: json['name'] ?? '',
    );
  }
}
