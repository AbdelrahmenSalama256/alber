import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_text_field.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

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
  final VoidCallback? onDonate;
  final VoidCallback? onInfoTap;
  final ValueChanged<double>? onAmountChanged;
  final ValueChanged<int>? onQtyChanged;
  final Color accent;
  final Color? bg;
  final int? viewpercent;
  final String? heroTag;
  final List<double?>? multiValues;

  const DonationCard({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.raised,
    required this.goal,
    this.initialAmount = 100,
    this.initialQty = 1,
    this.onDonate,
    this.type,
    this.onAmountChanged,
    this.onQtyChanged,
    this.accent = const Color(0xFF3F3F3F),
    this.bg,
    this.onInfoTap,
    this.viewpercent,
    this.multiValues,
    this.heroTag,
  });

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  final _formKey = GlobalKey<FormState>();
  late double _amount;
  late int _qty;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount;
    _qty = widget.initialQty;
    _amountController =
        TextEditingController(text: widget.initialAmount.toStringAsFixed(0));
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
    final bool isKiosk = 100.w > 80.h;
    final double outerPadding = 4.w;
    final double cardRadius = 3.h;
    final double titleSize = isKiosk ? 17.sp : 15.sp;
    final double subTextSize = isKiosk ? 13.sp : 12.sp;
    final double progressHeight = isKiosk ? 1.5.h : 1.h;

    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(outerPadding),
        decoration: BoxDecoration(
          color: widget.bg ?? Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border(
              bottom: BorderSide(
                color: AppColors.primary,
                width: 0.5.w,
              ),
              top: BorderSide(
                color: AppColors.primary,
                width: 0.5.w,
              )),
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
            /// ---- Header ----
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
                SizedBox(width: isKiosk ? 3.w : 4.w),
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
                              width: isKiosk ? 6.w : 8.w,
                              height: isKiosk ? 6.w : 8.w,
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
                      SizedBox(height: 1.h),
                      Text(
                        "${'collected'.tr(context)} ${_money(widget.raised)} ${'from'.tr(context)} ${_money(widget.goal)}",
                        style: TextStyle(
                          fontSize: subTextSize,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
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

            SizedBox(height: 1.5.h),

            /// ---- Donation Amount Section ----
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(2.h),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.type != "multi") _donationSection(isKiosk),
                  if (widget.multiValues != null &&
                      widget.multiValues!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: [
                          for (final v in widget.multiValues!)
                            if (v != null)
                              _LabeledAmount(
                                amount: v,
                                selected: _amount == v,
                                onTap: () {
                                  setState(() {
                                    _amount = v;
                                    _amountController.text =
                                        v.toStringAsFixed(0);
                                  });
                                  widget.onAmountChanged?.call(v);
                                },
                              ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 1.5.h),

            /// ---- Donate Button ----
            SizedBox(
              height: isKiosk ? 7.h : 6.h,
              child: AppButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() != true) return;
                  widget.onDonate?.call();
                },
                text: 'donate_now'.tr(context),
                textStyle: TextStyle(
                  fontSize: 15.sp,
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
        /// ---- Amount Input ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'donate_amount'.tr(context),
              //   style: TextStyle(
              //     fontSize: 14.sp,
              //     color: AppColors.primary,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SizedBox(height: 1.h),
              AppTextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                borderColor: AppColors.primary.withOpacity(0.2),
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
                  padding: EdgeInsetsDirectional.only(end: 1.w),
                  child: SvgPicture.asset(
                    "assets/images/svg/currancy.svg",
                    color: AppColors.primary,
                    // width: 15.w,
                    // height: 10.h,
                    // width: 18.w,
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
            ],
          ),
        ),

        /// ---- Quantity Stepper ----
        if (widget.type == "fixed") ...[
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // Text(
                // //   'quantity'.tr(context),
                // //   style: TextStyle(
                // //     fontSize: 14.sp,
                // //     color: AppColors.primary,
                // //     fontWeight: FontWeight.w600,
                // //   ),
                // // ),
                // SizedBox(height: 1.h),
                Opacity(
                  opacity: _isAmountValid ? 1 : 0.4,
                  child: IgnorePointer(
                    ignoring: !_isAmountValid,
                    child: QtyStepper(
                      qty: _qty,
                      onChanged: (q) {
                        setState(() => _qty = q);
                        widget.onQtyChanged?.call(q);
                      },
                      accent: widget.accent,
                    ),
                  ),
                ),
              ],
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
            width: 10.w,
            height: 10.w,
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
            top: -5.h,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 7.w,
              height: 7.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/svg/currancy.svg",
                  color: Colors.white,
                  width: 4.w,
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
    final double avatarSize = 18.w;
    final double ringSize = 18.w;
    final double strokeW = 1.5.w;

    final imageWidget = SizedBox(
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
                strokeAlign: 0.5,
                value: progress,
                backgroundColor: ringColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                strokeWidth: strokeW - 1,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.network(
                imageAsset,
                fit: BoxFit.cover,
                width: avatarSize,
                height: avatarSize,
                errorBuilder: (context, _, __) => Container(
                  color: AppColors.primary.withOpacity(0.1),
                  child: Icon(CupertinoIcons.photo_camera,
                      color: AppColors.primary, size: 25.sp),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -0.5.h,
            start: 2.w,
            end: 2.w,
            child: PercentPin(
              progress: progress, // 0..1
              color: ringColor, // your ringColor
              size: 8.w, // same width you used before
              assetPath: 'assets/images/svg/pinshape.svg',
              shadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4.h,
                  offset: const Offset(0, 1),
                ),
              ],
              // optional: if your text sits too low/high, tweak this:
              // bulbPaddingFactor: 0.22,
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
}

class PercentPin extends StatelessWidget {
  final double progress; // 0..1
  final Color color; // fill color of the pin
  final double size; // width of the pin (height scales)
  final String assetPath; // pin svg path
  final List<BoxShadow>? shadow;
  final TextStyle? textStyle;

  /// The pin’s “bulb” takes the top ~75% of the shape.
  /// Tweak this if your SVG proportions differ.
  final double bulbPaddingFactor;

  const PercentPin({
    super.key,
    required this.progress,
    required this.color,
    required this.size,
    required this.assetPath,
    this.shadow,
    this.textStyle,
    this.bulbPaddingFactor = 0.25, // push text up from the tip
  });

  @override
  Widget build(BuildContext context) {
    // many pin svgs are ~1:1.35 width:height; adjust if yours differs
    const pinAspect = 1.35;
    final height = size * pinAspect;

    return SizedBox(
      width: size,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Optional soft shadow behind the pin
          if (shadow != null && shadow!.isNotEmpty)
            Container(decoration: BoxDecoration(boxShadow: shadow)),

          // The pin SVG (tinted)
          SvgPicture.asset(
            assetPath,
            width: size,
            height: height,
            fit: BoxFit.contain,
            // If your SVG doesn’t use currentColor, colorFilter is safest:
            // colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),

          // Center the % in the bulb (move up away from the tip)
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
                              fontSize: size * 0.34, // scales with pin
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
