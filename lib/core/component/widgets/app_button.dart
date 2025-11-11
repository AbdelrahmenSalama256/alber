import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';

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

  /// ✅ خلفية قابلة للتغيير
  final Color? backgroundColor; // لون عادي
  final Gradient? backgroundGradient; // جريدينت
  final DecorationImage? backgroundImage; // صورة كـ خلفية
  final Color? customTextColor; // لون نص مخصّص (اختياري)

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 56,
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
    final isDisabled = onPressed == null || isLoading;

    switch (type) {
      case AppButtonType.primary:
        return _buildBaseButton(
          // defaults
          fallbackBg: AppColors.primary,
          fallbackText: Colors.white,
          border: null,
          isDisabled: isDisabled,
        );
      case AppButtonType.outlined:
        return _buildBaseButton(
          fallbackBg: const Color(0x3030301A), // #3030301A
          fallbackText: AppColors.primary,
          border: Border.all(color: AppColors.primary, width: 1),
          isDisabled: isDisabled,
        );
      case AppButtonType.secondary:
        return _buildBaseButton(
          fallbackBg: const Color(0x80CCCCCC), // #CCCCCC80
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
    // اختر لون النص النهائي
    final Color finalTextColor =
        customTextColor ?? (textStyle?.color ?? fallbackText);

    return SizedBox(
      width: isFullWidth ? double.infinity : width?.w,
      height: height.h,
      child: Opacity(
        opacity: isDisabled ? 0.7 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            // ✅ أولويّة: Gradient > Image > Color
            color: (backgroundGradient == null && backgroundImage == null)
                ? (backgroundColor ?? fallbackBg)
                : null,
            gradient: backgroundGradient,
            image: backgroundImage,
            borderRadius: borderRadius ?? BorderRadius.circular(sl<GlobalCubit>().radiusMd.r),
            border: border,
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(sl<GlobalCubit>().radiusMd.r),
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
          style: (textStyle ??
                  TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ))
              .copyWith(color: textColor),
        ),
        if (suffixIcon != null) ...[SizedBox(width: 8.w), suffixIcon!],
      ],
    );
  }
}
