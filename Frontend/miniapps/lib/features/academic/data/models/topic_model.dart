import '../../domain/entities/topic.dart';

class TopicModel extends Topic {
  const TopicModel({
    required super.uuid,
    required super.name,
    required super.subjectUuid,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      uuid: (json['uuid'] ?? '').toString(),
      name: json['name'] ?? '',
      subjectUuid: (json['subjectUuid'] ?? '').toString(),
    );
  }
}
