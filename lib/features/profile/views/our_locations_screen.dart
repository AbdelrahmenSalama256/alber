import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/profile_cubit.dart';
import './cubit/profile_state.dart';
import 'widgets/locations_card.dart';

class OurLocationsScreen extends StatelessWidget {
  const OurLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileCubit>(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      SkeletonLoader(
                          width: 200.w,
                          height: 24.h,
                          borderRadius: BorderRadius.circular(8.r)),
                      SizedBox(height: 30.h),
                      ...List.generate(
                          3,
                          (i) => Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: SkeletonLoader(
                                    width: double.infinity,
                                    height: 180.h,
                                    borderRadius: BorderRadius.circular(12.r)),
                              )),
                    ],
                  ),
                ),
              );
            }
            if (state is! ProfileLoaded) {
              return const SizedBox.shrink();
            }
            final s = state;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/svg/map-marker.svg",
                            width: 25.w, height: 25.w),
                        SizedBox(width: 15.w),
                        Text(
                          "our_locations".tr(context),
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    ...s.locations.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: LocationsCard(
                            title: e["title"]!,
                            description: e["desc"]!,
                            imagePath: e["image"]!,
                            iconPath: e["icon"]!,
                            titleColor: AppColors.primary,
                            backgroundColor: AppColors.white,
                            onTap: () {},
                          ),
                        )),
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
