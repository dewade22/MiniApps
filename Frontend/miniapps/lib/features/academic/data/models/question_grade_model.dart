import '../../domain/entities/question_grade.dart';

class QuestionGradeModel extends QuestionGrade {
  const QuestionGradeModel({
    required super.uuid,
    required super.questionUuid,
    required super.gradeUuid,
    required super.gradeName,
    required super.difficulty,
  });

  factory QuestionGradeModel.fromJson(Map<String, dynamic> json) {
    return QuestionGradeModel(
      uuid: (json['uuid'] ?? '').toString(),
      questionUuid: (json['questionUuid'] ?? '').toString(),
      gradeUuid: (json['gradeUuid'] ?? '').toString(),
      gradeName: (json['gradeName'] ?? '').toString(),
      difficulty: (json['difficulty'] ?? 'medium').toString(),
    );
  }
}
