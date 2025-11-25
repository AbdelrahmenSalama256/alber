import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/component/widgets/confirm_action_sheet.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';

import '../../../../core/services/service_locator.dart';

class LanguageSelectorSheet {
  static void show({
    required BuildContext context,
  }) {
    final globalCubit = context.read<GlobalCubit>();
    final currentLanguage = globalCubit.language;

    showConfirmActionSheet(
      context,
      title: 'select_language'.tr(context),
      message: null, // No message since we have custom content
      confirmText: 'confirm'.tr(context), // Still required but won't be shown
      cancelText: 'cancel'.tr(context),
      onConfirm: () {}, // Still required but won't be called
      showConfirm: false, // Hide the confirm button
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          _LanguageOption(
            languageCode: 'en',
            languageName: 'English',
            isSelected: currentLanguage == 'en',
            onTap: () {
              if (currentLanguage != 'en') {
                globalCubit.changeLanguage();
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(height: 12.h),
          _LanguageOption(
            languageCode: 'ar',
            languageName: 'العربية',
            isSelected: currentLanguage == 'ar',
            onTap: () {
              if (currentLanguage != 'ar') {
                globalCubit.changeLanguage();
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageCode,
    required this.languageName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radiusMd = sl<GlobalCubit>().radiusMd;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radiusMd.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radiusMd.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.4)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(radiusMd.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.border.withOpacity(0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Flag or Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: languageCode == 'en' ? Colors.blue : Colors.green,
                ),
                child: Center(
                  child: Text(
                    languageCode == 'en' ? 'EN' : 'AR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                languageName,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 24.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
