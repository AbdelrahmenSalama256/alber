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
      baseColor: const Color(0xFFFFFFFF),
      highlightColor: const Color(0xFFF2F2F2),
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1600),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF2F2F2),
              Color(0xFFFFFFFF),
            ],
          ),
          borderRadius: radius,
        ),
      ),
    );
  }
}
