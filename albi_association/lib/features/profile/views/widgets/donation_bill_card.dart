import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_colors.dart';

class DonationBillCard extends StatelessWidget {
  final String tagText;
  final String code;
  final String dateText;
  final String timeText;
  final String amountText;
  final String? paymentType;
  final String? serviceNum;
  final VoidCallback? onTap;
  final VoidCallback? onEyeTap;
  final Gradient? backgroundGradient;
  final bool? isBill;
  final bool? isPayed;

  const DonationBillCard({
    super.key,
    required this.tagText,
    required this.code,
    required this.dateText,
    required this.timeText,
    required this.amountText,
    this.onTap,
    this.onEyeTap,
    this.backgroundGradient,
    this.isBill = false,
    this.isPayed = false,
    this.paymentType,
    this.serviceNum,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 6.w)),
            color: Color(0xffFAFAFA).withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap ?? () {},
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: EdgeInsets.only(bottom: 20.h),
              // height: 180.h,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  PositionedDirectional(
                    top: 0,
                    start: 0,
                    child: Container(
                      // margin: EdgeInsetsDirectional.only(top: 16.h, end: 16.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF707070),
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(18),
                          bottomEnd: Radius.circular(18),
                          topEnd: Radius.circular(0),
                          bottomStart: Radius.circular(0),
                        ),
                      ),
                      child: Text(
                        code,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 16.h,
                    end: 16.w,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 100.w,
                        minHeight: 30.h,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isPayed!
                            ? Color(0xff39C06D).withOpacity(0.4)
                            : const Color(0xFF707070).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        tagText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 16.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/svg/calender.svg"),
                                  SizedBox(width: 8.w),
                                  Text(
                                    dateText,
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              isBill!
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        paymentType != null
                                            ? Container(
                                                constraints: BoxConstraints(
                                                    minWidth:
                                                        107.31243896484375.w,
                                                    minHeight:
                                                        32.78990936279297.h),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF707070)
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Text(
                                                  "$paymentType",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        serviceNum != null
                                            ? Container(
                                                constraints: BoxConstraints(
                                                    minWidth:
                                                        107.31243896484375.w,
                                                    minHeight:
                                                        32.78990936279297.h),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF707070)
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Text(
                                                  "${"service".tr(context)} $serviceNum",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.access_time_rounded,
                                            size: 20.sp,
                                            color: AppColors.textGrey),
                                        SizedBox(width: 8.w),
                                        Text(
                                          timeText,
                                          style: TextStyle(
                                            color: AppColors.textGrey,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: 107.31243896484375.w,
                                        minHeight: 32.78990936279297.h),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF707070)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      amountText,
                                      style: TextStyle(
                                        color: const Color(0xFF707070),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 7.w),
                                  SvgPicture.asset(
                                    "assets/images/svg/currancy.svg",
                                    color: const Color(0xFF808080),
                                    width: 20.w,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          children: [
                            SizedBox(
                              width: 67.080078125.w,
                              height: 38.08142852783203.h,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Image.asset(
                                        'assets/images/png/Union.png',
                                        width: 67.080078125.w,
                                        height: 38.08142852783203.h,
                                        // fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      isBill!
                                          ? "details".tr(context)
                                          : 'bill'.tr(context),
                                      style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            InkWell(
                              onTap: onEyeTap ?? onTap ?? () {},
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF707070).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  CupertinoIcons.eye,
                                  size: 24.sp,
                                  color: const Color(0xFF707070),
                                ),
                              ),
                            ),
                          ],
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
}
