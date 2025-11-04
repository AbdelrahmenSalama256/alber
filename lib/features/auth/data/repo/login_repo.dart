import 'package:dartz/dartz.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';

class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  Future<Either<String, ContactResponse>> loginUser({
    String? username,
    String? password,
  }) async {
    try {
      // Static response placeholder. Replace with: await api.post(EndPoints.login, ...)
      final response = {
        'data': {
          'token': 'dummy-token-123',
          'user': {
            'id': 1,
            'name': username ?? 'Guest',
            'email': 'user@example.com',
            'mobile': username ?? '+2000000000',
            'image_url': null,
          }
        }
      };
      return Right(ContactResponse.fromJson(response));
    } catch (e) {
      return Left('Failed to login: $e');
    }
  }

  Future<Either<String, String>> sendForgotPasswordCode(
      String emailOrPhone) async {
    try {
      // Static: always succeed
      return const Right('OTP sent successfully');
    } catch (e) {
      return Left('Failed to send OTP: $e');
    }
  }
}
