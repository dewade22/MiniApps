import '../repositories/topic_repository.dart';

class DeleteTopicUseCase {
  final TopicRepository repository;
  DeleteTopicUseCase(this.repository);
  Future<void> call(String uuid) => repository.deleteTopic(uuid);
}
