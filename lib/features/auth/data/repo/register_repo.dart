import 'package:dartz/dartz.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/features/auth/data/models/user_registration_model.dart';

class RegisterRepo {
  final ApiConsumer api;

  RegisterRepo(this.api);

  Future<Either<String, Map<String, dynamic>>> registerUser(
      UserRegistrationModel user) async {
    try {
      // Static: pretend registration succeeded and return token message map
      return Right({
        'message': 'Registration successful',
        'data': {'token': 'dummy-token-456'}
      });
    } catch (e) {
      return Left('Failed to register: $e');
    }
  }
}

