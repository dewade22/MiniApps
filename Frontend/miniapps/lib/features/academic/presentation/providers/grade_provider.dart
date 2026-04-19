import 'package:flutter/material.dart';
import '../../domain/entities/grade.dart';
import '../../domain/usecases/get_grades_usecase.dart';
import '../../domain/usecases/create_grade_usecase.dart';
import '../../domain/usecases/update_grade_usecase.dart';
import '../../domain/usecases/delete_grade_usecase.dart';

class GradeProvider extends ChangeNotifier {
  final GetGradesUseCase getGradesUseCase;
  final CreateGradeUseCase createGradeUseCase;
  final UpdateGradeUseCase updateGradeUseCase;
  final DeleteGradeUseCase deleteGradeUseCase;

  GradeProvider({
    required this.getGradesUseCase,
    required this.createGradeUseCase,
    required this.updateGradeUseCase,
    required this.deleteGradeUseCase,
  });

  List<Grade> grades = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      grades = await getGradesUseCase();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create({required String name}) async {
    try {
      await createGradeUseCase(name: name);
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
      await updateGradeUseCase(uuid: uuid, name: name);
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
      await deleteGradeUseCase(uuid);
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
