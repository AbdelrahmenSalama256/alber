import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/shared/widgets/section_header.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/component/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import '../../cart/views/dontation_cart_screen.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import '../../profile/views/widgets/custom_field.dart';
import './cubit/dedicate_donation_cubit.dart';
import './cubit/dedicate_donation_state.dart';
import 'widgets/mony_selector.dart';

class SendDedicationDonationScreen extends StatelessWidget {
  const SendDedicationDonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasShape: false,
      appBar: const CustomTopBar(),
      body: BlocBuilder<DedicateDonationCubit, DedicateDonationState>(
        builder: (context, state) {
          if (state is DedicateDonationLoading) {
            return _loadingSkeleton(context);
          }
          if (state is! DedicateDonationLoaded) return const SizedBox();
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      leadingType: HeaderLeadingType.svg,
                      svgAsset: "assets/images/svg/nav/donation.svg",
                      title: "donation".tr(context),
                      textStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      leadingSize: 25,
                      spacing: 10,
                      center: true,
                      padding: EdgeInsets.only(top: 40.h),
                    ),
                    SizedBox(height: 15.h),
                    _sectionTitle(context, "gift_data".tr(context)),
                    SizedBox(height: 30.h),
                    CustomFieldWithSvgLabel(
                      label: 'enter_recipient_name'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                        controller: state.recipientNameC,
                        hintText: 'name'.tr(context),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CustomFieldWithSvgLabel(
                      label: 'phone_number'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                        controller: state.recipientPhoneC,
                        keyboardType: TextInputType.phone,
                        hintText: 'phone_number'.tr(context),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _sectionTitle(context, "amount".tr(context)),
                    SizedBox(height: 20.h),
                    const MoneySelector(),
                    SizedBox(height: 20.h),
                    CustomFieldWithSvgLabel(
                      label: 'set_amount'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                        controller: state.customAmountC,
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
                            value: state.showAmountToRecipient,
                            onChanged: (v) => context
                                .read<DedicateDonationCubit>()
                                .toggleShowAmount(v ?? false),
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
                            value: state.sendCardToMyPhone,
                            onChanged: (v) => context
                                .read<DedicateDonationCubit>()
                                .toggleSendToMyPhone(v ?? false),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 200.h),
                  ],
                ),
              ),
              if (state.showNextButton)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            padding:
                                EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 12,
                                  offset: Offset(0, -4.h),
                                  color: AppColors.black.withOpacity(0.2),
                                ),
                              ],
                              border: Border(
                                top: BorderSide(
                                    color: AppColors.primary, width: 2.w),
                              ),
                              borderRadius: BorderRadius.circular(24),
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
                                          context, const DontationCartScreen());
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
          );
        },
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          constraints: BoxConstraints(minWidth: 148.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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

  Widget _loadingSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            leadingType: HeaderLeadingType.svg,
            svgAsset: "assets/images/svg/nav/donation.svg",
            isLoading: true,
            skeletonWidth: 160,
            skeletonHeight: 22,
            skeletonRadius: BorderRadius.circular(6),
            leadingSize: 25,
            spacing: 10,
            center: true,
            padding: EdgeInsets.only(top: 40.h),
          ),
          SizedBox(height: 20.h),
          SkeletonLoader(
            width: 120.w,
            height: 20.h,
            borderRadius: BorderRadius.circular(6),
          ),
          SizedBox(height: 12.h),
          SkeletonLoader(
            width: double.infinity,
            height: 60.h,
            borderRadius: BorderRadius.circular(12),
          ),
          SizedBox(height: 12.h),
          SkeletonLoader(
            width: double.infinity,
            height: 60.h,
            borderRadius: BorderRadius.circular(12),
          ),
          SizedBox(height: 20.h),
          SkeletonLoader(
            width: 120.w,
            height: 20.h,
            borderRadius: BorderRadius.circular(6),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 56.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (_, __) => SkeletonLoader(
                width: 90.w,
                height: 56.h,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SkeletonLoader(
            width: double.infinity,
            height: 60.h,
            borderRadius: BorderRadius.circular(12),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 48.h,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 48.h,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          SizedBox(height: 120.h),
          Center(
            child: SkeletonLoader(
              width: 220.w,
              height: 52.h,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
