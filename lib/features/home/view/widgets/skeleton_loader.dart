import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool isCircular;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = isCircular ? BorderRadius.circular(width / 2) : borderRadius;

    return Shimmer.fromColors(
      baseColor: const Color(0xFFE6E6E6), // base gray
      highlightColor: const Color(0xFFF5F5F5), // highlight gray
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6E6),
          borderRadius: radius,
        ),
      ),
    );
  }
}
