import '../../domain/entities/subject.dart';

class SubjectModel extends Subject {
  const SubjectModel({required super.uuid, required super.name});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      uuid: (json['uuid'] ?? '').toString(),
      name: json['name'] ?? '',
    );
  }
}
