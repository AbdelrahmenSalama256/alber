import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/shared/widgets/section_header.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import 'cubit/notifications_cubit.dart';
import 'cubit/notifications_state.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_details_sheet.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..init(),
      child: CustomScaffold(
        hasShape: false,
        appBar: const CustomTopBar(isNotification: true),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading ||
                state is NotificationsInitial) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SectionHeader(
                        leadingType: HeaderLeadingType.svg,
                        svgAsset: "assets/images/svg/notifications_active.svg",
                        title: "",
                        isLoading: true,
                        iconColor: AppColors.textSecondary,
                        padding: EdgeInsets.only(top: 40.h),
                        skeletonWidth: 140.w,
                        skeletonHeight: 22.h,
                        skeletonRadius: BorderRadius.circular(6.r),
                      ),
                      SizedBox(height: 20.h),
                      ...List.generate(
                        6,
                        (i) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: SkeletonLoader(
                            width: double.infinity,
                            height: 86.h,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is! NotificationsLoaded) {
              return const SizedBox.shrink();
            }
            final s = state;
            final items = s.filter == null
                ? s.items
                : s.items.where((e) => e.type == s.filter).toList();
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SectionHeader(
                      leadingType: HeaderLeadingType.svg,
                      iconColor: AppColors.textSecondary,
                      svgAsset: "assets/images/svg/notifications_active.svg",
                      title: "notifications".tr(context),
                      padding: EdgeInsets.only(top: 40.h),
                    ),
                    SizedBox(height: 20.h),
                    ...items.map(
                      (e) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: NotificationCard(
                          title: e.title,
                          body: e.body,
                          time: e.timeLabel,
                          status: e.status,
                          onTap: () {
                            context.read<NotificationsCubit>().markAsRead(e.id);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => NotificationDetailsSheet(
                                title: e.title,
                                body: e.body,
                                time: e.timeLabel,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
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
