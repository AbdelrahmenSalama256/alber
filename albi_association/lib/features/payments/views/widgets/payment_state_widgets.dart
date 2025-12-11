import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_colors.dart';

/// 🟡 PAYMENT LOADING
class PaymentLoadingWidget extends StatelessWidget {
  final String amount;

  const PaymentLoadingWidget({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Animation
            Lottie.asset(
              'assets/images/animations/add-card.json',
              width: 30.w,
              height: 30.w,
            ),

            SizedBox(height: 4.h),

            // ✅ Title
            Text(
              'processing_payment'.tr(context),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isKiosk ? 18.sp : 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 1.h),

            // ✅ Subtext with currency
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '${"please_wait_payment".tr(context)} $amount',
                    style: TextStyle(
                      color: AppColors.primary.withOpacity(0.8),
                      fontSize: isKiosk ? 12.sp : 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 1.w),
                SvgPicture.asset(
                  "assets/images/svg/currancy.svg",
                  width: 3.w,
                  color: AppColors.primary.withOpacity(0.8),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // ✅ Progress Indicator
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🟣 PAYMENT PROCESSING
class PaymentProcessingWidget extends StatelessWidget {
  final String orderId;

  const PaymentProcessingWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Animation
            Lottie.asset(
              'assets/images/animations/add-card.json',
              width: 30.w,
              height: 30.w,
            ),
            SizedBox(height: 4.h),

            // ✅ Title
            Text(
              'order_created'.tr(context),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isKiosk ? 18.sp : 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 1.h),

            // ✅ Order Number
            Text(
              '${"order_number".tr(context)} $orderId',
              style: TextStyle(
                color: AppColors.primary.withOpacity(0.8),
                fontSize: isKiosk ? 12.sp : 14.sp,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // ✅ Processing Text
            Text(
              'processing_with_nearpay'.tr(context),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isKiosk ? 12.sp : 14.sp,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 10.h),

            // ✅ Progress Indicator
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🟢 PAYMENT SUCCESS
class PaymentSuccessWidget extends StatelessWidget {
  final String orderId;
  final String amount;
  final String? rrn;
  final VoidCallback onSendInvoice;
  final VoidCallback onReturnHome;

  const PaymentSuccessWidget({
    super.key,
    required this.orderId,
    required this.amount,
    this.rrn,
    required this.onSendInvoice,
    required this.onReturnHome,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ✅ Animation
          Lottie.asset(
            'assets/images/animations/success-pay.json',
            width: 30.w,
            height: 30.w,
          ),
          SizedBox(height: 4.h),

          // ✅ Title
          Text(
            'payment_successful'.tr(context),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: isKiosk ? 18.sp : 20.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),

          // ✅ Subtitle
          Text(
            'thank_you_donation'.tr(context),
            style: TextStyle(
              color: AppColors.primary.withOpacity(0.8),
              fontSize: isKiosk ? 12.sp : 14.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 5.h),

          // ✅ Info Cards (Same padding ratios)
          _infoCard(context, 'order_id'.tr(context), '#$orderId', isKiosk),
          if (rrn != null) ...[
            SizedBox(height: 1.5.h),
            _infoCard(context, 'reference'.tr(context), rrn!, isKiosk),
          ],
          SizedBox(height: 1.5.h),
          _infoCardCurrency(context, 'amount'.tr(context), amount, isKiosk),

          SizedBox(height: 10.h),

          // ✅ Buttons (matching PaymentFailedWidget style)
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                // AppButton(
                //   onPressed: onSendInvoice,
                //   text: 'send_receipt'.tr(context),
                //   backgroundColor: AppColors.primary,
                //   textStyle: TextStyle(
                //     color: AppColors.white,
                //     fontSize: 15.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(height: 3.w),
                AppButton(
                  onPressed: onReturnHome,
                  text: 'return_home'.tr(context),
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  textStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Info card (same dimensions)
  Widget _infoCard(
      BuildContext context, String label, String value, bool isKiosk) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(2.h),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.8),
                  fontSize: isKiosk ? 12.sp : 13.sp,
                )),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: isKiosk ? 12.sp : 13.sp,
                )),
          ),
        ],
      ),
    );
  }

  /// ✅ Info card with currency
  Widget _infoCardCurrency(
      BuildContext context, String label, String amount, bool isKiosk) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(2.h),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: AppColors.primary.withOpacity(0.8),
                  fontSize: isKiosk ? 12.sp : 13.sp)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(amount,
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: isKiosk ? 12.sp : 13.sp,
                      fontWeight: FontWeight.w600)),
              SizedBox(width: 1.w),
              SvgPicture.asset(
                "assets/images/svg/currancy.svg",
                width: 3.w,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🔴 PAYMENT FAILED
class PaymentFailedWidget extends StatelessWidget {
  final String error;
  final String? orderId;
  final VoidCallback onTryAgain;
  final VoidCallback onReturnHome;

  const PaymentFailedWidget({
    super.key,
    required this.error,
    this.orderId,
    required this.onTryAgain,
    required this.onReturnHome,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Lottie.asset(
            'assets/images/animations/fild-pay.json',
            width: 30.w,
            height: 30.w,
          ),
          SizedBox(height: 4.h),
          Text(
            'payment_failed'.tr(context),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: isKiosk ? 18.sp : 20.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              error,
              style: TextStyle(
                color: AppColors.primary.withOpacity(0.8),
                fontSize: isKiosk ? 12.sp : 14.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (orderId != null) ...[
            SizedBox(height: 1.h),
            Text(
              '${"order".tr(context)} $orderId',
              style: TextStyle(
                color: AppColors.primary.withOpacity(0.6),
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                AppButton(
                  onPressed: onTryAgain,
                  text: 'try_again'.tr(context),
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  textStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3.w),
                AppButton(
                  onPressed: onReturnHome,
                  text: 'return_home'.tr(context),
                  backgroundColor: AppColors.primary,
                  textStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
