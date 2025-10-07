import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class NotificationDetailsSheet extends StatelessWidget {
  final String title;
  final String body;
  final String time;

  const NotificationDetailsSheet({
    super.key,
    required this.title,
    required this.body,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
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
                      color: AppColors.black.withOpacity(0.2)),
                ],
                border: Border(
                    top: BorderSide(color: AppColors.primary, width: 2.w)),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                        color: AppColors.textGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(time,
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColors.primary, width: 1.w)),
                        ),
                        child: Text(
                          body,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.7),
                        ),
                      ),
                    ),
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
