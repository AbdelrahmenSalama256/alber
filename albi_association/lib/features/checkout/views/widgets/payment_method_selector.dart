import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({super.key});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String selectedMethod = "credit";

  final List<Map<String, dynamic>> methods = [
    {
      "key": "credit",
      "title": "credit_card",
      "icon": "assets/images/svg/visa.svg"
    },
    {"key": "mada", "title": "mada_card", "icon": "assets/images/svg/mada.svg"},
    {
      "key": "bank",
      "title": "bank_transfer",
      "icon": "assets/images/svg/bank.svg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: methods.map((method) {
          final isSelected = selectedMethod == method["key"];
          return GestureDetector(
            onTap: () => setState(() => selectedMethod = method["key"]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.primary,
                  width: 1.2.w,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    method["icon"],
                    width: 20.w,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "${method["title"]}".tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
