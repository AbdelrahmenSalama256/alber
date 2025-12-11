import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';

class AppTheme {
  static ThemeData getLightTheme(String language) {
    return ThemeData(
      fontFamily: language == "ar" ? 'arabic' : "english",
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 16.sp,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 12.sp,
          color: AppColors.textSecondary,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.primary.withOpacity(0.4),
        selectionHandleColor: AppColors.primary,
        cursorColor: AppColors.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          textStyle: TextStyle(
            fontFamily: language == "ar" ? 'arabic' : "english",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: Size(double.infinity, 50.h),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontFamily: language == "ar" ? 'arabic' : "english",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontFamily: language == "ar" ? 'arabic' : "arabic",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: Colors.white,
        todayBorder: const BorderSide(color: AppColors.primary),
        headerHelpStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 14.sp,
        ),
        headerHeadlineStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 25.sp,
        ),
        rangePickerHeaderHeadlineStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 25.sp,
        ),
        rangePickerHeaderHelpStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 14.sp,
        ),
        weekdayStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 14.sp,
        ),
        dayStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 14.sp,
        ),
        dayOverlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
        yearStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          color: AppColors.textPrimary,
          fontSize: 14.sp,
        ),
        yearOverlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.background,
        hourMinuteTextColor: AppColors.textPrimary,
        hourMinuteColor: AppColors.surface,
        dayPeriodTextColor: AppColors.textPrimary,
        dayPeriodColor: AppColors.surface,
        dialHandColor: AppColors.primary,
        dialBackgroundColor: AppColors.surface,
        dialTextColor: AppColors.textPrimary,
        entryModeIconColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.border),
        ),
        helpTextStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 14.sp,
        ),
        hourMinuteTextStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 20.sp,
        ),
        dayPeriodTextStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 14.sp,
        ),
        dialTextStyle: TextStyle(
          fontFamily: language == "ar" ? 'arabic' : "english",
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
