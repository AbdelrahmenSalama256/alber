import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';

class ConfirmActionSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const ConfirmActionSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final radiusXl = sl<GlobalCubit>().radiusXl;
    final radiusMd = sl<GlobalCubit>().radiusMd;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radiusXl.r),
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
                border: Border(top: BorderSide(color: AppColors.primary, width: 2.w)),
                borderRadius: BorderRadius.circular(radiusXl.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.textGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(radiusMd.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(radiusMd.r),
                          border: Border(bottom: BorderSide(color: AppColors.primary, width: 1.w)),
                        ),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          type: AppButtonType.outlined,
                          text: cancelText,
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppButton(
                          text: confirmText,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            onConfirm();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool?> showConfirmActionSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ConfirmActionSheet(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
    ),
  );
}
