import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

typedef DonationConfirmCallback = void Function(
  int unitAmount,
  int quantity,
  int total,
);

class DonationConfirmationDialog extends StatelessWidget {
  final String serviceName;
  final int amount;
  final int quantity;
  final VoidCallback onConfirm;
  final DonationConfirmCallback? onConfirmWithTotals;

  const DonationConfirmationDialog({
    super.key,
    required this.serviceName,
    required this.amount,
    required this.quantity,
    required this.onConfirm,
    this.onConfirmWithTotals,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    final safeQty = quantity < 0 ? 0 : quantity;
    final safeAmount = amount < 0 ? 0 : amount;
    final total = safeAmount * safeQty;
    final localeName = Localizations.localeOf(context).toString();
    final numberFormat = NumberFormat.decimalPattern(localeName);

    final double dialogRadius = 4.h;
    final double paddingAll = 4.w;
    final double logoSize = 18.w;
    final double iconSize = 22.sp;
    final double fontNormal = 18.sp;
    final double fontLarge = 18.sp;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dialogRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.all(paddingAll),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(dialogRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            // ✅ Wrap long content with scrollable container
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🟡 Logo
                  Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffF1A725).withOpacity(0.2),
                    ),
                    padding: EdgeInsets.all(4.w),
                    child: SvgPicture.asset(
                      "assets/images/svg/currancy.svg",
                      color: const Color(0xffF1A725),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // 🟢 Title
                  Text(
                    'comfirm_donation'.tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: fontLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // 🧾 Details Box
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isKiosk ? 3.w : 4.w,
                      vertical: isKiosk ? 2.h : 3.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.h),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.grey.withOpacity(0.08),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.grey.withOpacity(0.3),
                        width: 0.5.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildRow(
                          icon: CupertinoIcons.heart_fill,
                          label: 'service'.tr(context),
                          value: serviceName,
                          color: AppColors.primary,
                          fontNormal: fontNormal,
                          fontLarge: fontLarge,
                          iconSize: iconSize,
                        ),
                        SizedBox(height: 1.5.h),
                        _buildRow(
                          icon: CupertinoIcons.money_dollar_circle_fill,
                          label: 'amount'.tr(context),
                          value: numberFormat.format(safeAmount),
                          color: AppColors.primary,
                          svgIcon: "assets/images/svg/currancy.svg",
                          fontNormal: fontNormal,
                          fontLarge: fontLarge,
                          iconSize: iconSize,
                        ),
                        SizedBox(height: 1.5.h),
                        _buildRow(
                          icon: Icons.shopping_cart,
                          label: 'quantity'.tr(context),
                          value: numberFormat.format(safeQty),
                          color: AppColors.primary,
                          fontNormal: fontNormal,
                          fontLarge: fontLarge,
                          iconSize: iconSize,
                        ),
                        Divider(
                          height: 3.h,
                          color: AppColors.grey.withOpacity(0.3),
                        ),
                        _buildRow(
                          icon: Icons.calculate,
                          label: 'total'.tr(context),
                          value: numberFormat.format(total),
                          color: const Color(0xffF1A725),
                          svgIcon: "assets/images/svg/currancy.svg",
                          isBold: true,
                          fontNormal: fontNormal,
                          fontLarge: fontLarge,
                          iconSize: iconSize,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // 🟣 Buttons
                  SizedBox(
                    height: 8.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onPressed: () => Navigator.pop(context),
                            backgroundColor: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                            text: "cancel".tr(context),
                            textStyle: TextStyle(
                              fontSize: fontNormal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: AppButton(
                            onPressed: () {
                              onConfirmWithTotals?.call(
                                  safeAmount, safeQty, total);
                              onConfirm();
                            },
                            backgroundColor: const Color(0xffF1A725),
                            borderRadius: BorderRadius.circular(30),
                            text: "confirm".tr(context),
                            textStyle: TextStyle(
                              fontSize: fontNormal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double fontNormal,
    required double fontLarge,
    required double iconSize,
    String? svgIcon,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✅ Left side (icon + label)
          Flexible(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: const Color(0xffF1A725),
                  size: isBold ? iconSize + 4 : iconSize,
                ),
                SizedBox(width: 2.w),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: isBold ? fontLarge : fontNormal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ✅ Right side (value + optional svg)
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: isBold ? fontLarge : fontNormal,
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
                if (svgIcon != null) ...[
                  SizedBox(width: 1.w),
                  SvgPicture.asset(
                    svgIcon,
                    width: 4.w,
                    color: const Color(0xffF1A725),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
