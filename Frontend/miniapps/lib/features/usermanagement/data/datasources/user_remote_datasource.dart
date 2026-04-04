import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../models/role_model.dart';

class UserRemoteDataSource {
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await ApiClient.instance.get('/v1/user-account/users');
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to load users';
      throw Exception(message);
    }
  }

  Future<List<RoleModel>> getRoles() async {
    try {
      final response = await ApiClient.instance.get('/v1/roles');
      final List data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => RoleModel.fromJson(e)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to load roles';
      throw Exception(message);
    }
  }

  Future<void> createUser({
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
    required String password,
    required String roleUuid,
  }) async {
    try {
      await ApiClient.instance.post('/v1/user-account/users', data: {
        'emailAddress': emailAddress,
        'firstName': firstName,
        'lastName': lastName,
        'timeZoneId': timeZoneId,
        'password': password,
      });
      await _assignRole(emailAddress: emailAddress, roleUuid: roleUuid);
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to create user';
      throw Exception(message);
    }
  }

  Future<void> updateUser({
    required String uuid,
    required String emailAddress,
    required String firstName,
    required String lastName,
    required String timeZoneId,
    required String roleUuid,
  }) async {
    try {
      await ApiClient.instance.put('/v1/user-account/users/$uuid', data: {
        'emailAddress': emailAddress,
        'firstName': firstName,
        'lastName': lastName,
        'timeZoneId': timeZoneId,
      });
      await _assignRole(emailAddress: emailAddress, roleUuid: roleUuid);
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to update user';
      throw Exception(message);
    }
  }

  Future<void> _assignRole({
    required String emailAddress,
    required String roleUuid,
  }) async {
    await ApiClient.instance.put('/v1/user-account/roles', data: {
      'emailAddress': emailAddress,
      'roleUuid': roleUuid,
    });
  }

  Future<void> deleteUser(String uuid) async {
    try {
      await ApiClient.instance.delete('/v1/user-account/users/$uuid');
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to delete user';
      throw Exception(message);
    }
  }
}
