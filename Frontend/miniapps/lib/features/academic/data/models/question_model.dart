import '../../domain/entities/question.dart';
import 'question_grade_model.dart';
import 'question_option_model.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.uuid,
    required super.questionText,
    super.topicUuid,
    required super.correctOption,
    required super.options,
    super.grades = const [],
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List? ?? [];
    final rawGrades = json['grades'] as List? ?? [];
    return QuestionModel(
      uuid: (json['uuid'] ?? '').toString(),
      questionText: json['questionText'] ?? '',
      topicUuid: json['topicUuid']?.toString(),
      correctOption: (json['correctOption'] ?? '').toString(),
      options: rawOptions.map((o) => QuestionOptionModel.fromJson(o)).toList(),
      grades: rawGrades.map((g) => QuestionGradeModel.fromJson(g)).toList(),
    );
  }
}
