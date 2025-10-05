import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Image.asset(
                "assets/images/png/alber-inline-logo.png",
                width: 148.w,
                height: 40.88997268676758.h,
              ),
              SizedBox(
                height: 20.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.18), // glassy fill
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.28),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "تأسست جمعية البر بجدة في 25/12/1402هـ وهي جمعية خيرية ذات شخصية اعتبارية تشمل خدماتها محافظة جدة وما حولها من القرى , ورئيسها الفخري صاحب السمو  الملكي أمير منطقة مكة المكرمة , وتعمل تحت إشراف وزارة الموارد البشرية  والتنمية الاجتماعية ومسجلة برقم 62 .",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          height: 2.5.h),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
