import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/profile/views/widgets/profile_field_item.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(),
      hasShape: false,
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
                    "my_profile".tr(context),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              ProfileFieldItem(
                title: " سعد عطيه المالكي",
                svgAsset: "assets/images/svg/person.svg",
                onTap: () {},
              ),
              ProfileFieldItem(
                title: "D-280843",
                svgAsset: "assets/images/svg/security.svg",
                onTap: () {},
              ),
              ProfileFieldItem(
                title: "0540936802",
                svgAsset: "assets/images/svg/mob.svg",
                onTap: () {},
              ),
              ProfileFieldItem(
                title: "akram.ahmed@share.net.sa",
                svgAsset: "assets/images/svg/emal.svg",
                onTap: () {},
              ),
              SizedBox(
                height: 40.h,
              ),
              AppButton(
                text: "edit_profile".tr(context),
                onPressed: () {},
                backgroundColor: Colors.transparent,
                prefixIcon: Icon(
                  CupertinoIcons.gear,
                  size: 30.sp,
                  color: AppColors.textSecondary,
                ),
                type: AppButtonType.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
