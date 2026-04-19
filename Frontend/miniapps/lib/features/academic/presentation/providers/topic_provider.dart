import 'package:flutter/material.dart';
import '../../domain/entities/topic.dart';
import '../../domain/entities/subject.dart';
import '../../domain/usecases/get_topics_usecase.dart';
import '../../domain/usecases/create_topic_usecase.dart';
import '../../domain/usecases/update_topic_usecase.dart';
import '../../domain/usecases/delete_topic_usecase.dart';
import '../../data/datasources/academic_remote_datasource.dart';

class TopicProvider extends ChangeNotifier {
  final GetTopicsUseCase getTopicsUseCase;
  final CreateTopicUseCase createTopicUseCase;
  final UpdateTopicUseCase updateTopicUseCase;
  final DeleteTopicUseCase deleteTopicUseCase;
  final AcademicRemoteDataSource _dataSource;

  TopicProvider({
    required this.getTopicsUseCase,
    required this.createTopicUseCase,
    required this.updateTopicUseCase,
    required this.deleteTopicUseCase,
    required AcademicRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  List<Topic> topics = [];
  List<Subject> subjects = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final results = await Future.wait([
        getTopicsUseCase(),
        _dataSource.getSubjects(),
      ]);
      topics = results[0] as List<Topic>;
      subjects = results[1] as List<Subject>;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create({required String name, required String subjectUuid}) async {
    try {
      await createTopicUseCase(name: name, subjectUuid: subjectUuid);
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> update({
    required String uuid,
    required String name,
    required String subjectUuid,
  }) async {
    try {
      await updateTopicUseCase(uuid: uuid, name: name, subjectUuid: subjectUuid);
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String uuid) async {
    try {
      await deleteTopicUseCase(uuid);
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
