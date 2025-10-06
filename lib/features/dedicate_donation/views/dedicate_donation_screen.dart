import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/dedicate_donation/views/send_dedication_donation_screen.dart';
import 'package:qafeel/features/dedicate_donation/views/widgets/donation_type_card.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/cubit/global_cubit.dart';

class DedicateDonationScreen extends StatefulWidget {
  const DedicateDonationScreen({super.key});

  @override
  State<DedicateDonationScreen> createState() => _DedicateDonationScreenState();
}

class _DedicateDonationScreenState extends State<DedicateDonationScreen> {
  int selectedIndex = -1;
  bool _showNextButton = false;

  final List<Map<String, String>> donationTypes = [
    {"title": "تبرع بالمال", "icon": "assets/images/svg/testdonation.svg"},
    {"title": "تبرع بالدم", "icon": "assets/images/svg/testdonation.svg"},
    {"title": "تبرع بالطعام", "icon": "assets/images/svg/testdonation.svg"},
    {"title": "تبرع بالملابس", "icon": "assets/images/svg/testdonation.svg"},
    {"title": "تبرع بالأدوية", "icon": "assets/images/svg/testdonation.svg"},
    {"title": "تبرع بالماء", "icon": "assets/images/svg/testdonation.svg"},
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showNextButton = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasShape: false,
      appBar: CustomTopBar(
        onBack: () {
          context.read<GlobalCubit>().changeBottomNavIndex(2);
        },
      ),
      body: Stack(
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
                buildSectionTitle("select_gift_type".tr(context)),
                SizedBox(height: 20.h),
                _buildGrid(),
                SizedBox(height: 20.h),
                buildSectionTitle("select_gift_field".tr(context)),
                SizedBox(height: 20.h),
                _buildGrid(),
                SizedBox(height: 200.h),
              ],
            ),
          ),

          if (_showNextButton)
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
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12.r,
                              offset: Offset(0, -4.h),
                              color: AppColors.black.withOpacity(0.2),
                            ),
                          ],
                          border: Border(
                            top: BorderSide(
                                color: AppColors.primary, width: 2.w),
                          ),
                          borderRadius: BorderRadius.circular(24.r),
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
                                      context, SendDedicationDonationScreen());
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
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 148.w,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
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

  Widget _buildGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: donationTypes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemBuilder: (context, index) {
        final item = donationTypes[index];
        return DonationTypeCard(
          imagePath: item["icon"]!,
          title: item["title"]!,
          isSelected: selectedIndex == index,
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
        );
      },
    );
  }
}
