import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class CustomFieldWithSvgLabel extends StatelessWidget {
  final String label;
  final String svgAssetPath;
  final Widget fieldWidget;
  final double? svgWidth;
  final double? svgHeight;
  final Color? svgColor;
  final EdgeInsetsGeometry? padding;

  const CustomFieldWithSvgLabel({
    super.key,
    required this.label,
    required this.svgAssetPath,
    required this.fieldWidget,
    this.svgWidth,
    this.svgHeight,
    this.svgColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        PositionedDirectional(
          top: 0.h,
          start: 0.w,
          child: SizedBox(
            width: svgWidth ?? 130.w,
            height: svgHeight ?? 60.h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    svgAssetPath,
                    fit: BoxFit.fill,
                    color: svgColor ?? const Color(0xFF707070),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30.h),
          child: fieldWidget,
        ),
      ],
    );
  }
}

class BlurredInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const BlurredInputField({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: const Color(0xfffafafa).withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 1.w),
                ),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: AppColors.textGrey.withOpacity(0.7),
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  filled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
