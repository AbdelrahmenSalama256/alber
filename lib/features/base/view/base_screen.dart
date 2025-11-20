import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/auth_return.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/bills/views/bills_screen.dart';
import 'package:qafeel/features/dedicate_donation/views/dedicate_donation_screen.dart';
import 'package:qafeel/features/dedicate_donation/views/quick_donation_screen.dart';
import 'package:qafeel/features/home/view/home_screen.dart';
import 'package:qafeel/features/home/view/widgets/quick_dontate.dart';
import 'package:qafeel/features/services/views/services_screen.dart';

import '../../../core/app/alber.dart';
import '../../../core/cubit/global_state.dart';
import '../../profile/views/profile_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = List<Widget>.filled(5, const SizedBox.shrink(), growable: false);
    _pages[2] = const HomeScreen();
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const ServicesScreen();
      case 1:
        return const DedicateDonationScreen();
      case 2:
        return const HomeScreen();
      case 3:
        return const BillsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _ensurePage(int index) {
    if (_pages[index] is SizedBox) {
      _pages[index] = _buildPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = context.read<GlobalCubit>();
        final currentIndex = cubit.currentNavIndex;
        _ensurePage(currentIndex);

        return WillPopScope(
          onWillPop: () async {
            if (cubit.currentNavIndex != 2) {
              cubit.changeBottomNavIndex(2);
              return false;
            }
            return true;
          },
          child: Stack(
            children: [
              Scaffold(
                extendBody: true,
                backgroundColor: Colors.transparent,
                body: IndexedStack(
                  index: currentIndex,
                  children: _pages,
                ),
                bottomNavigationBar: SafeArea(
                  bottom: true,
                  left: false,
                  right: false,
                  top: false,
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
                        label:
                            currentIndex == 4 ? "" : "my_account".tr(context),
                      ),
                    ],
                    //! Make the curve transparent so the body shows behind
                    backgroundColor: Colors.transparent,
                    color: Colors.white.withOpacity(0.85),
                    buttonBackgroundColor: Colors.white,
                    animationCurve: Curves.bounceInOut,
                    animationDuration: const Duration(milliseconds: 300),
                    height: 75.h,
                    onTap: (index) {
                      if ((index == 4 || index == 3)) {
                        final token = sl<CacheHelper>()
                            .getDataString(key: AppConstants.token);
                        if (token == null || token.isEmpty) {
                          showToast(
                            navigatorKey.currentContext!,
                            message: 'login'.tr(navigatorKey.currentContext!),
                            state: ToastStates.warning,
                          );
                          sl<AuthReturnService>().setPendingAction(() {
                            sl<GlobalCubit>().changeBottomNavIndex(index);
                          });
                          navigateTo(navigatorKey.currentContext!,
                              const PhoneConfirmScreen());
                          return;
                        }
                      }
                      cubit.changeBottomNavIndex(index);
                    },
                  ),
                ),
              ),
              ExpandableQuickDonateFAB(
                onQuickDonate: () {
                  navigateTo(
                      context, const QuickDonationScreen(initialTabIndex: 0));
                },
                onDedicateDonation: () {
                  navigateTo(context, const DedicateDonationScreen());
                },
                onVolunteerProjects: () {
                  navigateTo(
                      context, const QuickDonationScreen(initialTabIndex: 2));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
