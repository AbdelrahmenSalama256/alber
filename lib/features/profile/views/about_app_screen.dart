import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../home/view/widgets/skeleton_loader.dart';
import './about_us_screen.dart';
import './complaints_screen.dart';
import './cubit/profile_cubit.dart';
import './cubit/profile_state.dart';
import './our_locations_screen.dart';
import './privacy_policy_screen.dart';
import './terms_conditions_screen.dart';
import 'widgets/custom_item_list.dart';

class AboutAppScreeen extends StatelessWidget {
  const AboutAppScreeen({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      SkeletonLoader(
                          width: 148.w,
                          height: 41.h,
                          borderRadius: BorderRadius.circular(8.r)),
                      SizedBox(height: 20.h),
                      ...List.generate(
                          5,
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
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Center(
                      child: Image.asset(
                          "assets/images/png/alber-inline-logo.png",
                          width: 148.w,
                          height: 40.88997268676758.h),
                    ),
                    SizedBox(height: 20.h),
                    ActionCard(
                      title: 'about_albir'.tr(context),
                      assetImage: 'assets/images/png/about.png',
                      onTap: () => navigateTo(
                        context,
                        BlocProvider(
                          create: (context) => ProfileCubit()..init(),
                          child: AboutUsScreen(),
                        ),
                      ),
                    ),
                    ActionCard(
                      title: 'terms_and_conditions'.tr(context),
                      svgAsset: "assets/images/svg/security.svg",
                      onTap: () => navigateTo(
                        context,
                        BlocProvider(
                          create: (context) => ProfileCubit()..init(),
                          child: TermsConditionsScreen(),
                        ),
                      ),
                    ),
                    ActionCard(
                      title: 'privacy_policy'.tr(context),
                      svgAsset: "assets/images/svg/lock.svg",
                      onTap: () => navigateTo(
                        context,
                        BlocProvider(
                          create: (context) => ProfileCubit()..init(),
                          child: PrivacyPolicyScreen(),
                        ),
                      ),
                    ),
                    ActionCard(
                      title: 'our_locations'.tr(context),
                      svgAsset: "assets/images/svg/map-marker.svg",
                      onTap: () => navigateTo(
                        context,
                        BlocProvider(
                          create: (context) => ProfileCubit()..init(),
                          child: OurLocationsScreen(),
                        ),
                      ),
                    ),
                    ActionCard(
                      title: 'complaints_call_us'.tr(context),
                      svgAsset: "assets/images/svg/circle-question.svg",
                      onTap: () => navigateTo(
                        context,
                        BlocProvider(
                          create: (context) => ProfileCubit()..init(),
                          child: ContactComplaintsScreen(),
                        ),
                      ),
                    ),
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
