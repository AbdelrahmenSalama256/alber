import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';

import '../cubit/notifications_state.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final NotificationStatus status;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12.r,
                    offset: Offset(0, 6.h)),
              ],
              border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 1.w)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: c.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10.r)),
                  child:
                      Icon(Icons.notifications_active, color: c, size: 20.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                  color: c, shape: BoxShape.circle)),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Text(time,
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
