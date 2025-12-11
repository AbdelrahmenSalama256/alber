import 'package:flutter/material.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

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

  /// ✅ Background customization
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final DecorationImage? backgroundImage;
  final Color? customTextColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 6.5, // use % height instead of fixed px
    this.width,
    this.padding,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.backgroundColor,
    this.backgroundGradient,
    this.backgroundImage,
    this.customTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    switch (type) {
      case AppButtonType.primary:
        return _buildBaseButton(
          fallbackBg: AppColors.primary,
          fallbackText: Colors.white,
          border: null,
          isDisabled: isDisabled,
        );

      case AppButtonType.outlined:
        return _buildBaseButton(
          fallbackBg: Colors.transparent,
          fallbackText: AppColors.primary,
          border: Border.all(color: AppColors.primary, width: 0.3.w),
          isDisabled: isDisabled,
        );

      case AppButtonType.secondary:
        return _buildBaseButton(
          fallbackBg: const Color(0x80CCCCCC),
          fallbackText: AppColors.primary,
          border: null,
          isDisabled: isDisabled,
        );
    }
  }

  Widget _buildBaseButton({
    required Color fallbackBg,
    required Color fallbackText,
    required bool isDisabled,
    Border? border,
  }) {
    final Color finalTextColor =
        customTextColor ?? (textStyle?.color ?? fallbackText);

    return SizedBox(
      width: isFullWidth ? double.infinity : width?.w,
      height: height.h,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (backgroundGradient == null && backgroundImage == null)
                ? (backgroundColor ?? fallbackBg)
                : null,
            gradient: backgroundGradient,
            image: backgroundImage,
            borderRadius: borderRadius ?? BorderRadius.circular(2.h),
            border: border,
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(2.h),
              ),
            ),
            child: _buildContent(finalTextColor),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 3.h,
        width: 3.h,
        child: CircularProgressIndicator(
          strokeWidth: 0.6.w,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          SizedBox(width: 2.w),
        ],
        Text(
          text,
          style: (textStyle ??
                  TextStyle(
                    color: textColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ))
              .copyWith(color: textColor),
        ),
        if (suffixIcon != null) ...[
          SizedBox(width: 2.w),
          suffixIcon!,
        ],
      ],
    );
  }
}
