import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class SocialMediaButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const SocialMediaButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          alignment: Alignment.center,
          width: 38.7.w,
          height: 38.7.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: icon,
        ),
      ),
    );
  }
}
