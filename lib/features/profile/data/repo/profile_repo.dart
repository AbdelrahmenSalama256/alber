import 'package:dartz/dartz.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';

class ProfileRepo {
  final ApiConsumer api;

  ProfileRepo(this.api);

  Future<Either<String, ContactResponse>> getProfile() async {
    try {
      // Static profile
      final json = {
        'data': {
          'token': 'dummy-token-123',
          'user': {
            'id': 1,
            'name': 'John Doe',
            'email': 'user@example.com',
            'mobile': '+2000000000',
            'image_url': null,
          }
        }
      };
      return Right(ContactResponse.fromJson(json));
    } catch (e) {
      return Left('Failed to fetch profile: $e');
    }
  }

  Future<Either<String, String>> updateProfile({
    String? name,
    String? email,
    String? mobile,
  }) async {
    try {
      // Static: pretend success
      return const Right('Profile updated successfully');
    } catch (e) {
      return Left('Failed to update profile: $e');
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      // Static: success
      return const Right('Logged out successfully');
    } catch (e) {
      return Left('Failed to logout: $e');
    }
  }
}

