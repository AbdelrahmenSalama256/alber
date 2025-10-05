import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';

import 'partner_logo_card.dart';

class PartnersSection extends StatelessWidget {
  final String smallHeading;
  final String bigHeading;
  final List<String> logos;
  final VoidCallback? onAllPartners;

  const PartnersSection({
    super.key,
    required this.smallHeading,
    required this.bigHeading,
    required this.logos,
    this.onAllPartners,
  });

  @override
  Widget build(BuildContext context) {
    final visible = math.min(3, logos.length);
    final totalItems = visible + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          smallHeading,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          bigHeading,
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 84.h,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: totalItems,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              if (index == totalItems - 1) {
                return _AllPartnersTile(onTap: onAllPartners);
              }
              return SizedBox(
                width: 160.w,
                child: PartnerLogoCard(
                  assetPath: logos[index],
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AllPartnersTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _AllPartnersTile({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 160.w,
        height: 84.h,
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFBEBEBE)),
        ),
        child: Center(
          child: Text(
            "كل الشركاء",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}
