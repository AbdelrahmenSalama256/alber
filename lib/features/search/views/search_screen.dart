// lib/features/search/views/search_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/news/views/news_details_screen.dart';

import '../../../core/component/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import '../../home/view/widgets/news_card.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/search_cubit.dart';
import './cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit()..init(),
      child: CustomScaffold(
        hasShape: false,
        appBar: CustomTopBar(
          isSearch: true,
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final cubit = context.read<SearchCubit>();
            if (state is SearchLoading || state is SearchInitial) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      _Header(),
                      SizedBox(height: 16.h),
                      AppTextField(
                        controller: cubit.searchC,
                        hintText: "search_hint".tr(context),
                        onChanged: cubit.onQueryChanged,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Icon(Icons.search,
                              color: AppColors.textGrey, size: 20.sp),
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
                        itemCount: 6,
                        itemBuilder: (_, __) => SkeletonLoader(
                          width: double.infinity,
                          height: 140.h,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final s = state as SearchLoaded;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    _Header(),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: cubit.searchC,
                      hintText: "search_hint".tr(context),
                      onChanged: cubit.onQueryChanged,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.search,
                            color: AppColors.textGrey, size: 20.sp),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    if (s.results.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 60.h),
                        child: Text(
                          "no_results".tr(context),
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
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
                        itemCount: s.results.length,
                        itemBuilder: (context, index) {
                          final n = s.results[index];
                          return NewsCard(
                            imageAsset: n["image"]!,
                            title: n["title"]!,
                            subtitle: n["subtitle"]!,
                            onTap: () {
                              navigateTo(context, NewsDetailsScreen());
                            },
                          );
                        },
                      ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(CupertinoIcons.search,
            color: AppColors.textSecondary, size: 25.sp),
        SizedBox(width: 10.w),
        Text(
          "search".tr(context),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
