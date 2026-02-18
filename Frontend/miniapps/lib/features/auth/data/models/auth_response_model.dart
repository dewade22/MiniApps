import '../../domain/entities/auth_session.dart';

class AuthResponseModel extends AuthSession {
  AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AuthResponseModel(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
  }
}