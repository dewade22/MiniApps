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
          e.response?.data?['errorMessages']?[0] ??
          'Failed to load users';

      throw Exception(message);
    }
  }
}