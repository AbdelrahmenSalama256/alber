import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/skeleton_loader.dart';
import 'package:qafeel/features/services/views/sub_services_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../core/cubit/global_cubit.dart';
import '../../home/view/widgets/counter_wrapper_main.dart';
import '../../home/view/widgets/custom_top_bar.dart';
import '../../home/view/widgets/service_card.dart';
import '../view/cubit/services_cubit.dart';
import '../view/cubit/services_state.dart';

class ServicesScreen extends StatelessWidget {
  final bool? isFromHome;
  const ServicesScreen({super.key, this.isFromHome});

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 1200;

    return CounterWrapperMain(
      child: BlocProvider(
        create: (_) => ServicesCubit()..load(),
        child: BlocBuilder<ServicesCubit, ServicesState>(
          builder: (context, state) {
            return CustomScaffold(
              hasShape: false,
              body: Column(
                children: [
                  CustomTopBar(
                    isHome: false,
                    onBack: () {
                      if (isFromHome ?? false) {
                        Navigator.pop(context);
                      } else {
                        context.read<GlobalCubit>().changeBottomNavIndex(2);
                      }
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: _buildBody(context, state, isKiosk),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ServicesState state, bool isKiosk) {
    if (state is ServicesLoading) {
      return _buildSkeleton(isKiosk);
    }

    if (state is ServicesError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            state.message,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: !isKiosk ? 14.sp : 12.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state is ServicesLoaded) {
      final loaded = state;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Title section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/images/svg/nav/services.svg",
                width: 5.w,
                // color: AppColors.orange,
              ),
              SizedBox(width: 2.4.w),
              Text(
                "services".tr(context),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: !isKiosk ? 18.sp : 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          /// Services list
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 8.h),
            itemCount: loaded.sections.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // ✅ two in a row
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.h,
              childAspectRatio: 1, // ✅ keep tiles square
            ),
            itemBuilder: (context, index) {
              final section = loaded.sections[index];
              final imgKey = (section.image ?? section.cover ?? '').trim();
              final baseColor =
                  loaded.extractedColors[imgKey] ?? AppColors.primary;
              final color = baseColor;
              return ServiceCard(
                title: section.title,
                imagePath: section.image ?? section.cover ?? '',
                // /: section.servicesCount.toString(),
                overrideColor: color,
                onTap: () => navigateTo(
                  context,
                  SubServicesScreen(
                    color: color,
                    imagePath: section.image ?? section.cover ?? '',
                    sectionId: section.id,
                    sectionTitle: section.title,
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSkeleton(bool isKiosk) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 6.h),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonLoader(
                width: !isKiosk ? 6.w : 10.w,
                height: 5.h,
                borderRadius: BorderRadius.circular(1.h),
              ),
              SizedBox(width: 3.w),
              SkeletonLoader(
                width: 25.w,
                height: 3.h,
                borderRadius: BorderRadius.circular(1.h),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 8.h),
          itemCount: 6,
          separatorBuilder: (_, __) => SizedBox(height: 3.h),
          itemBuilder: (context, index) {
            return SkeletonLoader(
              width: double.infinity,
              height: !isKiosk ? 30.h : 20.h,
              borderRadius: BorderRadius.circular(2.h),
            );
          },
        ),
      ],
    );
  }
}
