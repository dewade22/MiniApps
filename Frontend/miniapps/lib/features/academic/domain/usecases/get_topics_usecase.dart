import '../entities/topic.dart';
import '../repositories/topic_repository.dart';

class GetTopicsUseCase {
  final TopicRepository repository;
  GetTopicsUseCase(this.repository);
  Future<List<Topic>> call() => repository.getTopics();
}
