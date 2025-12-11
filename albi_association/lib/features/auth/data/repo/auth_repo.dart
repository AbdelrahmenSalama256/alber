import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/notification/notification_handler.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/data/models/otp_confirm_response.dart';

import '../../../../core/constants/app_constant.dart';

class AuthRepo {
  final ApiConsumer api;
  AuthRepo(this.api);

  Future<Either<String, Unit>> loginUser({required String phone}) async {
    try {
      String? fcm;
      try {
        if (firebase_core.Firebase.apps.isNotEmpty) {
          fcm = await NotificationHandler.getToken();
        }
      } catch (_) {
        fcm = null;
      }
      final Response res = await api.post(
        EndPoints.login,
        data: {
          ApiKey.phone: phone,
          if (fcm != null && fcm.isNotEmpty) 'fcm_token': fcm,
        },
      );
      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300) {
        return const Right(unit);
      }
      return const Left('Failed to request OTP');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, OtpConfirmData>> confirmOtp({
    String? phone,
    required String code,
  }) async {
    try {
      final cachedPhone =
          sl<CacheHelper>().getDataString(key: AppConstants.loginPhone);
      final effectivePhone =
          (phone != null && phone.isNotEmpty) ? phone : (cachedPhone ?? "");
      final Response res = await api.post(
        EndPoints.confirmOtp(phone: effectivePhone),
        data: {"otp_code": code},
      );

      final Map<String, dynamic> body = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      final parsed = OtpConfirmResponse.fromJson(body);
      final payload = parsed.data ?? OtpConfirmData();

      final token = payload.token;
      if (token != null && token.isNotEmpty) {
        await sl<CacheHelper>().setData(ApiKey.token, token);
      }
      return Right(payload);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> resendOtp({required String phone}) async {
    try {
      final Response res = await api.post(
        EndPoints.resendOtp(),
        data: {ApiKey.phone: phone},
      );
      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300) {
        return const Right(unit);
      }
      return const Left('Failed to resend OTP');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> logout() async {
    try {
      final Response res = await api.post(EndPoints.userLogout);
      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300) {
        await sl<CacheHelper>().removeData(key: ApiKey.token);
        return const Right(unit);
      }
      return const Left('Logout failed');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
