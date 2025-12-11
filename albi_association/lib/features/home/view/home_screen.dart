import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/home/view/widgets/video_slider_widget.dart';
import 'package:qafeel/features/services/views/services_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import '../../../core/cubit/global_cubit.dart';
import '../../../core/network/local_network.dart';
import '../../settings/view/cubit/settings_cubit.dart';
import '../../settings/view/cubit/settings_state.dart';
import '../data/repo/home_repo.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cachedId =
        sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId);
    final branchId = int.tryParse(cachedId ?? '');

    return BlocProvider(
      create: (context) =>
          HomeCubit(sl<HomeRepo>(), branchId ?? 0)..loadHomeData(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomScaffold(
            hasShape: false,
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state is HomeError) {
      return Center(
        child: Text(
          state.message,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.sp,
          ),
        ),
      );
    }

    if (state is HomeLoaded) {
      return Stack(
        children: [
          /// ✅ Background Video Slider
          Positioned.fill(
            child: VideoSliderWidget(
              sliders: state.sliders,
              currentIndex: state.currentSliderIndex,
            ),
          ),

          /// ✅ Transparent Floating Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomTopBar(
              isHome: true,
            ),
          ),

          /// ✅ Optional foreground content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h), // leave space below top bar
              ],
            ),
          ),

          /// ✅ Floating bottom bar (already perfect)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.h),
        child: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 3.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.h),
          ),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, s) {
              if (s is SettingsLoading || s is SettingsInitial) {
                // 🦴 Skeleton buttons placeholder
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (s is SettingsLoaded &&
                  s.data.donateNow != null &&
                  s.data.donateNow!.isNotEmpty) {
                final items = s.data.donateNow!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...items.map(
                        (e) => Padding(
                          padding: EdgeInsetsDirectional.only(start: 3.w),
                          child: SizedBox(
                            height: 8.h,
                            width: 40.w,
                            child: AppButton(
                              isFullWidth: true,
                              backgroundColor: AppColors.textSecondary,
                              onPressed: () {
                                context
                                    .read<GlobalCubit>()
                                    .setLanguage(e.code ?? 'ar');
                                navigateTo(
                                  context,
                                  const ServicesScreen(isFromHome: true),
                                );
                              },
                              text: e.title ?? 'donate_now'.tr(context),
                              textStyle: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Default fallback (if no data)
              return Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: AppButton(
                        backgroundColor: AppColors.textSecondary,
                        onPressed: () =>
                            navigateTo(context, const ServicesScreen()),
                        text: "donate_now".tr(context),
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: AppButton(
                        backgroundColor: AppColors.textSecondary,
                        onPressed: () =>
                            navigateTo(context, const ServicesScreen()),
                        text: "donate_now".tr(context),
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
