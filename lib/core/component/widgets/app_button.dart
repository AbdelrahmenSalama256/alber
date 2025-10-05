import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';

enum AppButtonType { primary, outlined, secondary }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 56, // نفس اللي في التصميم
    this.width,
    this.padding,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    switch (type) {
      case AppButtonType.primary:
        return _buildPrimary(isDisabled);
      case AppButtonType.outlined:
        return _buildOutlined(isDisabled);
      case AppButtonType.secondary:
        return _buildSecondary(isDisabled);
    }
  }

  /// 🔘 Filled Button
  Widget _buildPrimary(bool isDisabled) {
    return _buildBaseButton(
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      border: null,
      isDisabled: isDisabled,
    );
  }

  /// ⬜ Outlined Button
  Widget _buildOutlined(bool isDisabled) {
    return _buildBaseButton(
      backgroundColor: const Color(0x3030301A), // #3030301A
      textColor: AppColors.primary,
      border: Border.all(color: AppColors.primary, width: 1),
      isDisabled: isDisabled,
    );
  }

  /// ⚪ Secondary Button
  Widget _buildSecondary(bool isDisabled) {
    return _buildBaseButton(
      backgroundColor: const Color(0x80CCCCCC), // #CCCCCC80
      textColor: AppColors.primary,
      border: null,
      isDisabled: isDisabled,
    );
  }

  Widget _buildBaseButton({
    required Color backgroundColor,
    required Color textColor,
    required bool isDisabled,
    Border? border,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width?.w,
      height: height.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(11.79.r),
          border: border,
        ),
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(11.79.r),
            ),
          ),
          child: _buildContent(textColor),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8.w)],
        Text(
          text,
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
        ),
        if (suffixIcon != null) ...[SizedBox(width: 8.w), suffixIcon!],
      ],
    );
  }
}
