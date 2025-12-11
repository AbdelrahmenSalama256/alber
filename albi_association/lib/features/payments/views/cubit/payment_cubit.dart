import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';

import '../../data/models/payment_models.dart';
import '../../data/repo/payment_repo.dart';
import '../../data/services/real_nearpay_service.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo _repo;
  final NearPayService _nearPayService;

  PaymentCubit()
      : _repo = sl<PaymentRepo>(),
        _nearPayService = NearPayService.instance,
        super(PaymentInitial());

  Future<void> processPayment({
    required String amount,
    required int quantity,
    required int serviceId,
    String? donorName,
    bool sendInvoice = false,
  }) async {
    emit(PaymentLoading());

    try {
      // Get required data from cache
      final branchId =
          sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId);
      final phone =
          sl<CacheHelper>().getDataString(key: AppConstants.donorPhone) ??
              sl<CacheHelper>().getDataString(key: AppConstants.loginPhone);

      if (branchId == null || phone == null) {
        emit(PaymentError("missing_branch_or_phone"));
        return;
      }

      final int branchIdInt = int.parse(branchId);

      // Step 1: Create order
      final orderResult = await _repo.createOrder(
        branchId: branchIdInt,
        totalAmount: amount,
        quantity: quantity,
        serviceId: serviceId,
        phone: phone,
      );

      orderResult.fold(
        (error) => emit(PaymentError("order_creation_failed")),
        (orderModel) async {
          final orderId = orderModel.orderId.toString();
          emit(PaymentOrderCreated(orderId: orderId));

          PrintUtil.success('📋 Order Created: $orderId');

          // Step 2: Process real NearPay payment
          await _processRealNearPayPayment(amount, orderId, branchIdInt);
        },
      );
    } catch (e) {
      PrintUtil.error('❌ Payment processing error: $e');
      emit(PaymentError("payment_processing_failed"));
    }
  }

  Future<void> _processRealNearPayPayment(
      String amount, String orderId, int branchId) async {
    try {
      PrintUtil.success('💳 Starting Real NearPay Payment...');

      // Convert amount to integer for NearPay
      final amountInt = (double.parse(amount)).toInt();

      PrintUtil.warning('💰 Amount: $amountInt SAR');

      // Initialize NearPay SDK
      final initResult = await _nearPayService.initSDK();

      if (initResult.toString().contains('error')) {
        PrintUtil.error('❌ NearPay SDK initialization failed');
        emit(PaymentFailed(
          error: "terminal_initialization_failed",
          orderId: orderId,
        ));
        return;
      }

      PrintUtil.success('✅ NearPay SDK initialized');

      // Execute real purchase
      final transactionData = await _nearPayService.purchase(amount: amountInt);

      // Process the transaction response
      await _handleTransactionResponse(transactionData, orderId, branchId);
    } catch (e) {
      PrintUtil.error('❌ NearPay payment error: $e');
      emit(PaymentFailed(
        error: "payment_processing_error",
        orderId: orderId,
      ));
    }
  }

  Future<void> _handleTransactionResponse(
      dynamic transactionData, String orderId, int branchId) async {
    try {
      // Print full response for debugging
      PrintUtil.warning('📋 Transaction Response: ${transactionData.toJson()}');

      // Extract status from transaction data
      final status = _extractTransactionStatus(transactionData);
      final receipts = transactionData.receipts;

      PrintUtil.warning('🔄 Transaction Status: $status');
      PrintUtil.warning('📄 Receipts count: ${receipts?.length ?? 0}');

      if (status == 'success' && receipts != null && receipts.isNotEmpty) {
        final receipt = receipts.last;
        final rrn = _extractRRN(receipt);
        final transactionId = _extractTransactionId(receipt);

        PrintUtil.success('✅ NearPay transaction approved: $transactionId');

        // Update order with success response
        final updateResult = await _updateOrderWithResponse(
          orderId: orderId,
          isApproved: true,
          rrn: rrn ??
              transactionId ??
              'NPR${DateTime.now().millisecondsSinceEpoch}',
          actionCode: '000',
        );

        updateResult.fold(
          (error) {
            PrintUtil.error('❌ Order update failed: $error');
            emit(PaymentError("order_update_failed"));
          },
          (success) {
            PrintUtil.success('✅ Order updated successfully');
            emit(PaymentSuccess(
              orderId: orderId,
              rrn: rrn ?? transactionId,
              message: "payment_completed_successfully",
            ));
          },
        );
      } else {
        // Payment failed
        final errorMessage = _extractErrorMessage(transactionData);
        PrintUtil.error('❌ NearPay transaction failed: $errorMessage');

        // Update order with failure response
        final updateResult = await _updateOrderWithResponse(
          orderId: orderId,
          isApproved: false,
          rrn: null,
          actionCode: _mapStatusToActionCode(status),
        );

        updateResult.fold(
          (error) => PrintUtil.error('❌ Failed to update order: $error'),
          (success) =>
              PrintUtil.warning('📝 Order updated with failure status'),
        );

        emit(PaymentFailed(
          error: errorMessage ?? '',
          orderId: orderId,
        ));
      }
    } catch (e) {
      PrintUtil.error('❌ Transaction handling error: $e');
      emit(PaymentFailed(
        error: "transaction_processing_error",
        orderId: orderId,
      ));
    }
  }

  String _extractTransactionStatus(dynamic transactionData) {
    final json = transactionData.toJson();
    PrintUtil.warning('🔍 Transaction JSON: $json');

    // Try common status property names
    if (json['status'] != null) return json['status'].toString();
    if (json['state'] != null) return json['state'].toString();
    if (json['result'] != null) return json['result'].toString();

    // Check message for status indicators
    final message = _extractErrorMessage(transactionData);
    if (message?.toLowerCase().contains('success') == true) return 'success';
    if (message?.toLowerCase().contains('fail') == true) return 'failed';
    if (message?.toLowerCase().contains('decline') == true) return 'declined';

    return 'unknown';
  }

  String? _extractErrorMessage(dynamic transactionData) {
    final json = transactionData.toJson();
    if (json['message'] != null) return json['message'].toString();
    if (json['error'] != null) return json['error'].toString();
    if (json['description'] != null) return json['description'].toString();
    return null;
  }

  String? _extractRRN(dynamic receipt) {
    final json = receipt.toJson();
    PrintUtil.warning('🔍 Receipt JSON for RRN: $json');

    if (json['rrn'] != null) return json['rrn'].toString();
    if (json['reference_number'] != null) {
      return json['reference_number'].toString();
    }
    if (json['transaction_reference'] != null) {
      return json['transaction_reference'].toString();
    }
    if (json['id'] != null) return json['id'].toString();

    return null;
  }

  String? _extractTransactionId(dynamic receipt) {
    final json = receipt.toJson();
    if (json['transaction_id'] != null) {
      return json['transaction_id'].toString();
    }
    if (json['id'] != null) return json['id'].toString();
    if (json['uuid'] != null) return json['uuid'].toString();
    if (json['transaction_uuid'] != null) {
      return json['transaction_uuid'].toString();
    }

    return null;
  }

  String _mapStatusToActionCode(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return '000';
      case 'failed':
        return '101';
      case 'declined':
        return '105';
      case 'cancelled':
        return '999';
      case 'timeout':
        return '408';
      default:
        return '777';
    }
  }

  Future<Either<String, PaymentResponseModel>> _updateOrderWithResponse({
    required String orderId,
    required bool isApproved,
    required String? rrn,
    required String actionCode,
  }) async {
    try {
      final branchId =
          sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId);
      if (branchId == null) {
        return Left("branch_not_found");
      }

      final branchIdInt = int.parse(branchId);

      final gatewayResponse = {
        "is_approved": isApproved,
        "action_code": actionCode,
        "rrn": rrn,
        "timestamp": DateTime.now().toIso8601String(),
        "message": isApproved ? "transaction_approved" : "transaction_declined"
      };

      PrintUtil.warning('📤 Updating order with response: $gatewayResponse');

      return await _repo.updateOrder(
        branchId: branchIdInt,
        orderId: orderId,
        gatewayResponse: jsonEncode(gatewayResponse),
      );
    } catch (e) {
      PrintUtil.error('❌ Update order error: $e');
      return Left("update_order_error");
    }
  }

  Future<void> retryPaymentWithOrder({
    required String orderId,
    required String amount,
  }) async {
    emit(PaymentLoading());

    try {
      PrintUtil.warning('🔄 Retrying payment for order: $orderId');

      final branchId =
          sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId);
      if (branchId == null) {
        emit(PaymentError("branch_not_found"));
        return;
      }

      final branchIdInt = int.parse(branchId);
      await _processRealNearPayPayment(amount, orderId, branchIdInt);
    } catch (e) {
      PrintUtil.error('❌ Retry failed: $e');
      emit(PaymentError("retry_failed"));
    }
  }

  void resetPayment() {
    emit(PaymentInitial());
  }
}
