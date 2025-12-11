// features/payment/data/repo/payment_repo.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';

import '../models/payment_models.dart';

class PaymentRepo {
  final ApiConsumer api;
  PaymentRepo(this.api);

  Future<Either<String, PaymentOrderModel>> createOrder({
    required int branchId,
    required String totalAmount,
    required int quantity,
    required int serviceId,
    required String phone,
    String paymentWays = "credit_card",
    String paymentBrand = "SPAN",
    String orderType = "service",
  }) async {
    try {
      final formData = FormData.fromMap({
        'total_amount': totalAmount,
        'quantity': quantity.toString(),
        'service_id': serviceId.toString(),
        'phone': phone,
        'payment_ways': paymentWays,
        'payment_brand': paymentBrand,
        'order_type': orderType,
        'branch_id': branchId.toString(),
      });

      final Response res = await api.post(
        EndPoints.orderNow(branchId),
        data: formData,
      );

      final body = res.data;
      if (body is Map<String, dynamic> && body['data'] != null) {
        final data = body['data'];
        if (data is Map<String, dynamic> && data['order_id'] != null) {
          return Right(PaymentOrderModel.fromJson(data));
        }
      }
      return const Left('Invalid order creation response');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, PaymentResponseModel>> updateOrder({
    required int branchId,
    required String orderId,
    required String gatewayResponse,
  }) async {
    try {
      final Response res = await api.put(
        EndPoints.orderNow(branchId),
        data: {
          'order_id': orderId,
          'response': gatewayResponse,
        },
      );

      final body = res.data;
      if (body is Map<String, dynamic> && body['data'] != null) {
        final data = body['data'];
        return Right(PaymentResponseModel.fromJson(data));
      }
      return const Left('Invalid update order response');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, PaymentResponseModel>> sendInvoice({
    required int branchId,
    required String orderId,
    required String phone,
    required String name,
  }) async {
    try {
      final formData = FormData.fromMap({
        'order_id': orderId,
        'phone': phone,
        'name': name,
      });

      final Response res = await api.post(
        EndPoints.sendInvoice(branchId),
        data: formData,
      );

      final body = res.data;
      if (body is Map<String, dynamic> && body['status'] != null) {
        final status = body['status'];
        return Right(PaymentResponseModel.fromJson(status));
      }
      return const Left('Invalid invoice response');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
