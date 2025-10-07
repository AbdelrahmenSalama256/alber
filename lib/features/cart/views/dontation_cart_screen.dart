import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/checkout/views/checkout_screen.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/profile/views/widgets/cart_item.dart';
import 'package:qafeel/features/shared/widgets/section_header.dart';

import '../../../core/constants/app_colors.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class DontationCartScreen extends StatelessWidget {
  const DontationCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit()..load(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(isCart: true),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SectionHeader(
                      leadingType: HeaderLeadingType.svg,
                      svgAsset: "assets/images/svg/donation-cart.svg",
                      isLoading: true,
                      skeletonWidth: 150,
                      skeletonHeight: 24,
                      skeletonRadius: BorderRadius.circular(6.r),
                      leadingSize: 30,
                      spacing: 15,
                      center: true,
                      padding: EdgeInsets.only(top: 40.h),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      width: double.infinity,
                      height: 160.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    SizedBox(height: 160.h),
                    Container(
                      width: double.infinity,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              );
            }
            final s = state as CartLoaded;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SectionHeader(
                        leadingType: HeaderLeadingType.svg,
                        svgAsset: "assets/images/svg/donation-cart.svg",
                        title: "donation_cart".tr(context),
                        textStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        leadingSize: 30,
                        spacing: 15,
                        center: true,
                        padding: EdgeInsets.only(top: 40.h),
                      ),
                      SizedBox(height: 30.h),
                      ...List.generate(s.items.length, (i) {
                        final it = s.items[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: CartItem(
                            imageAsset: it['imageAsset'],
                            tagText: it['tagText'],
                            amountText: it['amountText'],
                            bottomTitle: it['bottomTitle'],
                            initialQty: it['qty'],
                            onQtyChanged: (q) =>
                                context.read<CartCubit>().updateQty(i, q),
                            onDelete: () {},
                            onTap: () {},
                          ),
                        );
                      }),
                      SizedBox(height: 200.h),
                    ],
                  ),
                ),
                if (s.showPayPanel)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
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
                                        color: AppColors.primary, width: 2.w)),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DashedRRect(
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
                                        borderRadius:
                                            BorderRadius.circular(14.r),
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
                                                "${s.total}",
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
                                      backgroundColor: AppColors.textSecondary,
                                      onPressed: () => navigateTo(
                                          context, const CheckoutScreen()),
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
            );
          },
        ),
      ),
    );
  }
}

class DashedRRect extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final Color color;
  final Widget child;

  const DashedRRect({
    super.key,
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
        canvas.drawPath(
            metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return radius != oldDelegate.radius ||
        strokeWidth != oldDelegate.strokeWidth ||
        dashWidth != oldDelegate.dashWidth ||
        dashGap != oldDelegate.dashGap ||
        color != oldDelegate.color;
  }
}
