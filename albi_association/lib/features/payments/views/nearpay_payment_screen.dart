// features/payment/views/screens/nearpay_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/home/view/widgets/counter_wrapper_main.dart';
import 'package:sizer/sizer.dart';

import '../../home/view/widgets/custom_top_bar.dart';
import 'cubit/payment_cubit.dart';
import 'cubit/payment_state.dart';
import 'widgets/payment_state_widgets.dart';

class NearpayPaymentScreen extends StatefulWidget {
  final String amount;
  final int quantity;
  final int serviceId;
  final String title;
  final String? imageUrl;

  const NearpayPaymentScreen({
    super.key,
    required this.amount,
    required this.quantity,
    required this.serviceId,
    required this.title,
    this.imageUrl,
  });

  @override
  State<NearpayPaymentScreen> createState() => _NearpayPaymentScreenState();
}

class _NearpayPaymentScreenState extends State<NearpayPaymentScreen> {
  @override
  void initState() {
    super.initState();
    PrintUtil.success('NearPay Payment Screen Initialized');
  }

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    return CounterWrapperMain(
      child: CustomScaffold(
        body: BlocProvider(
          create: (context) => PaymentCubit(),
          child: BlocConsumer<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is PaymentSuccess) {
                _showSuccessDialog(context, state);
              } else if (state is PaymentFailed) {
                _showErrorDialog(
                  context,
                  state.error.tr(context),
                  state.orderId,
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  CustomTopBar(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isKiosk ? 10.w : 5.w,
                        vertical: isKiosk ? 6.h : 2.h,
                      ),
                      child: _buildContent(context, state, isKiosk),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaymentState state, bool isKiosk) {
    return Column(
      children: [
        Expanded(child: _buildStateContent(context, state, isKiosk)),
      ],
    );
  }

  Widget _buildStateContent(
      BuildContext context, PaymentState state, bool isKiosk) {
    if (state is PaymentLoading) {
      return PaymentLoadingWidget(amount: widget.amount);
    } else if (state is PaymentOrderCreated) {
      return PaymentProcessingWidget(orderId: state.orderId);
    } else if (state is PaymentSuccess) {
      return PaymentSuccessWidget(
        orderId: state.orderId,
        amount: widget.amount,
        rrn: state.rrn,
        onSendInvoice: () => _sendInvoice(context, state.orderId),
        onReturnHome: () => _returnToHome(context),
      );
    } else if (state is PaymentFailed) {
      return PaymentFailedWidget(
        error: state.error.tr(context),
        orderId: state.orderId,
        onTryAgain: () => _retryPayment(context, state.orderId),
        onReturnHome: () => _returnToHome(context),
      );
    } else if (state is PaymentError) {
      return PaymentFailedWidget(
        error: state.error.tr(context),
        orderId: null,
        onTryAgain: () => _processPayment(context),
        onReturnHome: () => _returnToHome(context),
      );
    } else {
      return _buildInitialState(context, isKiosk);
    }
  }

  void _retryPayment(BuildContext context, String? orderId) {
    final paymentCubit = context.read<PaymentCubit>();
    if (orderId != null) {
      paymentCubit.retryPaymentWithOrder(
        orderId: orderId,
        amount: widget.amount,
      );
    } else {
      _processPayment(context);
    }
  }

  Widget _buildInitialState(BuildContext context, bool isKiosk) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isKiosk ? 4.h : 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Service Image ---
            widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(isKiosk ? 3.h : 2.h),
                    child: Image.network(
                      widget.imageUrl!,
                      width: isKiosk ? 25.w : 60.w,
                      height: isKiosk ? 25.w : 60.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) =>
                          _buildPaymentGraphic(isKiosk),
                    ),
                  )
                : _buildPaymentGraphic(isKiosk),

            SizedBox(height: isKiosk ? 5.h : 3.h),

            // --- Payment Info ---
            _buildPaymentInfo(isKiosk),

            SizedBox(height: isKiosk ? 5.h : 3.h),

            // --- Pay Button ---
            _buildPayButton(context, isKiosk),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentGraphic(bool isKiosk) {
    return Container(
      width: isKiosk ? 25.w : 60.w,
      height: isKiosk ? 25.w : 60.w,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(isKiosk ? 2.h : 1.5.h),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card,
            size: isKiosk ? 10.w : 30.w,
            color: Colors.grey[600],
          ),
          SizedBox(height: isKiosk ? 1.5.h : 1.h),
          Text(
            'NearPay',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isKiosk ? 14.sp : 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(bool isKiosk) {
    return Container(
      width: isKiosk ? 45.w : double.infinity,
      padding: EdgeInsets.all(isKiosk ? 3.w : 5.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(isKiosk ? 2.h : 1.5.h),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Text(
            'you_are_donating'.tr(context),
            style: TextStyle(
              color: Colors.black,
              fontSize: isKiosk ? 15.sp : 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: isKiosk ? 17.sp : 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 2.h),
          Text(
            'total_amount'.tr(context),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isKiosk ? 13.sp : 12.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.amount,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isKiosk ? 20.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 2.w),
              SvgPicture.asset(
                "assets/images/svg/currancy.svg",
                color: AppColors.primary,
                width: isKiosk ? 4.w : 5.w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, bool isKiosk) {
    return SizedBox(
      width: isKiosk ? 35.w : 80.w,
      height: isKiosk ? 7.h : 6.h,
      child: AppButton(
        onPressed: () => _processPayment(context),
        suffixIcon: SvgPicture.asset(
          "assets/images/svg/currancy.svg",
          width: isKiosk ? 3.w : 5.w,
        ),
        text: '${"pay_button".tr(context)} ${widget.amount}',
        textStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) {
    final paymentCubit = context.read<PaymentCubit>();
    final donorName =
        sl<CacheHelper>().getDataString(key: AppConstants.donorName);

    paymentCubit.processPayment(
      amount: widget.amount,
      quantity: widget.quantity,
      serviceId: widget.serviceId,
      donorName: donorName,
      sendInvoice: true,
    );
  }

  void _sendInvoice(BuildContext context, String orderId) {
    final phone =
        sl<CacheHelper>().getDataString(key: AppConstants.donorPhone) ??
            sl<CacheHelper>().getDataString(key: AppConstants.loginPhone);
    final donorName =
        sl<CacheHelper>().getDataString(key: AppConstants.donorName);

    if (phone != null && donorName != null) {
      PrintUtil.success('Sending invoice for order: $orderId');
    }
  }

  void _returnToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _showSuccessDialog(BuildContext context, PaymentSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final bool isKiosk = 100.w > 80.h;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isKiosk ? 3.h : 2.h)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/images/animations/success-pay.json",
                    width: isKiosk ? 20.w : 60.w),
                SizedBox(height: 2.h),
                Text(
                  'payment_successful'.tr(context),
                  style: TextStyle(
                    fontSize: isKiosk ? 16.sp : 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "order_number".tr(context) + state.orderId,
                  style: TextStyle(
                    fontSize: isKiosk ? 12.sp : 10.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'continue'.tr(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String error, String? orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('payment_failed'.tr(context)),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr(context)),
          ),
        ],
      ),
    );
  }
}
