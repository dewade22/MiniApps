import 'quiz_question.dart';
import 'quiz_topic.dart';

class Quiz {
  final String uuid;
  final String title;
  final String? subjectUuid;
  final String? subjectName;
  final String? topicUuid;
  final String? topicName;
  final String gradeUuid;
  final String gradeName;
  final int questionCount;
  final int timeLimitSeconds;
  final int minTimeSeconds;
  final int timeVeryEasy;
  final int timeEasy;
  final int timeMedium;
  final int timeHard;
  final int timeVeryHard;

  /// "quiz" | "daily_test" | "semester_test"
  final String assessmentType;
  final bool showScoreImmediately;

  /// Topics covered — populated for daily_test
  final List<QuizTopic> topics;

  final List<QuizQuestion> questions;

  const Quiz({
    required this.uuid,
    required this.title,
    this.subjectUuid,
    this.subjectName,
    this.topicUuid,
    this.topicName,
    required this.gradeUuid,
    required this.gradeName,
    required this.questionCount,
    required this.timeLimitSeconds,
    required this.minTimeSeconds,
    required this.timeVeryEasy,
    required this.timeEasy,
    required this.timeMedium,
    required this.timeHard,
    required this.timeVeryHard,
    this.assessmentType = 'quiz',
    this.showScoreImmediately = true,
    this.topics = const [],
    this.questions = const [],
  });
}
