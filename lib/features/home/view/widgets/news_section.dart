import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';

import 'news_card.dart';

class NewsSection extends StatelessWidget {
  final String headingSmall;
  final String headingBig;
  final List<NewsItem> items;
  final VoidCallback? onAllNews;

  const NewsSection({
    super.key,
    required this.headingSmall,
    required this.headingBig,
    required this.items,
    this.onAllNews,
  });

  @override
  Widget build(BuildContext context) {
    final data = items.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingSmall,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          headingBig,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
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
          itemCount: 4,
          itemBuilder: (context, index) {
            if (index == 3) {
              return _AllNewsTile(onTap: onAllNews);
            }
            final n = data[index];
            return NewsCard(
              imageAsset: n.imageAsset,
              title: n.title,
              subtitle: n.subtitle,
              onTap: n.onTap,
            );
          },
        ),
      ],
    );
  }
}

class NewsItem {
  final String imageAsset;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  NewsItem({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

class _AllNewsTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _AllNewsTile({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary, width: 1.w),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                "assets/images/svg/all-news.svg",
              ),
            ),
            Center(
              child: Text(
                "all_news".tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
