import '../repositories/topic_repository.dart';

class CreateTopicUseCase {
  final TopicRepository repository;
  CreateTopicUseCase(this.repository);
  Future<void> call({required String name, required String subjectUuid}) =>
      repository.createTopic(name: name, subjectUuid: subjectUuid);
}
