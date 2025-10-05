import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartnerLogoCard extends StatefulWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const PartnerLogoCard({
    super.key,
    required this.assetPath,
    this.onTap,
  });

  @override
  State<PartnerLogoCard> createState() => _PartnerLogoCardState();
}

class _PartnerLogoCardState extends State<PartnerLogoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _saturationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saturationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 84.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _saturationAnimation,
          builder: (context, child) {
            return ColorFiltered(
              colorFilter: ColorFilter.matrix([
                0.2126 + 0.7874 * _saturationAnimation.value,
                0.7152 - 0.7152 * _saturationAnimation.value,
                0.0722 - 0.0722 * _saturationAnimation.value,
                0,
                0,
                0.2126 - 0.2126 * _saturationAnimation.value,
                0.7152 + 0.2848 * _saturationAnimation.value,
                0.0722 - 0.0722 * _saturationAnimation.value,
                0,
                0,
                0.2126 - 0.2126 * _saturationAnimation.value,
                0.7152 - 0.7152 * _saturationAnimation.value,
                0.0722 + 0.9278 * _saturationAnimation.value,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: child,
            );
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Image.asset(
                widget.assetPath,
                height: 36.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
