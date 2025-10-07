import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../cart/views/dontation_cart_screen.dart';
import '../../profile/views/widgets/custom_field.dart';
import 'cubit/checkout_cubit.dart';
import 'cubit/checkout_state.dart';
import 'pay_confirmation_screen.dart';
import 'widgets/payment_method_selector.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutCubit()..init(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(),
        body: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            if (state is! CheckoutLoaded) return const SizedBox();
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Text(
                    "total".tr(context),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  DashedRRect(
                    radius: 14.r,
                    strokeWidth: 1.5,
                    dashWidth: 6,
                    dashGap: 4,
                    color: AppColors.primary,
                    child: Container(
                      constraints: BoxConstraints(minWidth: 148.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${state.totalAmount}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SvgPicture.asset(
                            "assets/images/svg/currancy.svg",
                            color: AppColors.textPrimary,
                            width: 15.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomFieldWithSvgLabel(
                    label: 'choose_payment_method'.tr(context),
                    svgAssetPath: "assets/images/svg/label.svg",
                    fieldWidget: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const PaymentMethodSelector(),
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
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        "bank_transfer_note".tr(context),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: AppButton(
                      backgroundColor: AppColors.textSecondary,
                      onPressed: () {
                        navigateTo(
                          context,
                          BlocProvider.value(
                            value: context.read<CheckoutCubit>(),
                            child: const PayConfirmationScreen(),
                          ),
                        );
                      },
                      text: "pay_now".tr(context),
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
