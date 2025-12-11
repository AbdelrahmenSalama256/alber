import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/dedicate_donation/views/send_dedication_donation_screen.dart';
import 'package:qafeel/features/dedicate_donation/views/widgets/donation_type_card.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/cubit/global_cubit.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/dedicate_donation_cubit.dart';
import './cubit/dedicate_donation_state.dart';

class DedicateDonationScreen extends StatelessWidget {
  const DedicateDonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DedicateDonationCubit()..init(),
      child: CustomScaffold(
        hasShape: false,
        appBar: CustomTopBar(
          onBack: () {
            context.read<GlobalCubit>().changeBottomNavIndex(2);
          },
        ),
        body: BlocBuilder<DedicateDonationCubit, DedicateDonationState>(
          builder: (context, state) {
            if (state is DedicateDonationLoading) {
              return _loadingSkeleton(context);
            }
            if (state is! DedicateDonationLoaded) return const SizedBox();
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/nav/donation.svg",
                            width: 25.w,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "donation".tr(context),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "gift_service_description".tr(context),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      _sectionTitle(context, "select_gift_type".tr(context)),
                      SizedBox(height: 20.h),
                      _grid(
                          context, state.donationTypes, state.selectedTypeIndex,
                          (i) {
                        context.read<DedicateDonationCubit>().selectType(i);
                      }),
                      SizedBox(height: 20.h),
                      _sectionTitle(context, "select_gift_field".tr(context)),
                      SizedBox(height: 20.h),
                      _grid(context, state.donationTypes,
                          state.selectedFieldIndex, (i) {
                        context.read<DedicateDonationCubit>().selectField(i);
                      }),
                      SizedBox(height: 200.h),
                    ],
                  ),
                ),
                if (state.showNextButton)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12,
                                    offset: Offset(0, -4.h),
                                    color: AppColors.black.withOpacity(0.2),
                                  ),
                                ],
                                border: Border(
                                  top: BorderSide(
                                      color: AppColors.primary, width: 2.w),
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52.h,
                                    child: AppButton(
                                      onPressed: () {
                                        navigateTo(
                                          context,
                                          BlocProvider.value(
                                            value: context
                                                .read<DedicateDonationCubit>(),
                                            child:
                                                const SendDedicationDonationScreen(),
                                          ),
                                        );
                                      },
                                      text: "enter_recipient_data".tr(context),
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
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

  Widget _sectionTitle(BuildContext context, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          constraints: BoxConstraints(minWidth: 148.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xfffafafa).withOpacity(0.5),
            border: Border(
              bottom: BorderSide(color: AppColors.primary, width: 1.w),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, List<Map<String, String>> items,
      int selected, ValueChanged<int> onTap) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return DonationTypeCard(
          imagePath: item["icon"]!,
          title: item["title"]!,
          isSelected: selected == index,
          onTap: () => onTap(index),
        );
      },
    );
  }

  Widget _loadingSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonLoader(
                  width: 25.w,
                  height: 25.w,
                  borderRadius: BorderRadius.circular(12)),
              SizedBox(width: 10.w),
              SkeletonLoader(
                  width: 160.w,
                  height: 22.h,
                  borderRadius: BorderRadius.circular(6)),
            ],
          ),
          SizedBox(height: 20.h),
          SkeletonLoader(
              width: double.infinity,
              height: 60.h,
              borderRadius: BorderRadius.circular(12)),
          SizedBox(height: 24.h),
          SkeletonLoader(
              width: 140.w,
              height: 20.h,
              borderRadius: BorderRadius.circular(6)),
          SizedBox(height: 12.h),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemBuilder: (_, __) => SkeletonLoader(
              width: double.infinity,
              height: 90.h,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 20.h),
          SkeletonLoader(
              width: 140.w,
              height: 20.h,
              borderRadius: BorderRadius.circular(6)),
          SizedBox(height: 12.h),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemBuilder: (_, __) => SkeletonLoader(
              width: double.infinity,
              height: 90.h,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 120.h),
          Center(
            child: SkeletonLoader(
                width: 220.w,
                height: 52.h,
                borderRadius: BorderRadius.circular(14)),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
