import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/home/view/widgets/news_card.dart';
import 'package:qafeel/features/news/views/news_details_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/news_cubit.dart';
import './cubit/news_state.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsCubit()..init(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(),
        body: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            final cubit = context.read<NewsCubit>();
            if (state is NewsLoading || state is NewsInitial) {
              return _loadingSkeleton(context);
            }
            if (state is NewsError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }
            final s = state as NewsLoaded;
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 200 &&
                    !cubit.isLoadingMore &&
                    s.hasMore) {
                  cubit.loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () => cubit.refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          "albir_socity_news".tr(context),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: const Color(0xffF1A725),
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
                          itemCount: s.items.length,
                          itemBuilder: (context, index) {
                            final n = s.items[index];
                            return NewsCard(
                              imageAsset: n.imageAsset,
                              title: n.title,
                              subtitle: n.subtitle,
                              onTap: () {
                                navigateTo(context, const NewsDetailsScreen());
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        if (cubit.isLoadingMore && s.hasMore)
                          const SizedBox(
                            height: 48,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _loadingSkeleton(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            SkeletonLoader(
              width: 160.w,
              height: 18.h,
              borderRadius: BorderRadius.circular(6.r),
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
              itemCount: 8,
              itemBuilder: (context, index) {
                return SkeletonLoader(
                  width: double.infinity,
                  height: 140.h,
                  borderRadius: BorderRadius.circular(12.r),
                );
              },
            ),
            SizedBox(height: 20.h),
            SkeletonLoader(
              width: 120.w,
              height: 40.h,
              borderRadius: BorderRadius.circular(10.r),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
