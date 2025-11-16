import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_text_field.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/services/service_locator.dart';

import '../../../../core/component/widgets/app_button.dart';
import '../../../shared/widgets/qty_stepper.dart';

class DonationCard extends StatefulWidget {
  final String title;
  final String imageAsset;
  final String? type;
  final double raised;
  final double goal;
  final double initialAmount;
  final int initialQty;
  final double? savedAmount;
  final int? savedQty;
  final VoidCallback? onDonate;
  final void Function(double amount, int qty, String? frequency)?
      onDonateWithSelection;
  final VoidCallback? onInfoTap;
  final ValueChanged<double>? onAmountChanged;
  final ValueChanged<int>? onQtyChanged;
  final Color accent;
  final Color? bg;
  final int? viewpercent;
  final String? heroTag;
  final List<double?>? multiValues;
  final List<String>? frequencyOptions;
  final int initialFrequencyIndex;

  const DonationCard({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.raised,
    required this.goal,
    this.initialAmount = 100,
    this.initialQty = 1,
    this.savedAmount,
    this.savedQty,
    this.onDonate,
    this.onDonateWithSelection,
    this.type,
    this.onAmountChanged,
    this.onQtyChanged,
    this.accent = const Color(0xFF3F3F3F),
    this.bg,
    this.onInfoTap,
    this.viewpercent,
    this.multiValues,
    this.heroTag,
    this.frequencyOptions,
    this.initialFrequencyIndex = 0,
  });

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  final _formKey = GlobalKey<FormState>();
  late double _amount;
  late int _qty;
  late TextEditingController _amountController;
  late int _freqIndex;

  @override
  void initState() {
    super.initState();
    _amount = widget.savedAmount ?? widget.initialAmount;
    _qty = widget.savedQty ?? widget.initialQty;
    _amountController =
        TextEditingController(text: _amount.toStringAsFixed(0));
    _freqIndex = widget.initialFrequencyIndex;
  }

