import 'question_option.dart';

class QuizQuestion {
  final String uuid;
  final String quizUuid;
  final String questionUuid;
  final int questionOrder;
  final String questionText;
  final String correctOption;
  final String difficulty;
  final List<QuestionOption> options;

  const QuizQuestion({
    required this.uuid,
    required this.quizUuid,
    required this.questionUuid,
    required this.questionOrder,
    required this.questionText,
    required this.correctOption,
    required this.difficulty,
    this.options = const [],
  });
}
