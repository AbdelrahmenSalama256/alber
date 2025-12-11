// features/payment/data/models/payment_models.dart

import 'dart:convert';

class PaymentOrderModel {
  final int orderId;

  PaymentOrderModel({required this.orderId});

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderModel(
      orderId: json['order_id'] as int,
    );
  }
}

class PaymentResponseModel {
  final String message;

  PaymentResponseModel({required this.message});

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      message: json['message']?.toString() ?? 'Success',
    );
  }
}

class GatewayResponse {
  final bool isApproved;
  final String actionCode;
  final String? rrn;
  final String? failReason;
  final Map<String, dynamic>? rawData;

  GatewayResponse({
    required this.isApproved,
    required this.actionCode,
    this.rrn,
    this.failReason,
    this.rawData,
  });

  String toJsonString() {
    final map = {
      'is_approved': isApproved,
      'action_code': actionCode,
      'rrn': rrn,
      'fail_reason': failReason,
      ...?rawData,
    };
    return jsonEncode(map);
  }

  factory GatewayResponse.fromNearPay(Map<String, dynamic> json) {
    return GatewayResponse(
      isApproved: json['is_approved'] == true,
      actionCode: json['action_code']?.toString() ?? '777',
      rrn: json['rrn']?.toString(),
      failReason: json['fail_reason']?.toString(),
      rawData: json,
    );
  }

  factory GatewayResponse.fromTerminal(Map<String, dynamic> eventMap) {
    final flag = eventMap['flag']?.toString() ?? '1';
    return GatewayResponse(
      isApproved: flag == '0',
      actionCode: eventMap['responseCode']?.toString() ??
          eventMap['action_code']?.toString() ??
          (flag == '0' ? '000' : '777'),
      rrn: eventMap['rrn']?.toString(),
      failReason: eventMap['response']?.toString() ??
          eventMap['fail_reason']?.toString(),
      rawData: eventMap,
    );
  }
}
