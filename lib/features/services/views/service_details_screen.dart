import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../home/view/widgets/donation_card.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Color? color;
  const ServiceDetailsScreen({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(),
      hasShape: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: color ?? Colors.transparent,
                      width: 1.w,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/png/service1.png",
                      width: 150.w,
                      height: 100.h,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      "كفالة يتيم",
                      style: TextStyle(
                        color: color,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                "يتم  دراسة وضع اليتيم اجتماعياً من قبل باحثات متخصصات بقسم البحوث ومن ثم يأتي دور منسقة الكفالات بإعداد بطاقة تسويقية لليتيم عن طريق منسقة علاقات  متبرعين ، وبعد ذلك  يودع مبلغ الكفالة في الحساب البنكي لليتيم ، حيث بلغ  عدد الأيتام الذين تكفلهم الجمعية الآن (1487) يتيم ويتيمة .",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF707070),
                    fontSize: 14.sp,
                    height: 2.5.h),
              ),
              SizedBox(
                height: 30.h,
              ),
              DonationCard(
                bg: Colors.transparent,
                title: 'كفالة يتيم',
                imageAsset: 'assets/images/png/news.png',
                raised: 300000,
                goal: 400000,
                initialAmount: 234,
                initialQty: 1,
                onDonate: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
