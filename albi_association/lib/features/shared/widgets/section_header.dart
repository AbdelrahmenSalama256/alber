import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/features/home/view/widgets/skeleton_loader.dart';
import 'package:sizer/sizer.dart';

enum HeaderLeadingType { none, svg, image, icon }

class SectionHeader extends StatelessWidget {
  final HeaderLeadingType leadingType;
  final String? title;
  final TextStyle? textStyle;
  final String? svgAsset;
  final String? imageAsset;
  final IconData? iconData;
  final Color? iconColor;
  final double leadingSize;
  final double spacing;
  final bool center;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final double skeletonWidth;
  final double skeletonHeight;
  final BorderRadius? skeletonRadius;

  const SectionHeader({
    super.key,
    this.leadingType = HeaderLeadingType.none,
    this.title,
    this.textStyle,
    this.svgAsset,
    this.imageAsset,
    this.iconData,
    this.iconColor,
    double? leadingSize,
    double? spacing,
    this.center = true,
    EdgeInsetsGeometry? padding,
    this.isLoading = false,
    double? skeletonWidth,
    double? skeletonHeight,
    this.skeletonRadius,
  })  : leadingSize = leadingSize ?? 22.0,
        spacing = spacing ?? 15.0,
        padding = padding ?? EdgeInsets.zero,
        skeletonWidth = skeletonWidth ?? 140.0,
        skeletonHeight = skeletonHeight ?? 22.0;

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ??
        TextStyle(
          color: AppColors.textSecondary,
          fontSize: 22.sp,
          fontWeight: FontWeight.w800,
        );

    final row = Row(
      mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingType != HeaderLeadingType.none) _buildLeading(),
        if (leadingType != HeaderLeadingType.none) SizedBox(width: 12.w),
        if (title != null && title!.isNotEmpty)
          isLoading
              ? SkeletonLoader(
                  width: skeletonWidth.w,
                  height: skeletonHeight.h,
                  borderRadius: skeletonRadius ?? BorderRadius.circular(6),
                )
              : Text(title!, style: ts),
      ],
    );

    if (leadingType == HeaderLeadingType.image &&
        (title == null || title!.isEmpty)) {
      return Padding(
        padding: padding,
        child: isLoading
            ? SkeletonLoader(
                width: skeletonWidth.w,
                height: skeletonHeight.h,
                borderRadius: skeletonRadius ?? BorderRadius.circular(8),
              )
            : Center(
                child: Image.asset(
                  imageAsset ?? "",
                  width: leadingSize.w,
                  height: leadingSize.h,
                  fit: BoxFit.contain,
                ),
              ),
      );
    }

    return Padding(padding: padding, child: row);
  }

  Widget _buildLeading() {
    switch (leadingType) {
      case HeaderLeadingType.svg:
        return SvgPicture.asset(
          svgAsset ?? "",
          width: 30.w,
          color: AppColors.textSecondary,
          fit: BoxFit.contain,
        );
      case HeaderLeadingType.image:
        return Image.asset(
          imageAsset ?? "",
          width: leadingSize.w,
          height: leadingSize.w,
          fit: BoxFit.contain,
        );
      case HeaderLeadingType.icon:
        return Icon(
          iconData ?? CupertinoIcons.info_circle,
          color: iconColor ?? AppColors.textSecondary,
          size: leadingSize.sp,
        );
      case HeaderLeadingType.none:
        return const SizedBox.shrink();
    }
  }
}
