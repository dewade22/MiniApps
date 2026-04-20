import 'question_grade.dart';
import 'question_option.dart';

class Question {
  final String uuid;
  final String questionText;
  final String? topicUuid;
  final String correctOption;
  final List<QuestionOption> options;
  final List<QuestionGrade> grades;

  const Question({
    required this.uuid,
    required this.questionText,
    this.topicUuid,
    required this.correctOption,
    required this.options,
    this.grades = const [],
  });
}
