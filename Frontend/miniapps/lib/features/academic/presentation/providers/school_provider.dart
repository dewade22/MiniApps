import 'package:flutter/material.dart';
import '../../domain/entities/school.dart';
import '../../domain/usecases/get_schools_usecase.dart';
import '../../domain/usecases/create_school_usecase.dart';
import '../../domain/usecases/update_school_usecase.dart';
import '../../domain/usecases/delete_school_usecase.dart';

class SchoolProvider extends ChangeNotifier {
  final GetSchoolsUseCase getSchoolsUseCase;
  final CreateSchoolUseCase createSchoolUseCase;
  final UpdateSchoolUseCase updateSchoolUseCase;
  final DeleteSchoolUseCase deleteSchoolUseCase;

  SchoolProvider({
    required this.getSchoolsUseCase,
    required this.createSchoolUseCase,
    required this.updateSchoolUseCase,
    required this.deleteSchoolUseCase,
  });

  List<School> schools = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      schools = await getSchoolsUseCase();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create({
    required String name,
    required String code,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    required String email,
    String? website,
    required String principalName,
    required String accreditation,
    required String schoolType,
    required String educationLevel,
    required bool isActive,
  }) async {
    try {
      await createSchoolUseCase(
        name: name, code: code, address: address, city: city,
        province: province, postalCode: postalCode, phone: phone, email: email,
        website: website, principalName: principalName,
        accreditation: accreditation, schoolType: schoolType,
        educationLevel: educationLevel, isActive: isActive,
      );
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
    required String code,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    required String email,
    String? website,
    required String principalName,
    required String accreditation,
    required String schoolType,
    required String educationLevel,
    required bool isActive,
  }) async {
    try {
      await updateSchoolUseCase(
        uuid: uuid, name: name, code: code, address: address, city: city,
        province: province, postalCode: postalCode, phone: phone, email: email,
        website: website, principalName: principalName,
        accreditation: accreditation, schoolType: schoolType,
        educationLevel: educationLevel, isActive: isActive,
      );
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
      await deleteSchoolUseCase(uuid);
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
