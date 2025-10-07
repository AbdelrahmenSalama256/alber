import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/shared/widgets/section_header.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/component/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import '../../profile/views/widgets/custom_field.dart';
import 'cubit/add_donation_cubit.dart';
import 'cubit/add_donation_state.dart';
import 'terms_conditions_add_screen.dart';

class AddDonationCartScreen extends StatelessWidget {
  const AddDonationCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddDonationCubit()..init(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(),
        body: BlocBuilder<AddDonationCubit, AddDonationState>(
          builder: (context, state) {
            if (state is AddDonationLoading) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SectionHeader(
                      leadingType: HeaderLeadingType.svg,
                      svgAsset: "assets/images/svg/donation-cart.svg",
                      isLoading: true,
                      skeletonWidth: 150,
                      skeletonHeight: 24,
                      skeletonRadius: BorderRadius.circular(6.r),
                      leadingSize: 30,
                      spacing: 15,
                      center: true,
                      padding: EdgeInsets.only(top: 40.h),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    SizedBox(height: 80.h),
                    Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }
            final c = context.read<AddDonationCubit>();
            final s = state as AddDonationLoaded;

            Future<void> pickDate(bool isStart) async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                helpText:
                    isStart ? 'start_date'.tr(context) : 'end_date'.tr(context),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                      onSurface: AppColors.textGrey,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary),
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                final v =
                    "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                isStart ? c.setStartDate(v) : c.setEndDate(v);
              }
            }

            Future<void> pickTime() async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                      onSurface: AppColors.textGrey,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                final hh = picked.hour.toString().padLeft(2, '0');
                final mm = picked.minute.toString().padLeft(2, '0');
                c.setTime("$hh:$mm");
              }
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        leadingType: HeaderLeadingType.svg,
                        svgAsset: "assets/images/svg/donation-cart.svg",
                        title: "donation_cart".tr(context),
                        leadingSize: 30,
                        spacing: 15,
                        textStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        center: true,
                        padding: EdgeInsets.only(top: 40.h),
                      ),
                      SizedBox(height: 15.h),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(minWidth: 86.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.textGrey.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Text(
                            "auto_deduction".tr(context),
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomFieldWithSvgLabel(
                        label: "project".tr(context),
                        svgAssetPath: "assets/images/svg/label.svg",
                        fieldWidget: AppTextField(
                          controller: c.projectC,
                          hintText: "project".tr(context),
                          textInputAction: TextInputAction.next,
                          onChanged: c.setProject,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomFieldWithSvgLabel(
                        label: "deduction_amount".tr(context),
                        svgAssetPath: "assets/images/svg/label.svg",
                        fieldWidget: _CounterField(
                          value: s.amount,
                          onChanged: c.setAmount,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomFieldWithSvgLabel(
                              label: "start_date".tr(context),
                              svgAssetPath: "assets/images/svg/label.svg",
                              fieldWidget: GestureDetector(
                                onTap: () => pickDate(true),
                                child: AbsorbPointer(
                                  child: AppTextField(
                                    controller: c.startDateC,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: SvgPicture.asset(
                                          "assets/images/svg/calender.svg",
                                          width: 20.w),
                                    ),
                                    hintText: "yyyy-mm-dd",
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[\d-]'))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomFieldWithSvgLabel(
                              label: "end_date".tr(context),
                              svgAssetPath: "assets/images/svg/label.svg",
                              fieldWidget: GestureDetector(
                                onTap: () => pickDate(false),
                                child: AbsorbPointer(
                                  child: AppTextField(
                                    controller: c.endDateC,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: SvgPicture.asset(
                                          "assets/images/svg/calender.svg",
                                          width: 20.w),
                                    ),
                                    hintText: "yyyy-mm-dd",
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[\d-]'))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      CustomFieldWithSvgLabel(
                        label: "deduction_type".tr(context),
                        svgAssetPath: "assets/images/svg/label.svg",
                        fieldWidget: Container(
                          height: 60.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(11.79.r),
                            border: Border.all(
                                color: const Color(0xFF707070), width: 0.47.w),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(11.79.r),
                              isExpanded: true,
                              value: s.periodicity,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.textGrey, size: 24.sp),
                              items: <String>['شهري', 'ربع سنوي', 'سنوي']
                                  .map<DropdownMenuItem<String>>(
                                    (v) => DropdownMenuItem<String>(
                                      value: v,
                                      child: Text(
                                        v,
                                        style: TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) c.setPeriodicity(v);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomFieldWithSvgLabel(
                              label: "month".tr(context),
                              svgAssetPath: "assets/images/svg/label.svg",
                              fieldWidget: _CounterField(
                                value: s.month,
                                min: 1,
                                max: 12,
                                onChanged: c.setMonth,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomFieldWithSvgLabel(
                              label: "day".tr(context),
                              svgAssetPath: "assets/images/svg/label.svg",
                              fieldWidget: _CounterField(
                                value: s.day,
                                min: 1,
                                max: 31,
                                onChanged: c.setDay,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      CustomFieldWithSvgLabel(
                        label: "time".tr(context),
                        svgAssetPath: "assets/images/svg/label.svg",
                        fieldWidget: GestureDetector(
                          onTap: pickTime,
                          child: AbsorbPointer(
                            child: AppTextField(
                              controller: c.timeC,
                              hintText: "hh:mm",
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.white,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (v) {},
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r)),
                            ),
                            Expanded(
                              child: Text(
                                "agree_terms".tr(context),
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 200.h),
                    ],
                  ),
                ),
                if (s.showNextButton)
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
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
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
                                        color: AppColors.primary, width: 2.w)),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52.h,
                                    child: AppButton(
                                      suffixIcon: Icon(
                                          CupertinoIcons.chevron_back,
                                          color: Colors.white,
                                          size: 20.sp),
                                      onPressed: () => navigateTo(context,
                                          const TermsConditionsAddScreen()),
                                      text: "terms_and_conditions_add"
                                          .tr(context),
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
      ),
    );
  }
}

class _CounterField extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _CounterField({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999999,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0xFF707070), width: 0.47.w),
        borderRadius: BorderRadius.circular(11.79.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconSquare(
            icon: CupertinoIcons.plus_circle_fill,
            onTap: () {
              if (value < max) onChanged(value + 1);
            },
          ),
          Text(
            "$value",
            style: TextStyle(
              color: const Color(0xffB1B1B1),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          _IconSquare(
            icon: CupertinoIcons.minus_circle_fill,
            onTap: () {
              if (value > min) onChanged(value - 1);
            },
          ),
        ],
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconSquare({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: const Color(0xffE6E6E6),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: AppColors.textGrey, size: 25.sp),
      ),
    );
  }
}
