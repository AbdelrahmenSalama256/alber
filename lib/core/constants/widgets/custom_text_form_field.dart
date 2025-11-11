import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/widgets/text_style.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.maxLines,
    this.validator,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconColor,
    this.prefixIconColor,
    this.keyboardType,
    this.autofocus,
    this.contentPadding,
    this.hintStyle,
    this.enabled,
    this.borderRadius,
    this.floatingLabelBehavior,
    this.borderColor,
    this.onFieldSubmitted,
    this.onChanged,
    this.filled,
    this.fillColor,
    this.style,
    this.initialValue,
  });
  final String? hintText;
  final String? labelText;
  final bool? obscureText;
  final bool? filled;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final Color? borderColor;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final bool? enabled;
  final double? borderRadius;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final radiusSm = sl<GlobalCubit>().radiusSm;
    return TextFormField(
      autofocus: autofocus ?? false,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: validator,
      onChanged: onChanged,
      style: style ?? CustomTextStyle.roboto400sized14White,
      cursorColor: AppColors.primary,
      obscureText: obscureText ?? false,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        floatingLabelBehavior:
            floatingLabelBehavior ?? FloatingLabelBehavior.auto,
        contentPadding: contentPadding ?? EdgeInsets.all(18.w),
        border: getBorderStyle(context, borderRadius ?? radiusSm, borderColor),
        enabledBorder: getBorderStyle(context, borderRadius ?? radiusSm, borderColor),
        focusedBorder: getBorderStyle(context, borderRadius ?? radiusSm, borderColor),
        errorBorder: getBorderStyle(context, borderRadius ?? radiusSm, borderColor),
        disabledBorder: getBorderStyle(context, borderRadius ?? radiusSm, borderColor),
        focusedErrorBorder: getBorderStyle(context, borderRadius ?? radiusSm, borderColor),
        errorMaxLines: 5,
        labelText: labelText,
        hintText: hintText,
        fillColor: fillColor ?? AppColors.white,
        filled: filled ?? true,
        labelStyle: CustomTextStyle.roboto500sized14White,
        hintStyle: hintStyle ?? CustomTextStyle.roboto400sized14Grey,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor ?? AppColors.primary,
        prefixIconColor: prefixIconColor ?? AppColors.primary,
      ),
    );
  }
}

OutlineInputBorder getBorderStyle(context, borderRadius, borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius ?? sl<GlobalCubit>().radiusSm),
    borderSide: BorderSide(
      color: borderColor ?? const Color(0xffDDE5E9),
      width: 0.5,
    ),
  );
}
