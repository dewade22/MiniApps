import 'package:dio/dio.dart';
import '../models/auth_response_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';

class AuthRemoteDataSource {
  Future<AuthResponseModel> login(
    String email,
    String password,
  ) async {
    try {
      final response = await ApiClient.instance.post(
        '/v1/user-account/signin',
        data: {
          "email": email,
          "password": password,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    }
    on DioException catch (e){
      if (e.response != null) {
        final data = e.response!.data;
        final status = e.response!.statusCode ?? 0;

        if (status == 400 && data['errorMessages'] != null) {
          final errors = data['errorMessages'];
          if (errors is List) {
            throw ApiException(errors.join(', '));
          }
        }

        throw ApiException(
            data['message'] ?? 'Something went wrong, code: $status');
      }
      else {
        throw ApiException(e.message ?? "");
      }
    }
  }

  Future<AuthResponseModel> refreshToken(
    String refreshToken
  ) async {
     try {
      final response = await ApiClient.instance.post(
        '/v1/user-account/refresh',
        data: {
          "refreshToken": refreshToken,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    }
    on DioException catch (e){
      if (e.response != null) {
        final data = e.response!.data;
        final status = e.response!.statusCode ?? 0;

        if (status == 400 && data['errorMessages'] != null) {
          final errors = data['errorMessages'];
          if (errors is List) {
            throw ApiException(errors.join(', '));
          }
        }

        throw ApiException(
            data['message'] ?? 'Something went wrong, code: $status');
      }
      else {
        throw ApiException(e.message ?? "");
      }
    }
  }
}