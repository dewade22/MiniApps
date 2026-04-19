import 'package:flutter/material.dart';
import '../../domain/entities/subject.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/create_subject_usecase.dart';
import '../../domain/usecases/update_subject_usecase.dart';
import '../../domain/usecases/delete_subject_usecase.dart';

class SubjectProvider extends ChangeNotifier {
  final GetSubjectsUseCase getSubjectsUseCase;
  final CreateSubjectUseCase createSubjectUseCase;
  final UpdateSubjectUseCase updateSubjectUseCase;
  final DeleteSubjectUseCase deleteSubjectUseCase;

  SubjectProvider({
    required this.getSubjectsUseCase,
    required this.createSubjectUseCase,
    required this.updateSubjectUseCase,
    required this.deleteSubjectUseCase,
  });

  List<Subject> subjects = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      subjects = await getSubjectsUseCase();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create({required String name}) async {
    try {
      await createSubjectUseCase(name: name);
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> update({required String uuid, required String name}) async {
    try {
      await updateSubjectUseCase(uuid: uuid, name: name);
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
      await deleteSubjectUseCase(uuid);
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
