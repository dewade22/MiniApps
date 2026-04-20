class QuestionGrade {
  final String uuid;
  final String questionUuid;
  final String gradeUuid;
  final String gradeName;
  final String difficulty;

  const QuestionGrade({
    required this.uuid,
    required this.questionUuid,
    required this.gradeUuid,
    required this.gradeName,
    required this.difficulty,
  });
}
