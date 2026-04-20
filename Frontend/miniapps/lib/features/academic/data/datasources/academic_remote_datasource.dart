import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/grade_model.dart';
import '../models/question_model.dart';
import '../models/subject_model.dart';
import '../models/topic_model.dart';

class AcademicRemoteDataSource {
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
}
