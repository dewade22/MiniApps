import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/session_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';

class ApiClient {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  )..interceptors.add(QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SessionService().getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final response = error.response;
          if (response != null && response.statusCode == 401) {
            final refreshToken = await SessionService().getRefreshToken();
            if (refreshToken != null) {
              try {
                final newTokens = await AuthRemoteDataSource().refreshToken(refreshToken);
                await SessionService().saveSession(
                  accessToken: newTokens.accessToken,
                  refreshToken: newTokens.refreshToken,
                );

                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
                final cloneReq = await instance.fetch(opts);
                return handler.resolve(cloneReq);
              } catch (e) {
                await SessionService().clearSession();
                return handler.reject(error);
              }
            }
          }
          return handler.next(error);
        },
      ));
}