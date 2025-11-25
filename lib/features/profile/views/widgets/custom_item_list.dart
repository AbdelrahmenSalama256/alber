import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  final IconData? icon;
  final String? assetImage;
  final String? svgAsset;
  final String? imagePath;

  final double? iconSize;
  final Color? iconColor;
  final List<Color>? gradient;
  final EdgeInsetsGeometry? margin;
  final Widget? trailing; // New trailing widget

  const ActionCard({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.assetImage,
    this.svgAsset,
    this.imagePath,
    this.iconSize,
    this.iconColor,
    this.gradient,
    this.margin,
    this.trailing, // Added trailing parameter
  }) : assert(
          (icon != null ? 1 : 0) +
                  (assetImage != null ? 1 : 0) +
                  (svgAsset != null ? 1 : 0) +
                  (imagePath != null ? 1 : 0) <=
              1,
          'Provide only ONE of icon, assetImage, svgAsset, or imagePath.',
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          EdgeInsets.symmetric(horizontal: 0.w).copyWith(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.85.r),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.85.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.85.r),
                color: AppColors.white.withOpacity(0.4),
                border: Border(
                    bottom: BorderSide(
                        color: AppColors.textSecondary, width: 1.03.w)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10.r,
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
                    _buildLeadingIcon(),
                    SizedBox(width: 10.w),
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
                    if (trailing != null) ...[
                      SizedBox(width: 8.w),
                      trailing!,
                    ],
                    // Default chevron icon if no trailing provided
                    if (trailing == null) ...[
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.w,
                        color: AppColors.textSecondary.withOpacity(0.6),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    final double size = iconSize ?? 26.sp;
    final Widget child;

    // If no icon type is provided, show a default container
    if (icon == null &&
        assetImage == null &&
        svgAsset == null &&
        imagePath == null) {
      return Container(
        width: 44.w,
        height: 44.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
      );
    }

    if (icon != null) {
      child =
          Icon(icon, size: size, color: iconColor ?? const Color(0xFF3C3C3C));
    } else if (assetImage != null) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          assetImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else if (svgAsset != null) {
      child = SvgPicture.asset(svgAsset!, width: size, height: size);
    } else {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: _buildDynamicImage(size),
      );
    }

    return Container(
      width: 44.w,
      height: 44.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  Widget _buildDynamicImage(double size) {
    if (imagePath == null || imagePath!.isEmpty) {
      return Icon(Icons.person_outline,
          size: size, color: const Color(0xFF3C3C3C));
    }
    final path = imagePath!;
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.person_outline, size: size, color: AppColors.textGrey),
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    final file = File(path);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
    return Icon(Icons.person_outline,
        size: size, color: AppColors.textGrey.withOpacity(0.7));
  }
}
