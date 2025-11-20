import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';

class ProfileRepo {
  final ApiConsumer api;

  ProfileRepo(this.api);

  Future<Either<String, ContactResponse>> getProfile() async {
    try {
      final response = await api.get(EndPoints.getProfile);
      final payload = response is Response ? response.data : response;
      if (payload is! Map<String, dynamic>) {
        return const Left('profile_fetch_failed');
      }
      final normalized = {
        'data': {
          'token': null,
          'user': _mapProfileUser(Map<String, dynamic>.from(payload)),
        }
      };
      return Right(ContactResponse.fromJson(normalized));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch profile: $e');
    }
  }

  Future<Either<String, ContactResponse>> updateProfile({
    String? displayName,
    String? gender,
    XFile? avatarFile,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (displayName != null && displayName.trim().isNotEmpty) {
        body['displayName'] = displayName.trim();
      }
      if (gender != null && gender.trim().isNotEmpty) {
        body['gender'] = gender.trim();
      }
      if (avatarFile != null) {
        body['avatar'] = await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.name,
        );
      }
      if (body.isEmpty) {
        return const Left('no_profile_changes');
      }

      final isMultipart = body.containsKey('avatar');
      final payload = isMultipart ? FormData.fromMap(body) : body;

      final response = await api.patch(
        EndPoints.getProfile,
        data: payload,
        isFormData: isMultipart,
      );
      final data = response is Response ? response.data : response;
      if (data is! Map<String, dynamic>) {
        return const Left('profile_update_failed');
      }
      final normalized = {
        'data': {
          'token': null,
          'user': _mapProfileUser(Map<String, dynamic>.from(data)),
        }
      };
      return Right(ContactResponse.fromJson(normalized));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      PrintUtil.error('update_profile_error: $e');
      return Left('Failed to update profile: $e');
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      final response = await api.post(EndPoints.userLogout);
      final data = response is Response ? response.data : response;
      if (data is Map<String, dynamic>) {
        final message =
            data['message']?.toString() ?? 'Logged out successfully';
        return Right(message);
      }
      return const Right('Logged out successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to logout: $e');
    }
  }

  Map<String, dynamic> _mapProfileUser(Map<String, dynamic> source) {
    final phone = source['phone']?.toString();
    final roles = (source['roles'] as List?)
            ?.map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        const <String>[];
    return {
      'id': source['id'],
      'userId': source['id'],
      'username': source['username']?.toString(),
      'name': source['displayName']?.toString() ??
          source['username']?.toString() ??
          '',
      'email': source['email']?.toString(),
      'mobile': phone,
      'phone': phone,
      'gender': source['gender']?.toString(),
      'image_url': source['avatarUrl']?.toString(),
      'roles': roles,
      'permissions': const <String>[],
      'member_id': source['id']?.toString(),
    };
  }
}
