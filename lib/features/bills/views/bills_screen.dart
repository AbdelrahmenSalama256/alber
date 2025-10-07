import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import '../../profile/views/widgets/donation_bill_card.dart';
import 'cubit/bills_cubit.dart';
import 'cubit/bills_state.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BillsCubit()..loadBills(),
      child: CustomScaffold(
        hasShape: false,
        appBar: CustomTopBar(
          onBack: () {
            context.read<GlobalCubit>().changeBottomNavIndex(2);
          },
        ),
        body: BlocBuilder<BillsCubit, BillsState>(
          builder: (context, state) {
            if (state is BillsLoading) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/nav/recipts.svg",
                            width: 30.w,
                          ),
                          SizedBox(width: 20.h),
                          Text(
                            "recipts".tr(context),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      SkeletonLoader(
                        width: double.infinity,
                        height: 160.h,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      SizedBox(height: 12.h),
                      SkeletonLoader(
                        width: double.infinity,
                        height: 160.h,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      SizedBox(height: 12.h),
                      SkeletonLoader(
                        width: double.infinity,
                        height: 160.h,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is BillsError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            if (state is BillsLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/nav/recipts.svg",
                            width: 30.w,
                          ),
                          SizedBox(width: 20.h),
                          Text(
                            "recipts".tr(context),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      ...List.generate(state.bills.length, (i) {
                        final b = state.bills[i];
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: i == state.bills.length - 1 ? 0 : 12.h),
                          child: DonationBillCard(
                            tagText: b.tagText,
                            code: b.code,
                            isBill: b.isBill,
                            isPayed: b.isPayed,
                            paymentType: b.paymentType,
                            serviceNum: b.serviceNum,
                            dateText: b.dateText,
                            timeText: b.timeText,
                            amountText: b.amountText,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
