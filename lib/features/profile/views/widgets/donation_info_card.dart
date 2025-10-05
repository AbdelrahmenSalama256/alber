import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class DonationInfoCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  final Color? backgroundColor;
  final bool? isAmout;

  const DonationInfoCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    this.backgroundColor,
    this.isAmout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(4.35.r),
        border: Border(
          bottom: BorderSide(color: AppColors.textSecondary, width: 2.5.w),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 4.25.r,
            spreadRadius: -1.89.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textSecondary,
                  width: 0.62.w,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 22.w,
                  height: 22.w,
                  // color: const Color(0xff9E9E9E),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
              ),
              SizedBox(height: 3.h),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    isAmout!
                        ? SvgPicture.asset(
                            "assets/images/svg/currancy.svg",
                            color: AppColors.black,
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
