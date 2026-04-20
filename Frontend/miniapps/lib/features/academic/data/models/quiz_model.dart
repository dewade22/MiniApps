import '../../domain/entities/quiz.dart';
import 'quiz_question_model.dart';
import 'quiz_topic_model.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required super.uuid,
    required super.title,
    super.subjectUuid,
    super.subjectName,
    super.topicUuid,
    super.topicName,
    required super.gradeUuid,
    required super.gradeName,
    required super.questionCount,
    required super.timeLimitSeconds,
    required super.minTimeSeconds,
    required super.timeVeryEasy,
    required super.timeEasy,
    required super.timeMedium,
    required super.timeHard,
    required super.timeVeryHard,
    super.assessmentType = 'quiz',
    super.showScoreImmediately = true,
    super.topics = const [],
    super.questions = const [],
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'] as List? ?? [];
    final rawTopics = json['topics'] as List? ?? [];
    return QuizModel(
      uuid: (json['uuid'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subjectUuid: json['subjectUuid']?.toString(),
      subjectName: json['subjectName']?.toString(),
      topicUuid: json['topicUuid']?.toString(),
      topicName: json['topicName']?.toString(),
      gradeUuid: (json['gradeUuid'] ?? '').toString(),
      gradeName: (json['gradeName'] ?? '').toString(),
      questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
      timeLimitSeconds: (json['timeLimitSeconds'] as num?)?.toInt() ?? 0,
      minTimeSeconds: (json['minTimeSeconds'] as num?)?.toInt() ?? 0,
      timeVeryEasy: (json['timeVeryEasy'] as num?)?.toInt() ?? 30,
      timeEasy: (json['timeEasy'] as num?)?.toInt() ?? 45,
      timeMedium: (json['timeMedium'] as num?)?.toInt() ?? 60,
      timeHard: (json['timeHard'] as num?)?.toInt() ?? 90,
      timeVeryHard: (json['timeVeryHard'] as num?)?.toInt() ?? 120,
      assessmentType: (json['assessmentType'] ?? 'quiz').toString(),
      showScoreImmediately: json['showScoreImmediately'] as bool? ?? true,
      topics: rawTopics.map((t) => QuizTopicModel.fromJson(t)).toList(),
      questions: rawQuestions.map((q) => QuizQuestionModel.fromJson(q)).toList(),
    );
  }
}
