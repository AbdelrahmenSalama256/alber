import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';

import '../../../core/constants/app_colors.dart';
import '../../cart/views/dontation_cart_screen.dart';

class PayedSuccessScreen extends StatelessWidget {
  const PayedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasShape: true,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/png/success.png",
                width: 179.w,
                height: 179.h,
              ),
              SizedBox(height: 15.h),
              Text(
                "payment_success".tr(context),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              DashedRRect(
                radius: 14.r,
                strokeWidth: 1.5,
                dashWidth: 6,
                dashGap: 4,
                color: AppColors.primary,
                child: Container(
                  constraints: BoxConstraints(minWidth: 148.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text(
                    "redirect_to_invoices".tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
