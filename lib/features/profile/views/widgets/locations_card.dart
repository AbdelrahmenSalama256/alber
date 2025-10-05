import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class LocationsCard extends StatelessWidget {
  const LocationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 195.75479125976585.h,
      decoration: BoxDecoration(
        color: AppColors.textGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.white,
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
                  color: AppColors.textGrey,
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(12.r),
                    topEnd: Radius.circular(0.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "data",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: 0,
              top: 30.h,
              end: 170.w,
              child: Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30.w,
                        height: 30.w,
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          "assets/images/svg/map-marker.svg",
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          "اهلا بكم في المقر الرئيسي جدة شارع احمد العطاس تقاطع البترجي موازي مستشفى السعودي الالماني",
                          style: TextStyle(
                            color: Color(0xff7E7E7E),
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
                  'assets/images/png/cure-main.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // SizedBox(height: 10.h),
            // Text
          ],
        ),
      ),
    );
  }
}
