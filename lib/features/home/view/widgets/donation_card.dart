import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.bg ?? Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: widget.bg == Colors.transparent
              ? AppColors.primary
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Progress
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Smaller Image with Progress
              _CompactDonutAvatar(
                imageAsset: widget.imageAsset,
                progress: _progress,
                ringColor: widget.accent,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGrey,
                              height: 1.3,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.more_horiz_rounded,
                          size: 24.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Progress Text
                    Text(
                      "${'collected'.tr(context)} ${_money(widget.raised)} ${'from'.tr(context)} ${_money(widget.goal)}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Progress Bar
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(widget.accent),
                      borderRadius: BorderRadius.circular(10.r),
                      minHeight: 8.h,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Frequency Selection
          _Segmented(
            options: localOptions,
            selectedIndex: _freqIndex,
            onChanged: (i) => setState(() => _freqIndex = i),
            accent: widget.accent,
          ),

          SizedBox(height: 20.h),

          // Amount and Quantity Section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: _freqIndex == 0
                ? _OneTimeDonationSection()
                : _MonthlyDonationSection(),
          ),

          SizedBox(height: 20.h),

          // Donate Button
          SizedBox(
            height: 52.h,
            child: AppButton(
              onPressed: widget.onDonate,
              text: 'donate_now'.tr(context),
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _OneTimeDonationSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'donate_amount'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Text(
                      _amount.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'currency'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'quantity'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
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
        ),
      ],
    );
  }

  Widget _MonthlyDonationSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'monthly_amount'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Text(
                      _amount.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'currency'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'months_count'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
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
        ),
      ],
    );
  }

  String _money(double v) {
    return "${v.toStringAsFixed(0)} ${'currency'.tr(context)}";
  }
}

class _CompactDonutAvatar extends StatelessWidget {
  final String imageAsset;
  final double progress;
  final Color ringColor;

  const _CompactDonutAvatar({
    required this.imageAsset,
    required this.progress,
    required this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      height: 80.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Progress Circle
          SizedBox(
            width: 100.w,
            height: 100.w,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: ringColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(ringColor),
              strokeWidth: 4.w,
            ),
          ),
          // Image
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.photo,
                        color: AppColors.primary,
                        size: 30.sp,
                      ),
                    ),
                  );
                },
                imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Percentage Badge
          Positioned(
            bottom: -2.h,
            right: -2.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: ringColor,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.r,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                "${(progress * 100).round()}%",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color accent;

  const _Segmented({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8.r,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  options[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textGrey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
