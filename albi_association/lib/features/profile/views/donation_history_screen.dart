import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/profile_cubit.dart';
import './cubit/profile_state.dart';
import 'widgets/donation_bill_card.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/donation-history.svg",
                            width: 20.w,
                          ),
                          SizedBox(width: 15.h),
                          Text(
                            "donation_history".tr(context),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      ...List.generate(
                          5,
                          (i) => Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: SkeletonLoader(
                                    width: double.infinity,
                                    height: 110.h,
                                    borderRadius: BorderRadius.circular(12)),
                              )),
                    ],
                  ),
                ),
              );
            }
            final s = state as ProfileLoaded;
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
                        SvgPicture.asset(
                          "assets/images/svg/donation-history.svg",
                          width: 20.w,
                        ),
                        SizedBox(width: 15.h),
                        Text(
                          "donation_history".tr(context),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    ...s.donationHistory.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: DonationBillCard(
                            tagText: e['tag']!,
                            code: e['code']!,
                            dateText: e['date']!,
                            timeText: e['time']!,
                            amountText: e['amount']!,
                          ),
                        )),
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
