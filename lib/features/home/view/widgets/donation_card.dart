import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';

import '../../../../core/component/widgets/app_button.dart';
import '../../../shared/widgets/qty_stepper.dart';

class DonationCard extends StatefulWidget {
  final String title;
  final String imageAsset;
  final double raised;
  final double goal;
  final double initialAmount;
  final int initialQty;
  final VoidCallback? onDonate;
  final ValueChanged<double>? onAmountChanged;
  final ValueChanged<int>? onQtyChanged;
  final List<String> frequencyOptions;
  final int initialFrequencyIndex;
  final Color accent;
  final Color? bg;

  const DonationCard({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.raised,
    required this.goal,
    this.initialAmount = 100,
    this.initialQty = 1,
    this.onDonate,
    this.onAmountChanged,
    this.onQtyChanged,
    this.frequencyOptions = const ["once", "monthly"],
    this.initialFrequencyIndex = 0,
    this.accent = const Color(0xFF3F3F3F),
    this.bg,
  });

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  late double _amount;
  late int _qty;
  late int _freqIndex;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount;
    _qty = widget.initialQty;
    _freqIndex = widget.initialFrequencyIndex;
  }

  double get _progress =>
      widget.goal == 0 ? 0 : (widget.raised / widget.goal).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final localOptions = [
      'one_time'.tr(context),
      'monthly_commitment'.tr(context)
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: widget.bg ?? Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
            bottom: widget.bg == Colors.transparent
                ? BorderSide(color: AppColors.primary, width: 1)
                : BorderSide(),
            top: widget.bg == Colors.transparent
                ? BorderSide(color: AppColors.primary, width: 1)
                : BorderSide()),
        boxShadow: widget.bg == Colors.transparent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12.r,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 139.1837615966797.w,
            height: 139.1837615966797.w,
            child: _DonutAvatar(
                imageAsset: widget.imageAsset,
                progress: _progress,
                ringColor: widget.accent),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Icon(
                      Icons.more_horiz_rounded,
                      size: 30.sp,
                      color: AppColors.textSecondary,
                    )),
                Text(widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textGrey)),
                SizedBox(height: 8.h),
                Text(
                  "${'collected'.tr(context)} ${_money(widget.raised)} ${'from'.tr(context)} ${_money(widget.goal)}",
                  style: TextStyle(
                      fontSize: 8.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _Segmented(
                        options: localOptions,
                        selectedIndex: _freqIndex,
                        onChanged: (i) => setState(() => _freqIndex = i),
                        accent: widget.accent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                if (_freqIndex == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('donate_amount'.tr(context),
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 5.h),
                          Container(
                            height: 19.115312576293945.h,
                            width: 52.567108154296875.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.textSecondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r)),
                            child: Text("$_amount",
                                style: TextStyle(
                                    fontSize: 8.96.sp,
                                    color: AppColors.textGrey,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('quantity'.tr(context),
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 5.h),
                          QtyStepper(
                            qty: _qty,
                            onChanged: (q) {
                              setState(() => _qty = q);
                              widget.onQtyChanged?.call(q);
                            },
                            accent: widget.accent,
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('monthly_amount'.tr(context),
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 5.h),
                          Container(
                            height: 19.115312576293945.h,
                            width: 52.567108154296875.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.textSecondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r)),
                            child: Text("$_amount",
                                style: TextStyle(
                                    fontSize: 8.96.sp,
                                    color: AppColors.textGrey,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('months_count'.tr(context),
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 5.h),
                          QtyStepper(
                            qty: _qty,
                            onChanged: (q) {
                              setState(() => _qty = q);
                              widget.onQtyChanged?.call(q);
                            },
                            accent: widget.accent,
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 40.h,
                  child: AppButton(
                    onPressed: widget.onDonate,
                    text: 'donate_now'.tr(context),
                    textStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _money(double v) {
    return "${v.toStringAsFixed(0)} ${'currency'.tr(context)}";
  }
}

class _DonutAvatar extends StatelessWidget {
  final String imageAsset;
  final double progress;
  final Color ringColor;

  const _DonutAvatar(
      {required this.imageAsset,
      required this.progress,
      required this.ringColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              painter: _DonutPainter(progress: progress, color: ringColor),
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: ClipOval(
                  child: Image.asset(imageAsset,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: -5.h,
              end: 0.w,
              start: 0.w,
              child: _PercentPin(
                  text: "${(progress * 100).round()}%",
                  fill: Colors.white,
                  textColor: ringColor),
            ),
          ],
        );
      },
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double progress;
  final Color color;

  _DonutPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 10.0.w;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide / 2) - stroke / 2;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color.withOpacity(0.2)
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -90 * math.pi / 180, 2 * math.pi, false, bgPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -90 * math.pi / 180, 2 * math.pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _Segmented extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color accent;

  const _Segmented(
      {required this.options,
      required this.selectedIndex,
      required this.onChanged,
      required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.r)),
      child: Row(
        children: List.generate(options.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.r)),
                child: Text(
                  options[i],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.white : AppColors.textGrey),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PercentPin extends StatelessWidget {
  final String text;
  final Color fill;
  final Color textColor;

  const _PercentPin(
      {required this.text, required this.fill, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final w = 44.w;
    final h = 44.h;
    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset("assets/images/svg/pinshape.svg",
              width: w, height: h),
          Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Text(text,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor)),
          ),
        ],
      ),
    );
  }
}
