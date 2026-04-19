import '../repositories/topic_repository.dart';

class UpdateTopicUseCase {
  final TopicRepository repository;
  UpdateTopicUseCase(this.repository);
  Future<void> call({required String uuid, required String name, required String subjectUuid}) =>
      repository.updateTopic(uuid: uuid, name: name, subjectUuid: subjectUuid);
}
