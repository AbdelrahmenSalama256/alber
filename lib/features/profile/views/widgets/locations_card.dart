import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class LocationsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String iconPath;
  final Color titleColor;
  final Color backgroundColor;

  const LocationsCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.iconPath,
    this.titleColor = AppColors.textGrey,
    this.backgroundColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30.h),
      height: 195.75479125976585.h,
      decoration: BoxDecoration(
        color: AppColors.textGrey,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            PositionedDirectional(
              start: 0,
              top: 0,
              child: Container(
                width: 169.8113403320319.w,
                height: 39.15094757080093.h,
                decoration: BoxDecoration(
                  color: titleColor,
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(12.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/svg/badge-mark.svg",
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              start: 0,
              top: 40.h,
              end: 170.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.w,
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(iconPath),
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Text(
                        description,
                        style: TextStyle(
                          color: const Color(0xff7E7E7E),
                          fontSize: 9.sp,
                          height: 2.3.h,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              end: 0,
              start: 170.w,
              top: 4.h,
              bottom: 4.h,
              child: ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(94.34.r),
                  bottomStart: Radius.circular(94.34.r),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
