import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class DonationTypeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const DonationTypeCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.97, sigmaY: 2.97),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 91.85113525390625.w,
            height: 91.85113525390625.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : Color(0xfffafafa).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.textGrey : AppColors.white,
                width: 0.74.w,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: SvgPicture.asset(
                      imagePath,
                      width: 91.85958099365234.w,
                      height: 59.22026062011719.h,
                      colorFilter: isSelected
                          ? const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn)
                          : null,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
