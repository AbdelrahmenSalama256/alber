import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';

class LocationsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String iconPath;
  final Color titleColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const LocationsCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.iconPath,
    this.titleColor = AppColors.primary,
    this.backgroundColor = AppColors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 24.h),
        height: 160.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            //! Background container
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),

            //! Main content row
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  //! Text content column
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Title badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: titleColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/images/svg/badge-mark.svg",
                                width: 16.w,
                                height: 16.w,
                              ),
                              SizedBox(width: 6.w),
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

                        SizedBox(height: 16.h),

                        //! Description with supporting icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: titleColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                iconPath,
                                color: titleColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                description,
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12.sp,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        //! Optional call-to-action row
                        if (onTap != null)
                          Row(
                            children: [
                              Text(
                                'view_details'.tr(context),
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12.w,
                                color: titleColor,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  SizedBox(width: 16.w),

                  //! Image section
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
