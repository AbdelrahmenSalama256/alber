import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  final IconData? icon; // Material icon
  final String? assetImage; // assets/my_icon.png
  final String? svgAsset; // assets/my_icon.svg

  final double? iconSize; // optional override
  final Color? iconColor; // for IconData only
  final List<Color>? gradient; // custom gradient if you want
  final EdgeInsetsGeometry? margin;

  const ActionCard({
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
          EdgeInsets.symmetric(horizontal: 0.w).copyWith(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.85),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.85),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.85),
                color: AppColors.white.withOpacity(0.4),
                border: Border(
                    bottom: BorderSide(
                        color: AppColors.textSecondary, width: 1.03.w)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildTrailingIcon(),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2B2B2B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: const Color(0xFFEAE6E2)),
      ),
      child: child,
    );
  }
}
