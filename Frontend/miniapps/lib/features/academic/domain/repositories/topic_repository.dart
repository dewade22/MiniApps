import '../entities/topic.dart';

abstract class TopicRepository {
  Future<List<Topic>> getTopics();
  Future<void> createTopic({required String name, required String subjectUuid});
  Future<void> updateTopic({required String uuid, required String name, required String subjectUuid});
  Future<void> deleteTopic(String uuid);
}
