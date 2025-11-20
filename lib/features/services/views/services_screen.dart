import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/service_card.dart';
import 'package:qafeel/features/home/view/widgets/skeleton_loader.dart';
import 'package:qafeel/features/services/views/service_details_screen.dart';
import 'package:qafeel/core/services/service_locator.dart';

import '../../home/view/widgets/custom_top_bar.dart';
import 'cubit/services_cubit.dart';
import 'cubit/services_state.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServicesCubit>()..fetchServices(),
      child: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          return CustomScaffold(
            hasShape: false,
            appBar: CustomTopBar(
              isHome: false,
              onBack: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.read<GlobalCubit>().changeBottomNavIndex(2);
                }
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: _buildBody(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ServicesState state) {
    if (state is ServicesLoading) {
      return _buildSkeleton();
    }

    if (state is ServicesError) {
      return Center(
        child: Text(
          state.message,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state is ServicesLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/svg/nav/services.svg",
                width: 20.w,
              ),
              SizedBox(width: 20.h),
              Text(
                "services".tr(context),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          //! Services grid (same layout as Home)
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 16.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.8,
            ),
            itemCount: state.services.length,
            itemBuilder: (context, index) {
              final service = state.services[index];
              final imagePath = service.image;
              final color = state.extractedColors[service.id] ??
                  state.extractedColors[imagePath] ??
                  AppColors.primary.withOpacity(.3);
              return ServiceCard(
                imagePath: imagePath,
                title: service
                    .titleForLanguage(context.read<GlobalCubit>().language),
                borderColor: color,
                onTap: () {
                  navigateTo(
                      context,
                      ServiceDetailsScreen(
                        service: service,
                        color: color,
                      ));
                },
              );
            },
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        //! Title text skeleton placeholder
        SkeletonLoader(
          width: 120.w,
          height: 20.h,
          borderRadius: BorderRadius.circular(6.r),
        ),
        SizedBox(height: 12.h),
        //! Grid skeleton placeholders
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 16.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return SkeletonLoader(
              width: double.infinity,
              height: 120.h,
              borderRadius: BorderRadius.circular(12.r),
            );
          },
        ),
      ],
    );
  }
}
