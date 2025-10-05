import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/profile/views/about_us_screen.dart';
import 'package:qafeel/features/profile/views/our_locations_screen.dart';
import 'package:qafeel/features/profile/views/terms_conditions_screen.dart';

import 'privacy_policy_screen.dart';
import 'widgets/custom_item_list.dart';

class AboutAppScreeen extends StatelessWidget {
  const AboutAppScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Image.asset(
                "assets/images/png/alber-inline-logo.png",
                width: 148.w,
                height: 40.88997268676758.h,
              ),
              SizedBox(
                height: 20.h,
              ),
              ActionCard(
                title: 'about_albir'.tr(context),
                assetImage: 'assets/images/png/about.png',
                onTap: () {
                  navigateTo(context, AboutUsScreen());
                },
              ),
              ActionCard(
                title: 'terms_and_conditions'.tr(context),
                svgAsset: "assets/images/svg/security.svg",
                onTap: () {
                  navigateTo(context, TermsConditionsScreen());
                },
              ),
              ActionCard(
                title: 'privacy_policy'.tr(context),
                svgAsset: "assets/images/svg/lock.svg",
                onTap: () {
                  navigateTo(context, PrivacyPolicyScreen());
                },
              ),
              ActionCard(
                title: 'our_locations'.tr(context),
                svgAsset: "assets/images/svg/map-marker.svg",
                onTap: () {
                  navigateTo(context, OurLocationsScreen());
                },
              ),
              ActionCard(
                title: 'complaints_call_us'.tr(context),
                svgAsset: "assets/images/svg/circle-question.svg",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
