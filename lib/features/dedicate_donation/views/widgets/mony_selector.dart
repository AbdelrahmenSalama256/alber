import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class MoneySelector extends StatefulWidget {
  const MoneySelector({super.key});

  @override
  State<MoneySelector> createState() => _MoneySelectorState();
}

class _MoneySelectorState extends State<MoneySelector> {
  int selectedAmount = 50;

  final List<int> amounts = [500, 400, 300, 200, 100, 50, 25, 10];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: amounts.map((amount) {
          final isSelected = amount == selectedAmount;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAmount = amount;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.97, sigmaY: 2.97),
                child: AnimatedContainer(
                  constraints: BoxConstraints(minWidth: 100.w),
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: isSelected
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFFF8F8F8), Color(0xFFFFF0F0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    color: isSelected ? AppColors.primary : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 4.r,
                        offset: Offset(0, 2.h),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$amount',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textGrey,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      SvgPicture.asset(
                        "assets/images/svg/currancy.svg",
                        width: 15.w,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
