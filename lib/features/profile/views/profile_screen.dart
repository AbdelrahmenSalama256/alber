import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/profile/views/about_app_screen.dart';
import 'package:qafeel/features/profile/views/donation_history_screen.dart';
import 'package:qafeel/features/profile/views/dontation_cart_screen.dart';
import 'package:qafeel/features/profile/views/edit_profile_screen.dart';
import 'package:qafeel/features/profile/views/widgets/logout_button.dart';

import '../../../core/constants/app_colors.dart';
import 'widgets/custom_item_list.dart';
import 'widgets/donation_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasShape: false,
      appBar: CustomTopBar(
        onBack: () {
          context.read<GlobalCubit>().changeBottomNavIndex(2);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/svg/nav/profile2.svg",
                    width: 20.w,
                  ),
                  SizedBox(width: 20.h),
                  Text(
                    "my_account".tr(context),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DonationInfoCard(
                      iconPath: "assets/images/svg/wallet.svg",
                      title: "total_donations".tr(context),
                      value: "35000",
                      isAmout: true,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: DonationInfoCard(
                      iconPath: "assets/images/svg/donation-count.svg",
                      title: "donation_count".tr(context),
                      value: "350",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ActionCard(
                title: 'my_profile'.tr(context),
                svgAsset: 'assets/images/svg/person.svg',
                onTap: () {
                  navigateTo(context, EditProfileScreen());
                },
              ),
              ActionCard(
                title: 'donation_history'.tr(context),
                svgAsset: "assets/images/svg/donation-history.svg",
                onTap: () {
                  navigateTo(context, DonationHistoryScreen());
                },
              ),
              ActionCard(
                title: 'donation_cart'.tr(context),
                svgAsset: 'assets/images/svg/donation-cart.svg',
                onTap: () {
                  navigateTo(context, DontationCartScreen());
                },
              ),
              ActionCard(
                title: 'about_app'.tr(context),
                assetImage: 'assets/images/png/about.png',
                onTap: () {
                  navigateTo(context, AboutAppScreeen());
                },
              ),
              SizedBox(
                height: 40.h,
              ),
              LogoutButton(
                onLogout: () {
                  navigateAndFinish(context, const PhoneConfirmScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
