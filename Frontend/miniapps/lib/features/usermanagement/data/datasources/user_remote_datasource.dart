import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await ApiClient.instance.get('/v1/user-account/users');
      final List data = response.data['data'] ?? response.data;
      return data.map((e) => UserModel.fromJson(e)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to load users';
      throw Exception(message);
    }
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await ApiClient.instance.post('/v1/user-account/users', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to create user';
      throw Exception(message);
    }
  }

  Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      await ApiClient.instance.put('/v1/user-account/users/$id', data: {
        'name': name,
        'email': email,
        'role': role,
      });
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to update user';
      throw Exception(message);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await ApiClient.instance.delete('/v1/user-account/users/$id');
    } on DioException catch (e) {
      final message =
          e.response?.data?['errorMessages']?[0] ?? 'Failed to delete user';
      throw Exception(message);
    }
  }
}
