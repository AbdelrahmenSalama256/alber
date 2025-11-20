import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';

class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  Future<Either<String, ContactResponse>> loginUser({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await api.post(
        EndPoints.login,
        data: {
          'identifier': identifier,
          'password': password,
        },
      );

      final dioResponse = response is Response ? response : null;
      final payload = response is Response ? response.data : response;
      if (payload is! Map<String, dynamic>) {
        return const Left('login_failed');
      }

      final hasToken =
          payload['access_token'] != null || payload['token'] != null;
      final hasData = payload['data'] != null;
      if (!hasToken && !hasData) {
        final message = payload['message']?.toString();
        if (_requiresVerification(message, dioResponse?.statusCode)) {
          return const Left('account_not_verified');
        }
        return Left(message ?? 'login_failed');
      }

      final normalized = _normalizeContactPayload(payload);
      return Right(ContactResponse.fromJson(normalized));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
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

  Future<Either<String, ContactResponse>> verifyLoginOtp({
    required String identifier,
    required String code,
  }) async {
    try {
      final response = await api.post(
        EndPoints.verifyLoginOtp,
        data: {
          'identifier': identifier,
          'code': code,
        },
      );

      final payload = response is Response ? response.data : response;
      if (payload is! Map<String, dynamic>) {
        return const Left('otp_verification_failed');
      }

      final token = _extractToken(payload);
      if (token == null || token.isEmpty) {
        return Left('otp_verification_failed');
      }

      await sl<CacheHelper>().setData(AppConstants.token, token);
      final user = await _fetchProfileUser();

      final normalized = {
        'data': {
          'token': token,
          'user': user,
        }
      };
      return Right(ContactResponse.fromJson(normalized));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to verify OTP: $e');
    }
  }

  String? _extractToken(Map<String, dynamic> payload) {
    final dynamic candidate = payload['access_token'] ??
        payload['token'] ??
        (payload['data'] is Map ? payload['data']['token'] : null);
    if (candidate == null) return null;
    return candidate.toString();
  }

  Map<String, dynamic> _normalizeContactPayload(Map<String, dynamic> payload) {
    final dataNode = _extractDataNode(payload);
    final token =
        dataNode['token'] ?? dataNode['access_token'] ?? payload['token'];

    Map<String, dynamic> user = {};
    for (final key in const ['user', 'contact', 'customer', 'profile']) {
      final candidate = dataNode[key];
      if (candidate is Map<String, dynamic>) {
        user = candidate;
        break;
      }
    }

    if (user.isEmpty && _looksLikeUserMap(dataNode)) {
      user = Map<String, dynamic>.from(dataNode)
        ..removeWhere(
          (key, value) =>
              key == 'token' ||
              key == 'access_token' ||
              key == 'user' ||
              key == 'contact' ||
              key == 'customer' ||
              key == 'profile',
        );
    }

    return {
      'data': {
        'token': token?.toString(),
        'user': user,
      }
    };
  }

  Map<String, dynamic> _extractDataNode(Map<String, dynamic> payload) {
    final dataNode = payload['data'];
    if (dataNode is Map<String, dynamic>) {
      return Map<String, dynamic>.from(dataNode);
    }
    if (dataNode is List && dataNode.isNotEmpty) {
      final first = dataNode.first;
      if (first is Map<String, dynamic>) {
        return Map<String, dynamic>.from(first);
      }
    }
    return Map<String, dynamic>.from(payload);
  }

  bool _looksLikeUserMap(Map<String, dynamic> data) {
    const indicativeKeys = {'id', 'name', 'email', 'mobile', 'phone'};
    return data.keys.any(indicativeKeys.contains);
  }

  bool _requiresVerification(String? message, int? statusCode) {
    if (statusCode == 403) return true;
    final lower = message?.toLowerCase() ?? '';
    return lower.contains('verify') ||
        lower.contains('verification') ||
        lower.contains('otp');
  }

  Future<Map<String, dynamic>> _fetchProfileUser() async {
    try {
      final response = await api.get(EndPoints.getProfile);
      final payload = response is Response ? response.data : response;
      if (payload is! Map<String, dynamic>) return {};
      final dataNode = _extractDataNode(payload);
      for (final key in const ['user', 'contact', 'customer', 'profile']) {
        final candidate = dataNode[key];
        if (candidate is Map<String, dynamic>) {
          return _mapProfileUser(Map<String, dynamic>.from(candidate));
        }
      }
      if (_looksLikeUserMap(dataNode)) {
        return _mapProfileUser(Map<String, dynamic>.from(dataNode));
      }
    } catch (_) {}
    return {};
  }

  Map<String, dynamic> _mapProfileUser(Map<String, dynamic> source) {
    final phone =
        source['phone']?.toString() ?? source['mobile']?.toString() ?? '';
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
          source['name']?.toString() ??
          source['username']?.toString() ??
          '',
      'email': source['email']?.toString(),
      'mobile': phone,
      'phone': phone,
      'image_url': source['avatarUrl']?.toString() ??
          source['image_url']?.toString() ??
          source['avatar']?.toString(),
      'roles': roles,
      'permissions': const <String>[],
      'member_id': source['id']?.toString(),
    };
  }
}
