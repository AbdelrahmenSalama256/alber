import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/profile/views/widgets/cart_item.dart';

import '../../../core/constants/app_colors.dart';

class DontationCartScreen extends StatefulWidget {
  const DontationCartScreen({super.key});

  @override
  State<DontationCartScreen> createState() => _DontationCartScreenState();
}

class _DontationCartScreenState extends State<DontationCartScreen> {
  bool _showPayPanel = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showPayPanel = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(isCart: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/donation-cart.svg",
                        width: 20.w,
                      ),
                      SizedBox(width: 20.h),
                      Text(
                        "donation_cart".tr(context),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  CartItem(
                    imageAsset: "assets/images/png/news.png",
                    tagText: "الزكاة والصدقة",
                    amountText: "3333",
                    bottomTitle: "إطعام مسكين",
                    initialQty: 1,
                    onQtyChanged: (q) {},
                    onDelete: () {},
                    onTap: () {},
                  ),
                  SizedBox(height: 180.h),
                ],
              ),
            ),
          ),
          if (_showPayPanel)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12.r,
                              offset: Offset(0, -4.h),
                              color: AppColors.black.withOpacity(0.2),
                            ),
                          ],
                          border: Border(
                            top: BorderSide(
                                color: AppColors.primary, width: 2.w),
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _DashedRRect(
                              radius: 14.r,
                              strokeWidth: 1.5,
                              dashWidth: 6,
                              dashGap: 4,
                              color: AppColors.primary,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "total".tr(context),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "1500",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        SvgPicture.asset(
                                          "assets/images/svg/currancy.svg",
                                          width: 15.w,
                                          color: AppColors.textGrey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: AppButton(
                                onPressed: () {},
                                text: "pay_now".tr(context),
                                textStyle: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
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
            ),
        ],
      ),
    );
  }
}

class _DashedRRect extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final Color color;
  final Widget child;

  const _DashedRRect({
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        radius: radius,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashGap: dashGap,
        color: color,
      ),
      child: child,
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final Color color;

  _DashedRRectPainter({
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect =
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, distance + len),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      radius != oldDelegate.radius ||
      strokeWidth != oldDelegate.strokeWidth ||
      dashWidth != oldDelegate.dashWidth ||
      dashGap != oldDelegate.dashGap ||
      color != oldDelegate.color;
}
