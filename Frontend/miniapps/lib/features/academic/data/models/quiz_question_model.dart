import '../../domain/entities/quiz_question.dart';
import 'question_option_model.dart';

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({
    required super.uuid,
    required super.quizUuid,
    required super.questionUuid,
    required super.questionOrder,
    required super.questionText,
    required super.correctOption,
    required super.difficulty,
    super.options = const [],
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List? ?? [];
    return QuizQuestionModel(
      uuid: (json['uuid'] ?? '').toString(),
      quizUuid: (json['quizUuid'] ?? '').toString(),
      questionUuid: (json['questionUuid'] ?? '').toString(),
      questionOrder: (json['questionOrder'] as num?)?.toInt() ?? 0,
      questionText: (json['questionText'] ?? '').toString(),
      correctOption: (json['correctOption'] ?? '').toString(),
      difficulty: (json['difficulty'] ?? 'medium').toString(),
      options: rawOptions.map((o) => QuestionOptionModel.fromJson(o)).toList(),
    );
  }
}
