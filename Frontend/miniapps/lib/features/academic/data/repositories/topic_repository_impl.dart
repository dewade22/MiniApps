import '../../domain/entities/topic.dart';
import '../../domain/repositories/topic_repository.dart';
import '../datasources/academic_remote_datasource.dart';

class TopicRepositoryImpl implements TopicRepository {
  final AcademicRemoteDataSource dataSource;
  TopicRepositoryImpl(this.dataSource);

  @override
  Future<List<Topic>> getTopics() => dataSource.getTopics();

  @override
  Future<void> createTopic({required String name, required String subjectUuid}) =>
      dataSource.createTopic(name: name, subjectUuid: subjectUuid);

  @override
  Future<void> updateTopic({required String uuid, required String name, required String subjectUuid}) =>
      dataSource.updateTopic(uuid: uuid, name: name, subjectUuid: subjectUuid);

  @override
  Future<void> deleteTopic(String uuid) => dataSource.deleteTopic(uuid);
}