  @override
  void didUpdateWidget(covariant DonationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.savedAmount != null &&
        widget.savedAmount != oldWidget.savedAmount &&
        widget.savedAmount != _amount) {
      _amount = widget.savedAmount!;
      _amountController.value = TextEditingValue(
        text: widget.savedAmount!.toStringAsFixed(0),
      );
    }
    if (widget.savedQty != null &&
        widget.savedQty != oldWidget.savedQty &&
        widget.savedQty != _qty) {
      _qty = widget.savedQty!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _progress =>
      widget.goal == 0 ? 0 : (widget.raised / widget.goal).clamp(0, 1);
  bool get _showPercentage => widget.viewpercent == 1;

  bool get _isAmountValid {
    final text = _amountController.text.trim();
    final value = double.tryParse(text);
    return text.isNotEmpty && value != null && value >= widget.initialAmount;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isKiosk = size.width > size.height * 0.8;
    final double outerPadding = 16.w;
    final double cardRadius = 20.r;
    final double titleSize = isKiosk ? 17.sp : 15.sp;
    final double subTextSize = isKiosk ? 13.sp : 12.sp;
    final double progressHeight = isKiosk ? 10.h : 8.h;

    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(outerPadding),
        decoration: BoxDecoration(
          color: widget.bg ?? Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border(
            bottom: BorderSide(color: AppColors.primary, width: 1),
            top: BorderSide(color: AppColors.primary, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Header row with avatar and stats
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CompactDonutAvatar(
                  imageAsset: widget.imageAsset,
                  progress: _progress,
                  ringColor: widget.accent,
                  showPercentage: _showPercentage,
                  heroTag: widget.heroTag,
                ),
                SizedBox(width: isKiosk ? 12.w : 16.w),
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
                                fontSize: titleSize,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onInfoTap,
                            child: Container(
                              width: isKiosk ? 24.w : 32.w,
                              height: isKiosk ? 24.w : 32.w,
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                CupertinoIcons.info,
                                size: isKiosk ? 22.sp : 18.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "${'collected'.tr(context)} ${_money(widget.raised)} ${'from'.tr(context)} ${_money(widget.goal)}",
                        style: TextStyle(
                          fontSize: subTextSize,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      LinearProgressIndicator(
                        value: _progress,
                        minHeight: progressHeight,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(widget.accent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            if ((widget.frequencyOptions != null &&
                widget.frequencyOptions!.isNotEmpty))
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _FrequencySegmented(
                  options: widget.frequencyOptions!,
                  selectedIndex: _freqIndex,
                  onChanged: (i) => setState(() => _freqIndex = i),
                  accent: widget.accent,
                ),
              ),
            //! Donation amount section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.type != "multi") _donationSection(isKiosk),
                  if (widget.multiValues != null &&
                      widget.multiValues!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Wrap(
                        spacing: 30.w,
                        runSpacing: 8.h,
                        children: [
                          for (final v in widget.multiValues!)
                            if (v != null)
                              _LabeledAmount(
                                amount: v.toDouble(),
                                selected: _amount == v,
                                onTap: () {
                                  setState(() {
                                    _amount = v.toDouble();
                                    _amountController.text =
                                        v.toStringAsFixed(0);
                                  });
                                  widget.onAmountChanged?.call(_amount);
                                },
                              ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            SizedBox(
              height: 52.h,
              child: AppButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() != true) return;
                  final freq = (widget.frequencyOptions != null &&
                          widget.frequencyOptions!.isNotEmpty)
                      ? widget.frequencyOptions![_freqIndex]
                      : null;
                  if (widget.onDonateWithSelection != null) {
                    widget.onDonateWithSelection!(_amount, _qty, freq);
                  } else {
                    widget.onDonate?.call();
                  }
                },
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
      ),
    );
  }

  Widget _donationSection(bool isKiosk) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            hintText: 'enter_amount'.tr(context),
            validator: (value) {
              final text = (value ?? '').trim();
              if (text.isEmpty) return 'enter_amount'.tr(context);
              final val = double.tryParse(text);
              if (val == null) return 'enter_valid_amount'.tr(context);
              if (val < widget.initialAmount) {
                return '${"min_amount_is".tr(context)} ${widget.initialAmount.toStringAsFixed(0)}';
              }
              return null;
            },
            suffixIcon: Padding(
              padding: EdgeInsetsDirectional.all(10.w),
              child: SvgPicture.asset(
                sl<GlobalCubit>().currencyIconAsset,
                color: AppColors.primary,
              ),
            ),
            onChanged: (value) {
              final v = double.tryParse(value);
              if (v != null) {
                setState(() => _amount = v);
                widget.onAmountChanged?.call(v);
              }
            },
          ),
        ),
        if (widget.type == "fixed") ...[
          SizedBox(width: 12.w),
          Expanded(
            child: Opacity(
              opacity: _isAmountValid ? 1 : 0.4,
              child: IgnorePointer(
                ignoring: !_isAmountValid,
                child: QtyStepper(
                  height: 50.h,
                  qty: _qty,
                  onChanged: (q) {
                    setState(() => _qty = q);
                    widget.onQtyChanged?.call(q);
                  },
                  accent: widget.accent,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _money(double v) =>
      "${v.toStringAsFixed(0)} ${'currency'.tr(context)}";
}

class _LabeledAmount extends StatelessWidget {
  final double amount;
  final bool selected;
  final VoidCallback onTap;

  const _LabeledAmount({
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.primary : AppColors.primary.withOpacity(0.4);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                amount.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: -25,
            bottom: 0,
            top: -20.h,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  sl<GlobalCubit>().currencyIconAsset,
                  color: Colors.white,
                  width: 16.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactDonutAvatar extends StatelessWidget {
  final String imageAsset;
  final double progress;
  final Color ringColor;
  final bool showPercentage;
  final String? heroTag;

  const _CompactDonutAvatar({
    required this.imageAsset,
    required this.progress,
    required this.ringColor,
    required this.showPercentage,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final double avatarSize = 72.w;
    final double ringSize = 72.w;
    final double strokeW = 6.w;
    final double ringRadius = ringSize / 2;
    final double strokeRadius = (ringSize - strokeW) / 2;

    double angle = 2 * pi * progress - (pi / 2);
    double pinX = ringRadius + strokeRadius * cos(angle);
    double pinY = ringRadius + strokeRadius * sin(angle);

    Widget imageWidget = SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (!showPercentage)
            SizedBox(
              width: ringSize,
              height: ringSize,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: ringColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                strokeWidth: strokeW - 4,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: _buildImage(imageAsset, avatarSize),
            ),
          ),
          //! Progress pin positioned along the ring
          PositionedDirectional(
            end: pinX - 16.w,
            top: pinY - 35.w,
            child: PercentPin(
              progress: progress,
              color: ringColor,
              size: 32.w,
              assetPath: 'assets/images/svg/pinshape.svg',
              shadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(tag: heroTag!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildImage(String path, double size) {
    final isNetwork = path.startsWith('http');
    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, _, __) => Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.primary.withOpacity(0.1),
          child:
              Icon(Icons.photo_camera, color: AppColors.primary, size: 25.sp),
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: size,
      height: size,
      errorBuilder: (context, _, __) => Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primary.withOpacity(0.1),
        child: Icon(CupertinoIcons.photo_camera,
            color: AppColors.primary, size: 25.sp),
      ),
    );
  }
}

class PercentPin extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final String assetPath;
  final List<BoxShadow>? shadow;
  final TextStyle? textStyle;
  final double bulbPaddingFactor;

  const PercentPin({
    super.key,
    required this.progress,
    required this.color,
    required this.size,
    required this.assetPath,
    this.shadow,
    this.textStyle,
    this.bulbPaddingFactor = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    const pinAspect = 1.35;
    final height = size * pinAspect;

    return SizedBox(
      width: size,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (shadow != null && shadow!.isNotEmpty)
            Container(decoration: BoxDecoration(boxShadow: shadow)),
          SvgPicture.asset(
            assetPath,
            width: size,
            height: height,
            fit: BoxFit.contain,
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, c) {
                final h = c.maxHeight;
                return Padding(
                  padding: EdgeInsets.only(bottom: h * bulbPaddingFactor),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${(progress * 100).round()}%',
                        style: textStyle ??
                            TextStyle(
                              fontSize: size * 0.34,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1.0,
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FrequencySegmented extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color accent;

  const _FrequencySegmented({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(options.length, (i) {
        final sel = i == selectedIndex;
        return Padding(
          padding: EdgeInsetsDirectional.only(end: 8.w),
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: sel ? accent : Colors.transparent,
                border: Border.all(color: accent.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                options[i].tr(context),
                style: TextStyle(
                  color: sel ? Colors.white : accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
