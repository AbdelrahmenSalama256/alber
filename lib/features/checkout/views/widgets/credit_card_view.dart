import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/locale/app_loacl.dart'; // للترجمة

import '../../../../core/constants/app_colors.dart';

class CreditCardView extends StatelessWidget {
  final String cardType; // مثل "Master Card" أو "Visa"
  final String cardNumber; // مثل "**** 3356"
  final String expiryDate; // مثل "11/23"
  final String imagePath; // مسار الصورة
  final bool isVisible; // حالة إظهار أو إخفاء البطاقة

  const CreditCardView({
    super.key,
    required this.cardType,
    required this.cardNumber,
    required this.expiryDate,
    required this.imagePath,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.73, sigmaY: 5.73),
        child: Container(
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: AppColors.primary.withOpacity(0.25),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  imagePath,
                  width: 88.5.w,
                  height: 54.96.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$cardType **** - $cardNumber",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "${'expiry_date'.tr(context)}: $expiryDate",
                      style: TextStyle(
                        fontSize: 11.18.sp,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 9.w),
              Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
