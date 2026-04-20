import '../../domain/entities/question_option.dart';

class QuestionOptionModel extends QuestionOption {
  const QuestionOptionModel({
    required super.uuid,
    required super.questionUuid,
    required super.label,
    required super.optionText,
  });

  factory QuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return QuestionOptionModel(
      uuid: (json['uuid'] ?? '').toString(),
      questionUuid: (json['questionUuid'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      optionText: (json['optionText'] ?? '').toString(),
    );
  }
}
