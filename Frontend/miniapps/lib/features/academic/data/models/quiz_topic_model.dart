import '../../domain/entities/quiz_topic.dart';

class QuizTopicModel extends QuizTopic {
  const QuizTopicModel({
    required super.uuid,
    required super.quizUuid,
    required super.topicUuid,
    required super.topicName,
  });

  factory QuizTopicModel.fromJson(Map<String, dynamic> json) {
    return QuizTopicModel(
      uuid: (json['uuid'] ?? '').toString(),
      quizUuid: (json['quizUuid'] ?? '').toString(),
      topicUuid: (json['topicUuid'] ?? '').toString(),
      topicName: (json['topicName'] ?? '').toString(),
    );
  }
}
