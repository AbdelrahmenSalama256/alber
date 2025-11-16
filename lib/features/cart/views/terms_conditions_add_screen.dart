import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/core/services/auth_return.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/core/app/alber.dart';
import '../../checkout/views/checkout_screen.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import 'cubit/terms_cubit.dart';
import 'cubit/terms_state.dart';

class TermsConditionsAddScreen extends StatelessWidget {
  const TermsConditionsAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TermsCubit()..init(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(),
        body: BlocBuilder<TermsCubit, TermsState>(
          builder: (context, state) {
            if (state is TermsLoading) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SkeletonLoader(
                              width: 30.w,
                              height: 30.w,
                              borderRadius: BorderRadius.circular(15.r)),
                          SizedBox(width: 15.h),
                          SkeletonLoader(
                              width: 160.w,
                              height: 24.h,
                              borderRadius: BorderRadius.circular(6.r)),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      SkeletonLoader(
                          width: double.infinity,
                          height: 240.h,
                          borderRadius: BorderRadius.circular(12.r)),
                      SizedBox(height: 100.h),
                      SkeletonLoader(
                          width: double.infinity,
                          height: 52.h,
                          borderRadius: BorderRadius.circular(24.r)),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              );
            }
            if (state is! TermsLoaded) {
              return const SizedBox.shrink();
            }
            final s = state;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                "assets/images/svg/donation-cart.svg",
                                width: 30.w),
                            SizedBox(width: 15.h),
                            Text(
                              "donation_cart".tr(context),
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: AppColors.white.withOpacity(0.28),
                                    width: 1),
                              ),
                              child: Text(
                                s.terms,
                                style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 2.3),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
                if (s.showPayPanel)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 12.r,
                                      offset: Offset(0, -4.h),
                                      color: AppColors.black.withOpacity(0.2)),
                                ],
                                border: Border(
                                    top: BorderSide(
                                        color: AppColors.primary, width: 2.w)),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52.h,
                                    child: AppButton(
                                      backgroundColor: AppColors.textSecondary,
                                      onPressed: () {
                                        final token = sl<CacheHelper>()
                                            .getDataString(key: AppConstants.token);
                                        if (token == null || token.isEmpty) {
                                          showToast(
                                            context,
                                            message: 'login'.tr(context),
                                            state: ToastStates.warning,
                                          );
                                          sl<AuthReturnService>().setPendingAction(() {
                                            navigateTo(
                                              navigatorKey.currentContext!,
                                              const CheckoutScreen(),
                                            );
                                          });
                                          navigateTo(context, const PhoneConfirmScreen());
                                          return;
                                        }
                                        navigateTo(context, const CheckoutScreen());
                                      },
                                      text: "pay_now".tr(context),
                                      textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
