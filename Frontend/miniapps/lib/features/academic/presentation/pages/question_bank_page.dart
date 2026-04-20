import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/topic_provider.dart';
import '../../data/datasources/academic_remote_datasource.dart';
import '../../data/repositories/topic_repository_impl.dart';
import '../../domain/entities/topic.dart';
import '../../domain/usecases/get_topics_usecase.dart';
import '../../domain/usecases/create_topic_usecase.dart';
import '../../domain/usecases/update_topic_usecase.dart';
import '../../domain/usecases/delete_topic_usecase.dart';
import 'questions_page.dart';

/// Entry point for the Question Bank from the admin dashboard.
/// Shows a list of topics — tapping any topic opens its questions.
class QuestionBankPage extends StatelessWidget {
  const QuestionBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = AcademicRemoteDataSource();
    final repo = TopicRepositoryImpl(ds);
    return ChangeNotifierProvider(
      create: (_) => TopicProvider(
        getTopicsUseCase: GetTopicsUseCase(repo),
        createTopicUseCase: CreateTopicUseCase(repo),
        updateTopicUseCase: UpdateTopicUseCase(repo),
        deleteTopicUseCase: DeleteTopicUseCase(repo),
        dataSource: ds,
      )..load(),
      child: const _QuestionBankView(),
    );
  }
}

class _QuestionBankView extends StatelessWidget {
  const _QuestionBankView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Bank')),
      body: Consumer<TopicProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: provider.load, child: const Text('Retry')),
                ],
              ),
            );
          }
          if (provider.topics.isEmpty) {
            return const Center(child: Text('No topics found. Add topics first.'));
          }
          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.topics.length,
              itemBuilder: (context, index) {
                final topic = provider.topics[index];
                final subjectName = provider.subjects
                    .where((s) => s.uuid == topic.subjectUuid)
                    .map((s) => s.name)
                    .firstOrNull ?? 'Unknown Subject';

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.quiz)),
                  title: Text(topic.name),
                  subtitle: Text(subjectName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QuestionsPage(topic: topic)),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
