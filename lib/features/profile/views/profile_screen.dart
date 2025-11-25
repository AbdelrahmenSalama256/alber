import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/component/widgets/confirm_action_sheet.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/cart/views/dontation_cart_screen.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/profile/views/about_app_screen.dart';
import 'package:qafeel/features/profile/views/donation_history_screen.dart';
import 'package:qafeel/features/profile/views/edit_profile_screen.dart';
import 'package:qafeel/features/profile/views/widgets/language_selector_sheet.dart';
import 'package:qafeel/features/profile/views/widgets/logout_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/profile_cubit.dart';
import './cubit/profile_state.dart';
import 'widgets/custom_item_list.dart';
import 'widgets/donation_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageSelector(BuildContext context) {
    LanguageSelectorSheet.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..init(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) =>
            current is ProfileLogoutSuccess || current is ProfileLogoutError,
        listener: (context, state) {
          if (state is ProfileLogoutSuccess) {
            showToast(context,
                message: state.message, state: ToastStates.success);
            navigateAndFinish(context, const PhoneConfirmScreen());
          } else if (state is ProfileLogoutError) {
            showToast(context,
                message: state.message, state: ToastStates.error);
          }
        },
        buildWhen: (previous, current) =>
            current is ProfileInitial ||
            current is ProfileLoading ||
            current is ProfileLoaded,
        builder: (context, state) {
          Widget body;
          if (state is ProfileLoaded) {
            body = _buildProfileContent(context, state);
          } else {
            body = _loading();
          }

          return CustomScaffold(
            hasShape: false,
            appBar: CustomTopBar(
              onBack: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.read<GlobalCubit>().changeBottomNavIndex(2);
                }
              },
            ),
            body: body,
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    final profile = state.profile;
    final avatar = profile.imageUrl;
    final globalCubit = context.read<GlobalCubit>();
    final currentLanguage = globalCubit.language;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            if (state.isUpdatingProfile)
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/svg/person.svg",
                    width: 25.w, height: 25.w),
                SizedBox(width: 15.h),
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
                    value: state.totalAmount,
                    isAmout: true,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: DonationInfoCard(
                    iconPath: "assets/images/svg/donation-count.svg",
                    title: "donation_count".tr(context),
                    value: state.totalCount,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ActionCard(
              title: 'my_profile'.tr(context),
              svgAsset: (avatar == null || avatar.isEmpty)
                  ? 'assets/images/svg/person.svg'
                  : null,
              assetImage: avatar != null && avatar.startsWith('assets/')
                  ? avatar
                  : null,
              imagePath: avatar != null && !avatar.startsWith('assets/')
                  ? avatar
                  : null,
              onTap: () {
                navigateTo(
                  context,
                  BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: const EditProfileScreen(),
                  ),
                );
              },
            ),
            ActionCard(
              title: 'donation_history'.tr(context),
              svgAsset: "assets/images/svg/donation-history.svg",
              onTap: () {
                navigateTo(
                  context,
                  BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: DonationHistoryScreen(),
                  ),
                );
              },
            ),
            ActionCard(
              title: 'donation_cart'.tr(context),
              svgAsset: 'assets/images/svg/donation-cart.svg',
              onTap: () {
                navigateTo(context, DontationCartScreen());
              },
            ),
            // Language Changer Card
            ActionCard(
              title: 'language'.tr(context),
              svgAsset: 'assets/images/svg/language-translate.svg',
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  currentLanguage == 'en' ? 'EN' : 'AR',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () => _showLanguageSelector(context),
            ),
            ActionCard(
              title: 'about_app'.tr(context),
              assetImage: 'assets/images/png/about.png',
              onTap: () {
                navigateTo(
                  context,
                  BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: AboutAppScreeen(),
                  ),
                );
              },
            ),
            SizedBox(height: 40.h),
            LogoutButton(
              onLogout: () async {
                await showConfirmActionSheet(
                  context,
                  title: 'logout'.tr(context),
                  message: 'are_you_sure'.tr(context),
                  confirmText: 'logout'.tr(context),
                  cancelText: 'cancel'.tr(context),
                  onConfirm: () {
                    context.read<ProfileCubit>().logout();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            SkeletonLoader(
                width: 180.w,
                height: 24.h,
                borderRadius: BorderRadius.circular(6.r)),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                    child: SkeletonLoader(
                        width: double.infinity,
                        height: 90.h,
                        borderRadius: BorderRadius.circular(12.r))),
                SizedBox(width: 12.w),
                Expanded(
                    child: SkeletonLoader(
                        width: double.infinity,
                        height: 90.h,
                        borderRadius: BorderRadius.circular(12.r))),
              ],
            ),
            SizedBox(height: 20.h),
            ...List.generate(
                5, // Increased to 5 for the new language option
                (i) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: SkeletonLoader(
                          width: double.infinity,
                          height: 64.h,
                          borderRadius: BorderRadius.circular(12.r)),
                    )),
          ],
        ),
      ),
    );
  }
}
