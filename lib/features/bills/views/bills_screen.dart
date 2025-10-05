import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';
import '../../profile/views/widgets/donation_bill_card.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasShape: false,
      appBar: CustomTopBar(
        onBack: () {
          context.read<GlobalCubit>().changeBottomNavIndex(2);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/svg/nav/recipts.svg",
                    width: 30.w,
                  ),
                  SizedBox(width: 20.h),
                  Text(
                    "recipts".tr(context),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              DonationBillCard(
                tagText: 'غير مدفوعة',
                code: 'BIR-060278',
                isBill: false,
                dateText: '25 - 08 - 2025',
                timeText: '16:30:00',
                amountText: '1123.00',
                // primaryChipText: 'تحويل بنكي',
                // secondaryChipText: 'خدمة (2)',
              ),
              SizedBox(height: 12.h),
              DonationBillCard(
                tagText: 'مدفوعة',
                code: 'BIR-060278',
                isBill: true,
                isPayed: true,
                paymentType: "asdasd",
                serviceNum: "231",
                dateText: '25 - 08 - 2025',
                timeText: '16:30:00',
                amountText: '1123.00',
                // primaryChipText: 'تحويل بنكي',
                // secondaryChipText: 'خدمة (2)',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
