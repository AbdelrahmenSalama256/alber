import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final Color borderColor;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 66.w,
        height: 103.41401672363281.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: borderColor,
            width: 2.w,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: _buildImage(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: borderColor,
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

  Widget _buildImage() {
    if (imagePath.trim().isEmpty) {
      return _placeholder();
    }
    final normalizedPath = imagePath.trim();
    final isNetworkImage = normalizedPath.startsWith('http');
    final isSvg = normalizedPath.toLowerCase().endsWith('.svg');

    if (isNetworkImage) {
      if (isSvg) {
        return _buildSvgNetwork(normalizedPath);
      }
      return CachedNetworkImage(
        imageUrl: normalizedPath,
        width: 150.3837890625.w,
        height: 80.00215148925781.h,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _placeholder(),
      );
    }

    if (isSvg) {
      return _buildSvgAsset(normalizedPath);
    }

    return Image.asset(
      normalizedPath,
      width: 150.3837890625.w,
      height: 80.00215148925781.h,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _buildSvgNetwork(String url) {
    return SvgPicture.network(
      url,
      width: 150.3837890625.w,
      height: 80.00215148925781.h,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
    );
  }

  Widget _buildSvgAsset(String assetPath) {
    return SvgPicture.asset(
      assetPath,
      width: 150.3837890625.w,
      height: 80.00215148925781.h,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => _placeholder(isLoading: true),
    );
  }

  Widget _placeholder({bool isLoading = false}) {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: isLoading
          ? const CircularProgressIndicator(strokeWidth: 1.5)
          : Icon(
              CupertinoIcons.photo,
              color: Colors.grey.shade500,
              size: 28.sp,
            ),
    );
  }
}
