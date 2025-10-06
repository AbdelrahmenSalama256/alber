import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/bills/views/bills_screen.dart';
import 'package:qafeel/features/dedicate_donation/views/dedicate_donation_screen.dart';
import 'package:qafeel/features/home/view/home_screen.dart';
import 'package:qafeel/features/services/views/services_screen.dart';

import '../../../core/cubit/global_state.dart';
import '../../profile/views/profile_screen.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});

  final List<Widget> _pages = [
    ServicesScreen(),
    DedicateDonationScreen(),
    HomeScreen(),
    BillsScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = context.read<GlobalCubit>();
        final currentIndex = cubit.currentNavIndex;

        return Scaffold(
          extendBody: true,
          backgroundColor: AppColors.white,
          body: _pages[currentIndex],
          bottomNavigationBar: SafeArea(
            bottom: true,
            left: false,
            right: false,
            top: false,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              // padding: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15.r,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: CurvedNavigationBar(
                index: currentIndex,
                items: [
                  CurvedNavigationBarItem(
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    child: SvgPicture.asset(
                      currentIndex == 0
                          ? "assets/images/svg/nav/services-active.svg"
                          : "assets/images/svg/nav/services.svg",
                      width: 25.w,
                    ),
                    label: currentIndex == 0 ? "" : "services".tr(context),
                  ),
                  CurvedNavigationBarItem(
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    child: SvgPicture.asset(
                      currentIndex == 1
                          ? "assets/images/svg/nav/donation-active.svg"
                          : "assets/images/svg/nav/donation.svg",
                      width: 25.w,
                    ),
                    label: currentIndex == 1 ? "" : "donation".tr(context),
                  ),
                  CurvedNavigationBarItem(
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    child: SvgPicture.asset(
                      currentIndex == 2
                          ? "assets/images/svg/nav/home-active.svg"
                          : "assets/images/svg/nav/home.svg",
                      width: 25.w,
                    ),
                    label: currentIndex == 2 ? "" : "home".tr(context),
                  ),
                  CurvedNavigationBarItem(
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    child: SvgPicture.asset(
                      currentIndex == 3
                          ? "assets/images/svg/nav/recipts-active.svg"
                          : "assets/images/svg/nav/recipts.svg",
                      width: 25.w,
                    ),
                    label: currentIndex == 3 ? "" : "recipts".tr(context),
                  ),
                  CurvedNavigationBarItem(
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    child: SizedBox(
                      width: 20.w,
                      child: SvgPicture.asset(
                        currentIndex == 4
                            ? "assets/images/svg/nav/profile-active.svg"
                            : "assets/images/svg/nav/profile2.svg",
                        width: 25.w,
                      ),
                    ),
                    label: currentIndex == 4 ? "" : "my_account".tr(context),
                  ),
                ],
                color: Colors.white.withOpacity(0.75),
                buttonBackgroundColor: AppColors.white,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.bounceInOut,
                animationDuration: const Duration(milliseconds: 300),
                height: 75.h,
                onTap: (index) => cubit.changeBottomNavIndex(index),
              ),
            ),
          ),
        );
      },
    );
  }
}
