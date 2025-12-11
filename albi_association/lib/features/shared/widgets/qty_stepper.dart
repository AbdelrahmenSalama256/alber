import 'package:flutter/material.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class QtyStepper extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChanged;
  final Color accent;
  final double? height;

  const QtyStepper({
    super.key,
    required this.qty,
    required this.onChanged,
    this.accent = AppColors.primary,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    final double stepperHeight = height ?? (isKiosk ? 7.h : 5.5.h);
    final double btnSize = 8.w;
    final double fontSize = 20.sp;
    final double innerPadding = 1.w;

    return Container(
      height: stepperHeight,
      padding: EdgeInsets.symmetric(horizontal: innerPadding),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isKiosk ? 2.h : 1.2.h),
        border: Border.all(
          color: accent.withOpacity(0.3),
          width: 0.3.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepBtn(
            accent: accent,
            icon: Icons.remove,
            size: btnSize,
            iconSize: 18.sp,
            onTap: () => onChanged(qty > 1 ? qty - 1 : 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "$qty",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
          ),
          _StepBtn(
            accent: accent,
            icon: Icons.add,
            size: btnSize,
            iconSize: 18.sp,
            onTap: () => onChanged(qty + 1),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;
  final double size;
  final double iconSize;

  const _StepBtn({
    required this.icon,
    required this.onTap,
    required this.accent,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(15),
          // shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: iconSize, color: AppColors.white),
      ),
    );
  }
}
