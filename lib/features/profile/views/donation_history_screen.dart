import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import 'widgets/donation_bill_card.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              DonationBillCard(
                tagText: 'إهداء',
                code: 'BIR-060278',
                dateText: '25 - 08 - 2025',
                timeText: '16:30:00',
                amountText: '1123.00',
                onTap: () {
                  // open details
                },
                onEyeTap: () {
                  // preview invoice
                },
              ),
              SizedBox(height: 12.h),
              DonationBillCard(
                tagText: 'تبرع',
                code: 'BIR-060310',
                dateText: '26 - 08 - 2025',
                timeText: '10:15:00',
                amountText: '250.00',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
