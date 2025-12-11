import 'package:flutter/material.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

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
        borderRadius: BorderRadius.circular(30),
        child: Container(
          alignment: Alignment.center,
          width: 38.7.w,
          height: 38.7.h,
          // clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            // color: const Color(0xff7E7E7E),
          ),
          child: icon, // هنا بقى تستقبل أي Widget
        ),
      ),
    );
  }
}
