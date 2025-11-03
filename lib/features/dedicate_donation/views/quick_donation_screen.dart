import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/home/view/widgets/donation_card.dart';

import '../../../core/cubit/global_cubit.dart';
import '../../cart/views/add_donation_cart_screen.dart';

class QuickDonationScreen extends StatefulWidget {
  final int initialTabIndex;
  const QuickDonationScreen({super.key, this.initialTabIndex = 0});

  @override
  State<QuickDonationScreen> createState() => _QuickDonationScreenState();
}

class _QuickDonationScreenState extends State<QuickDonationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data for donation cards
  final List<Map<String, dynamic>> _donationItems = [
    {
      'title': 'دعم ذوي الاحتياجات الخاصة',
      'imageAsset': 'assets/images/png/cure-main.png',
      'raised': 5000.0,
      'goal': 10000.0,
      'amount': 100.0,
      'qty': 1,
    },
    {
      'title': 'دعم ذوي الاحتياجات الخاصة',
      'imageAsset': 'assets/images/png/cure-main.png',
      'raised': 7500.0,
      'goal': 15000.0,
      'amount': 150.0,
      'qty': 1,
    },
    {
      'title': 'دعم ذوي الاحتياجات الخاصة',
      'imageAsset': 'assets/images/donation3.jpg',
      'raised': 3000.0,
      'goal': 8000.0,
      'amount': 80.0,
      'qty': 1,
    },
    {
      'title': 'دعم ذوي الاحتياجات الخاصة',
      'imageAsset': 'assets/images/png/cure-main.png',
      'raised': 12000.0,
      'goal': 20000.0,
      'amount': 200.0,
      'qty': 1,
    },
  ];

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
    // Navigate back to home and change bottom nav index
    Navigator.of(context).popUntil((route) => route.isFirst);
    // You'll need to access your GlobalCubit to change the bottom nav index
    // This depends on your app's architecture
    context.read<GlobalCubit>().changeBottomNavIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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

          // Tab Bar
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
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(
                  child: Text(
                    'quick_donate'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: context.read<GlobalCubit>().language == 'ar'
                          ? "arabic"
                          : "english",
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'dedicate_donation'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: context.read<GlobalCubit>().language == 'ar'
                          ? "arabic"
                          : "english",
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'volunteer_projects'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: context.read<GlobalCubit>().language == 'ar'
                          ? "arabic"
                          : "english",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Tab Bar View Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // تبرع سريع - Quick Donation
                _buildQuickDonationTab(),
                // اهداء تبرع - Dedicate Donation
                _buildDedicateDonationTab(),
                // مشاريع تطوع - Volunteer Projects (Coming Soon)
                _buildVolunteerProjectsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDonationTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 20.h),
              itemCount: _donationItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final item = _donationItems[index];
                return DonationCard(
                  title: item['title'],
                  imageAsset: item['imageAsset'],
                  raised: item['raised'],
                  goal: item['goal'],
                  initialAmount: item['amount'],
                  initialQty: item['qty'],
                  onDonate: () {
                    // Handle donation
                    navigateTo(context, AddDonationCartScreen());
                  },
                  onAmountChanged: (amount) {
                    // Handle amount change
                  },
                  onQtyChanged: (qty) {
                    // Handle quantity change
                  },
                  frequencyOptions: ["once", "monthly"],
                  initialFrequencyIndex: 0,
                  accent: AppColors.primary,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDedicateDonationTab() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_giftcard,
            size: 80.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 20.h),
          Text(
            'dedicate_donation_desc'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _handleDedicateDonation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Text(
                'go_to_dedicate'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
          Icon(
            Icons.construction,
            size: 80.sp,
            color: AppColors.grey,
          ),
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
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
