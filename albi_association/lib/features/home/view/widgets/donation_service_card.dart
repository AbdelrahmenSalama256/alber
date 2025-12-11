import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/component/widgets/app_button.dart';

class DonationServiceCard extends StatefulWidget {
  final String title;
  final String imageAsset;
  final String? badgeSvg;
  final int initialQty;
  final double amount;
  final VoidCallback? onDonate;
  final ValueChanged<int>? onQtyChanged;

  const DonationServiceCard({
    super.key,
    required this.title,
    required this.imageAsset,
    this.badgeSvg,
    this.initialQty = 1,
    required this.amount,
    this.onDonate,
    this.onQtyChanged,
  });

  @override
  State<DonationServiceCard> createState() => _DonationServiceCardState();
}

class _DonationServiceCardState extends State<DonationServiceCard> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.initialQty;
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = 220.w;
    final double imageHeight = 117.42403411865234.h;
    final double buttonHeight = 39.14134979248047.h;

    return SizedBox(
      width: cardWidth,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: Image.asset(
                    widget.imageAsset,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabeledAmount(
                            label: "donate_amount".tr(context),
                            amount: widget.amount,
                          ),
                          _LabeledQty(
                            label: "quantity".tr(context),
                            qty: _qty,
                            onDec: () {
                              if (_qty > 1) {
                                setState(() => _qty--);
                                widget.onQtyChanged?.call(_qty);
                              }
                            },
                            onInc: () {
                              setState(() => _qty++);
                              widget.onQtyChanged?.call(_qty);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: buttonHeight,
                        width: double.infinity,
                        child: AppButton(
                          onPressed: widget.onDonate,
                          text: "donate_now".tr(context),
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
              ],
            ),
          ),
          Positioned(
            top: -30.h,
            child: Container(
              width: 79.98448944091797.w,
              height: 79.98448944091797.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: widget.badgeSvg == null
                    ? Icon(Icons.volunteer_activism,
                        color: AppColors.primary, size: 26.sp)
                    : Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Image.asset(widget.badgeSvg!,
                            color: AppColors.primary),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledQty extends StatelessWidget {
  final String label;
  final int qty;
  final VoidCallback onDec;
  final VoidCallback onInc;

  const _LabeledQty({
    required this.label,
    required this.qty,
    required this.onDec,
    required this.onInc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 28.h,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleIconBtn(icon: Icons.add, onTap: onInc),
              SizedBox(width: 10.w),
              Text(
                "$qty",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                ),
              ),
              SizedBox(width: 10.w),
              _CircleIconBtn(icon: Icons.remove, onTap: onDec),
            ],
          ),
        ),
      ],
    );
  }
}

class LabeledAmount extends StatelessWidget {
  final String label;
  final double amount;

  const LabeledAmount({
    super.key,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Stack(
          clipBehavior: Clip.none,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 37.439552307128906.w,
              height: 37.439552307128906.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  amount.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            PositionedDirectional(
              end: -15.w,
              top: 0,
              bottom: -10.h,
              child: Container(
                width: 22.974267959594727.w,
                height: 22.974267959594727.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset("assets/images/svg/currancy.svg"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 22.w,
        height: 22.w,
        decoration: const BoxDecoration(
          color: AppColors.textGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14.sp, color: Colors.white),
      ),
    );
  }
}
