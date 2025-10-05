import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class ProfileFieldItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  final IconData? icon;
  final String? assetImage; // assets/my_icon.png
  final String? svgAsset; // assets/my_icon.svg

  final double? iconSize; // optional override
  final Color? iconColor; // for IconData only
  final List<Color>? gradient; // custom gradient if you want
  final EdgeInsetsGeometry? margin;

  const ProfileFieldItem({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.assetImage,
    this.svgAsset,
    this.iconSize,
    this.iconColor,
    this.gradient,
    this.margin,
  }) : assert(
          (icon != null ? 1 : 0) +
                  (assetImage != null ? 1 : 0) +
                  (svgAsset != null ? 1 : 0) ==
              1,
          'Provide exactly ONE of icon, assetImage, or svgAsset.',
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          EdgeInsets.symmetric(horizontal: 0.w).copyWith(bottom: 30.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: Row(
          children: [
            _buildTrailingIcon(),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 50.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color(0xffD9D9D9).withOpacity(0.5),
                  border: Border.all(
                    color: Color(0xffCCCCCC),
                    width: 1.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10.r,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingIcon() {
    final double size = iconSize ?? 26.sp;
    final Widget child;
    if (icon != null) {
      child =
          Icon(icon, size: size, color: iconColor ?? const Color(0xFF3C3C3C));
    } else if (assetImage != null) {
      child = Image.asset(assetImage!,
          width: size, height: size, fit: BoxFit.contain);
    } else {
      child = SvgPicture.asset(svgAsset!, width: size, height: size);
    }

    return Container(
      width: 44.w,
      height: 44.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        // border: Border.all(color: const Color(0xFFEAE6E2)),
      ),
      child: child,
    );
  }
}
