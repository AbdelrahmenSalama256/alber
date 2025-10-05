import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class QtyStepper extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChanged;
  final Color accent;
  final double height;

  const QtyStepper({
    super.key,
    required this.qty,
    required this.onChanged,
    this.accent = AppColors.primary,
    this.height = 19.115312576293945,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepBtn(
              accent: accent, icon: Icons.add, onTap: () => onChanged(qty + 1)),
          SizedBox(width: 10.w),
          Text(
            "$qty",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: accent,
            ),
          ),
          SizedBox(width: 10.w),
          _StepBtn(
              accent: accent,
              icon: Icons.remove,
              onTap: () => onChanged(qty > 1 ? qty - 1 : 1)),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? accent;

  const _StepBtn(
      {required this.icon,
      required this.onTap,
      this.accent = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 15.w,
        height: 15.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: accent ?? AppColors.primary, shape: BoxShape.circle),
        child: Icon(icon, size: 14.sp, color: AppColors.white),
      ),
    );
  }
}
