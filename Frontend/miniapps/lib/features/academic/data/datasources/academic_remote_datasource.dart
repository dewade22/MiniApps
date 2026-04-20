import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/grade_model.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../models/school_model.dart';
import '../models/subject_model.dart';
import '../models/topic_model.dart';

class AcademicRemoteDataSource {
  // ── School ───────────────────────────────────────────────────────────────

  Future<List<SchoolModel>> getSchools() async {
    try {
      final response = await ApiClient.instance.get('/v1/schools');
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => SchoolModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load schools');
    }
  }

  Future<void> createSchool({
    required String name,
    required String code,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    required String email,
    String? website,
    required String principalName,
    required String accreditation,
    required String schoolType,
    required String educationLevel,
    required bool isActive,
  }) async {
    try {
      await ApiClient.instance.post('/v1/school', data: {
        'name': name,
        'code': code,
        'address': address,
        'city': city,
        'province': province,
        'postalCode': postalCode,
        'phone': phone,
        'email': email,
        if (website != null && website.isNotEmpty) 'website': website,
        'principalName': principalName,
        'accreditation': accreditation,
        'schoolType': schoolType,
        'educationLevel': educationLevel,
        'isActive': isActive,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to create school');
    }
  }

  Future<void> updateSchool({
    required String uuid,
    required String name,
    required String code,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    required String email,
    String? website,
    required String principalName,
    required String accreditation,
    required String schoolType,
    required String educationLevel,
    required bool isActive,
  }) async {
    try {
      await ApiClient.instance.put('/v1/school/$uuid', data: {
        'name': name,
        'code': code,
        'address': address,
        'city': city,
        'province': province,
        'postalCode': postalCode,
        'phone': phone,
        'email': email,
        if (website != null && website.isNotEmpty) 'website': website,
        'principalName': principalName,
        'accreditation': accreditation,
        'schoolType': schoolType,
        'educationLevel': educationLevel,
        'isActive': isActive,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to update school');
    }
  }

  Future<void> deleteSchool(String uuid) async {
    try {
      await ApiClient.instance.delete('/v1/school/$uuid');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to delete school');
    }
  }

  // ── Grade ────────────────────────────────────────────────────────────────

  Future<List<GradeModel>> getGrades() async {
    try {
      final response = await ApiClient.instance.get('/v1/grades');
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => GradeModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load grades');
    }
  }

  Future<void> createGrade({required String name}) async {
    try {
      await ApiClient.instance.post('/v1/grade', data: {'gradeName': name});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to create grade');
    }
  }

  Future<void> updateGrade({required String uuid, required String name}) async {
    try {
      await ApiClient.instance.put('/v1/grade/$uuid', data: {'gradeName': name});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to update grade');
    }
  }

  Future<void> deleteGrade(String uuid) async {
    try {
      await ApiClient.instance.delete('/v1/grade/$uuid');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to delete grade');
    }
  }

  // ── Subject ──────────────────────────────────────────────────────────────

  Future<List<SubjectModel>> getSubjects() async {
    try {
      final response = await ApiClient.instance.get('/v1/subjects');
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => SubjectModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load subjects');
    }
  }

  Future<void> createSubject({required String name}) async {
    try {
      await ApiClient.instance.post('/v1/subject', data: {'subjectName': name});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to create subject');
    }
  }

  Future<void> updateSubject({required String uuid, required String name}) async {
    try {
      await ApiClient.instance.put('/v1/subject/$uuid', data: {'subjectName': name});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to update subject');
    }
  }

  Future<void> deleteSubject(String uuid) async {
    try {
      await ApiClient.instance.delete('/v1/subject/$uuid');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to delete subject');
    }
  }

  // ── Topic ─────────────────────────────────────────────────────────────────

  Future<List<TopicModel>> getTopics() async {
    try {
      final response = await ApiClient.instance.get('/v1/topics');
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => TopicModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load topics');
    }
  }

  Future<void> createTopic({required String name, required String subjectUuid}) async {
    try {
      await ApiClient.instance.post('/v1/topic', data: {
        'topicName': name,
        'subjectId': subjectUuid,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to create topic');
    }
  }

  Future<void> updateTopic({
    required String uuid,
    required String name,
    required String subjectUuid,
  }) async {
    try {
      await ApiClient.instance.put('/v1/topic/$uuid', data: {
        'topicName': name,
        'subjectId': subjectUuid,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to update topic');
    }
  }

  Future<void> deleteTopic(String uuid) async {
    try {
      await ApiClient.instance.delete('/v1/topic/$uuid');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to delete topic');
    }
  }

  // ── Question ──────────────────────────────────────────────────────────────

  Future<List<QuestionModel>> getQuestionsByTopic(String topicUuid) async {
    try {
      final response = await ApiClient.instance.get('/v1/questions/bytopic', queryParameters: {'topicId': topicUuid});
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => QuestionModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load questions');
    }
  }

  Future<void> createQuestion({
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) async {
    try {
      await ApiClient.instance.post('/v1/question', data: {
        'questionText': questionText,
        'topicUuid': topicUuid,
        'correctOption': correctOption,
        'options': options,
        'grades': grades,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to create question');
    }
  }

  Future<void> updateQuestion({
    required String uuid,
    required String questionText,
    required String? topicUuid,
    required String correctOption,
    required List<Map<String, String>> options,
    required List<Map<String, String>> grades,
  }) async {
    try {
      await ApiClient.instance.put('/v1/question/$uuid', data: {
        'questionText': questionText,
        'topicUuid': topicUuid,
        'correctOption': correctOption,
        'options': options,
        'grades': grades,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to update question');
    }
  }

  Future<void> deleteQuestion(String uuid) async {
    try {
      await ApiClient.instance.delete('/v1/question/$uuid');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to delete question');
    }
  }

  // ── Quiz ──────────────────────────────────────────────────────────────────

  Future<List<QuizModel>> getQuizzes() async {
    try {
      final response = await ApiClient.instance.get('/v1/quizzes');
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => QuizModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load quizzes');
    }
  }

  Future<QuizModel> getQuiz(String uuid) async {
    try {
      final response = await ApiClient.instance.get('/v1/quiz/$uuid');
      return QuizModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load quiz');
    }
  }

  Future<String> createQuiz({
    required String title,
    required String assessmentType,
    String? subjectUuid,
    String? topicUuid,
    List<String>? topicUuids,
    required String gradeUuid,
    required List<String> selectedQuestionUuids,
    required int timeLimitSeconds,
    required int timeVeryEasy,
    required int timeEasy,
    required int timeMedium,
    required int timeHard,
    required int timeVeryHard,
  }) async {
    try {
      final response = await ApiClient.instance.post('/v1/quiz', data: {
        'title': title,
        'assessmentType': assessmentType,
        if (subjectUuid != null) 'subjectUuid': subjectUuid,
        if (topicUuid != null) 'topicUuid': topicUuid,
        if (topicUuids != null && topicUuids.isNotEmpty) 'topicUuids': topicUuids,
        'gradeUuid': gradeUuid,
        'selectedQuestionUuids': selectedQuestionUuids,
        'timeLimitSeconds': timeLimitSeconds,
        'timeVeryEasy': timeVeryEasy,
        'timeEasy': timeEasy,
        'timeMedium': timeMedium,
        'timeHard': timeHard,
        'timeVeryHard': timeVeryHard,
      });
      return (response.data['uuid'] ?? '').toString();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to create quiz');
    }
  }

  Future<void> deleteQuiz(String uuid) async {
    try {
      await ApiClient.instance.delete('/v1/quiz/$uuid');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to delete quiz');
    }
  }

  Future<List<QuestionModel>> getEligibleQuestions({
    required String gradeUuid,
    String? subjectUuid,
    List<String>? topicUuids,
  }) async {
    try {
      final params = <String, dynamic>{'gradeUuid': gradeUuid};
      if (subjectUuid != null) params['subjectUuid'] = subjectUuid;
      if (topicUuids != null && topicUuids.isNotEmpty) params['topicUuids'] = topicUuids;
      final response = await ApiClient.instance.get(
        '/v1/quiz/eligible-questions',
        queryParameters: params,
      );
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => QuestionModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load eligible questions');
    }
  }

  Future<Map<String, dynamic>> previewQuiz({
    required String gradeUuid,
    String? subjectUuid,
    String? topicUuid,
    required int questionCount,
    required int timeVeryEasy,
    required int timeEasy,
    required int timeMedium,
    required int timeHard,
    required int timeVeryHard,
  }) async {
    try {
      final response = await ApiClient.instance.get('/v1/quiz/preview', queryParameters: {
        'gradeUuid': gradeUuid,
        if (subjectUuid != null) 'subjectUuid': subjectUuid,
        if (topicUuid != null) 'topicUuid': topicUuid,
        'questionCount': questionCount,
        'timeVeryEasy': timeVeryEasy,
        'timeEasy': timeEasy,
        'timeMedium': timeMedium,
        'timeHard': timeHard,
        'timeVeryHard': timeVeryHard,
      });
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['errorMessages']?[0] ?? 'Failed to load preview');
    }
  }
}
