import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

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
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              "assets/images/svg/notifications_active.svg",
                              width: 22.w),
                          SizedBox(width: 10.w),
                          SkeletonLoader(
                              width: 140.w,
                              height: 22.h,
                              borderRadius: BorderRadius.circular(6.r)),
                        ],
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
            final s = state as NotificationsLoaded;
            final items = s.filter == null
                ? s.items
                : s.items.where((e) => e.type == s.filter).toList();
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            "assets/images/svg/notifications_active.svg",
                            width: 22.w,
                            color: AppColors.textSecondary),
                        SizedBox(width: 10.w),
                        Text(
                          "notifications".tr(context),
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
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
