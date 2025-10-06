import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/cart/views/dontation_cart_screen.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/component/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import '../../profile/views/widgets/custom_field.dart';
import 'widgets/mony_selector.dart';

class SendDedicationDonationScreen extends StatefulWidget {
  const SendDedicationDonationScreen({super.key});

  @override
  State<SendDedicationDonationScreen> createState() =>
      _SendDedicationDonationScreenState();
}

class _SendDedicationDonationScreenState
    extends State<SendDedicationDonationScreen> {
  bool _showNextButton = false;
  bool showAmountToRecipient = false;
  bool sendCardToMyPhone = false;

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
      appBar: CustomTopBar(),
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
                buildSectionTitle("gift_data".tr(context)),
                SizedBox(height: 30.h),
                CustomFieldWithSvgLabel(
                  label: 'enter_recipient_name'.tr(context),
                  svgAssetPath: "assets/images/svg/label.svg",
                  fieldWidget: AppTextField(
                    controller: TextEditingController(),
                    hintText: 'name'.tr(context),
                  ),
                ),
                SizedBox(height: 12.h),
                CustomFieldWithSvgLabel(
                  label: 'phone_number'.tr(context),
                  svgAssetPath: "assets/images/svg/label.svg",
                  fieldWidget: AppTextField(
                    controller: TextEditingController(),
                    keyboardType: TextInputType.phone,
                    hintText: 'phone_number'.tr(context),
                  ),
                ),
                SizedBox(height: 20.h),
                buildSectionTitle("amount".tr(context)),
                SizedBox(height: 20.h),
                MoneySelector(),
                SizedBox(height: 20.h),
                CustomFieldWithSvgLabel(
                  label: 'set_amount'.tr(context),
                  svgAssetPath: "assets/images/svg/label.svg",
                  fieldWidget: AppTextField(
                    controller: TextEditingController(),
                    keyboardType: TextInputType.text,
                    hintText: 'amount_value'.tr(context),
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: SvgPicture.asset(
                        "assets/images/svg/currancy.svg",
                        color: AppColors.textGrey,
                        width: 20.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "show_amount_to_recipient".tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: showAmountToRecipient,
                        onChanged: (val) {
                          setState(() => showAmountToRecipient = val ?? false);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "send_card_to_my_phone".tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: sendCardToMyPhone,
                        onChanged: (val) {
                          setState(() => sendCardToMyPhone = val ?? false);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
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
                                  navigateTo(context, DontationCartScreen());
                                },
                                text: "continue_payment".tr(context),
                                suffixIcon: Icon(
                                  CupertinoIcons.chevron_back,
                                  color: AppColors.white,
                                  size: 25.sp,
                                ),
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
          constraints: BoxConstraints(minWidth: 148.w),
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
}
