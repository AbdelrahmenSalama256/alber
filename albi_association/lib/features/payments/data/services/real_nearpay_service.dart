import 'package:nearpay_flutter_sdk/nearpay.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:uuid/uuid.dart';

import 'nearpay_handler.dart';

class NearPayService {
  static NearPayService? _instance;

  NearPayService._();
  static NearPayService get instance => _instance ??= NearPayService._();

  late Nearpay nearPay;
  final NearPayHandler _nearPayHandler = NearPayHandler.instance;

  Future<dynamic> initSDK() async {
    try {
      PrintUtil.success('🚀 Initializing NearPay SDK...');

      nearPay = Nearpay(
        authType: _nearPayHandler.authType,
        authValue: _nearPayHandler.authValue,
        env: _nearPayHandler.env,
        locale: Locale.localeDefault,
      );

      final initializeResult = await nearPay.initialize();
      PrintUtil.warning('NearPay Initialize Result: $initializeResult');

      final setupResult = await nearPay.setup();
      PrintUtil.success('✅ NearPay Setup Result: $setupResult');

      return setupResult;
    } catch (error) {
      PrintUtil.error('❌ NearPay Initialization Error: $error');
      return "error: $error";
    }
  }

  Future<dynamic> purchase({
    required int amount,
  }) async {
    try {
      PrintUtil.success('💳 Starting NearPay purchase: $amount SAR');

      final transactionData = await nearPay.purchase(
        amount: amount * 100, // Convert to minor units
        customerReferenceNumber: '',
        transactionId: const Uuid().v4(),
        enableReceiptUi: _nearPayHandler.enableReceiptUi,
        enableReversalUi: true,
        enableUiDismiss: true,
        finishTimeout: _nearPayHandler.timeOut,
      );

      PrintUtil.warning('📋 Purchase Response: ${transactionData.toJson()}');

      return transactionData;
    } catch (error) {
      PrintUtil.error('❌ NearPay Purchase Error: $error');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await nearPay.logout();
      PrintUtil.warning('🔒 NearPay logged out');
    } catch (error) {
      PrintUtil.error('❌ NearPay Logout Error: $error');
    }
  }
}
