import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/profile_cubit.dart';
import './cubit/profile_state.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileCubit>(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SkeletonLoader(
                              width: 24.w,
                              height: 24.w,
                              borderRadius: BorderRadius.circular(12.r)),
                          SizedBox(width: 20.h),
                          SkeletonLoader(
                              width: 180.w,
                              height: 24.h,
                              borderRadius: BorderRadius.circular(8.r)),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      SkeletonLoader(
                          width: double.infinity,
                          height: 260.h,
                          borderRadius: BorderRadius.circular(12.r)),
                    ],
                  ),
                ),
              );
            }
            if (state is! ProfileLoaded) {
              return const SizedBox.shrink();
            }
            final s = state;
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
                        SvgPicture.asset("assets/images/svg/lock.svg",
                            width: 25.w, height: 25.w),
                        SizedBox(width: 15.w),
                        Text(
                          "privacy_policy".tr(context),
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
                            s.privacyText,
                            style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                height: 2.3),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
