import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/news/views/news_details_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/news_card.dart';
import '../../home/view/widgets/news_section.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
      NewsItem(
        imageAsset: "assets/images/png/news.png",
        title: "جمعية البر بجدة",
        subtitle: "شهادة “تكامل”",
        onTap: () {},
      ),
    ];

    return CustomScaffold(
      hasShape: false,
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                "albir_socity_news".tr(context),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Color(0xffF1A725),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.h,
                  crossAxisSpacing: 20.w,
                  childAspectRatio: 1.5,
                ),
                itemCount: items.length, // just your news items
                itemBuilder: (context, index) {
                  final n = items[index];
                  return NewsCard(
                    imageAsset: n.imageAsset,
                    title: n.title,
                    subtitle: n.subtitle,
                    onTap: () {
                      navigateTo(context, NewsDetailsScreen());
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
