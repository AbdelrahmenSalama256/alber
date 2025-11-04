import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/auth_return.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/cart/views/add_donation_cart_screen.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/home/view/widgets/donation_card.dart';
import 'package:qafeel/features/home/view/widgets/skeleton_loader.dart';

import '../../../core/app/alber.dart';
import '../../../core/component/widgets/app_button.dart';
import 'cubit/quick_donation_cubit.dart';
import 'cubit/quick_donation_state.dart';

class QuickDonationScreen extends StatefulWidget {
  final int initialTabIndex;
  const QuickDonationScreen({super.key, this.initialTabIndex = 0});

  @override
  State<QuickDonationScreen> createState() => _QuickDonationScreenState();
}

class _QuickDonationScreenState extends State<QuickDonationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final idx = widget.initialTabIndex.clamp(0, 2);
    _tabController = TabController(length: 3, vsync: this, initialIndex: idx);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleDedicateDonation() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.read<GlobalCubit>().changeBottomNavIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuickDonationCubit()..init(),
      child: CustomScaffold(
        appBar: CustomTopBar(),
        body: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              'quick_donation'.tr(context),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),

            // 🔹 Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.primary,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textGrey,
                tabs: [
                  Tab(text: 'quick_donate'.tr(context)),
                  Tab(text: 'dedicate_donation'.tr(context)),
                  Tab(text: 'volunteer_projects'.tr(context)),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // 🔹 Tab Bar Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _QuickDonationTab(),
                  _buildDedicateDonationTab(),
                  _buildVolunteerProjectsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDedicateDonationTab() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_giftcard, size: 80.sp, color: AppColors.primary),
          SizedBox(height: 20.h),
          Text(
            'dedicate_donation_desc'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
          ),
          SizedBox(height: 30.h),
          AppButton(
            onPressed: _handleDedicateDonation,
            text: 'go_to_dedicate'.tr(context),
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerProjectsTab() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 80.sp, color: AppColors.grey),
          SizedBox(height: 20.h),
          Text(
            'coming_soon'.tr(context),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'volunteer_projects_desc'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

class _QuickDonationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuickDonationCubit, QuickDonationState>(
      builder: (context, state) {
        if (state is QuickDonationLoading) {
          return _loadingSkeleton();
        }
        if (state is! QuickDonationLoaded) return const SizedBox();
        final donationItems = state.donationItems;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: 20.h),
            itemCount: donationItems.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final item = donationItems[index];
              return DonationCard(
                title: item['title'],
                imageAsset: item['imageAsset'],
                raised: item['raised'],
                goal: item['goal'],
                initialAmount: item['amount'],
                initialQty: item['qty'],
                accent: AppColors.primary,
                onDonateWithSelection: (amount, qty, _) {
                  final token =
                      sl<CacheHelper>().getDataString(key: AppConstants.token);
                  if (token == null || token.isEmpty) {
                    showToast(context,
                        message: 'login'.tr(context),
                        state: ToastStates.warning);
                    sl<AuthReturnService>().setPendingAction(() {
                      navigateTo(
                        navigatorKey.currentContext!,
                        AddDonationCartScreen(
                          initialAmount: amount.round(),
                          initialQty: qty,
                        ),
                      );
                    });
                    navigateTo(context, const PhoneConfirmScreen());
                    return;
                  }
                  navigateTo(
                    context,
                    AddDonationCartScreen(
                      initialAmount: amount.round(),
                      initialQty: qty,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _loadingSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ListView.builder(
        itemCount: 4,
        padding: EdgeInsets.only(bottom: 20.h),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: SkeletonLoader(
              width: double.infinity,
              height: 140.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
          );
        },
      ),
    );
  }
}
