import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/features/auth/data/models/user_registration_model.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';

class RegisterRepo {
  final ApiConsumer api;

  RegisterRepo(this.api);

  Future<Either<String, Map<String, dynamic>>> registerUser(
      UserRegistrationModel user) async {
    try {
      final response = await api.post(
        EndPoints.register,
        data: user.toJson(),
      );
      final data = response is Response ? response.data : response;
      if (data is Map<String, dynamic>) {
        return Right(data);
      }
      return const Left('registration_failed');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to register: $e');
    }
  }

  Future<Either<String, OtpRequestResult>> requestRegisterOtp(
      String identifier) async {
    try {
      final response = await api.post(
        EndPoints.requestRegisterOtp,
        data: {'identifier': identifier},
      );
      final data = response is Response ? response.data : response;
      if (data is! Map<String, dynamic>) {
        return const Left('otp_request_failed');
      }
      final message = data['message']?.toString() ?? 'OTP sent successfully';
      final previewCode =
          data['previewCode']?.toString() ?? data['preview_code']?.toString();
      return Right(
        OtpRequestResult(message: message, previewCode: previewCode),
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to request OTP: $e');
    }
  }
}

class OtpRequestResult {
  final String message;
  final String? previewCode;

  const OtpRequestResult({required this.message, this.previewCode});
}
