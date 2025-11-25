import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/app/alber.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/auth_return.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/cart/views/add_donation_cart_screen.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/home/view/widgets/service_card.dart';
import 'package:qafeel/features/news/views/news_screen.dart';
import 'package:qafeel/features/services/views/service_details_screen.dart';
import 'package:qafeel/features/services/views/services_screen.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/view/phone_confirm_screen.dart';
import '../../news/views/news_details_screen.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/donation_card.dart';
import 'widgets/donation_service_card.dart';
import 'widgets/news_section.dart';
import 'widgets/partners_section.dart';
import 'widgets/skeleton_loader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomScaffold(
            hasShape: false,
            appBar: const CustomTopBar(isHome: true),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      return _buildSkeletonLoading();
    }

    if (state is HomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle,
              size: 60.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              "something_went_wrong".tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "please_try_again_later".tr(context),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            AppButton(
              onPressed: () {
                context.read<HomeCubit>().loadHomeData();
              },
              text: "retry".tr(context),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoaded) {
      return _buildHomeContent(context, state);
    }

    return const SizedBox();
  }

  Widget _buildSkeletonLoading() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            SkeletonLoader(
              width: double.infinity,
              height: 200.h,
              borderRadius: BorderRadius.circular(20.r),
            ),
            SizedBox(height: 30.h),
            SkeletonLoader(
              width: 100.w,
              height: 20.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
            SizedBox(height: 8.h),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
            SizedBox(height: 20.h),
            Center(
              child: SkeletonLoader(
                width: 190.w,
                height: 50.h,
                borderRadius: BorderRadius.circular(9.78.r),
              ),
            ),
            SizedBox(height: 30.h),
            SkeletonLoader(
              width: 150.w,
              height: 20.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 220.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  return SkeletonLoader(
                    width: MediaQuery.of(context).size.width * 0.86,
                    height: 220.h,
                    borderRadius: BorderRadius.circular(12.r),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, HomeLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      context.read<HomeCubit>().updateSliderIndex(index);
                    },
                  ),
                  items: state.sliderImages.map((image) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(image, fit: BoxFit.contain),
                    );
                  }).toList(),
                ),
                Positioned(
                  top: -10.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              state.sliderImages.asMap().entries.map((entry) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 12.36.w,
                              height: 12.36.w,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state.currentSliderIndex == entry.key
                                    ? AppColors.textSecondary
                                    : const Color(0xffBCB7B2),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Text(
              "services".tr(context),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
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
                final language = context.read<GlobalCubit>().language;
                final imagePath = service.image;
                final color = state.extractedColors[imagePath] ?? Colors.grey;
                return ServiceCard(
                  imagePath: imagePath,
                  title: service.titleForLanguage(language),
                  borderColor: color,
                  onTap: () {
                    navigateTo(
                      context,
                      ServiceDetailsScreen(
                        service: service,
                        color: color,
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20.h),
            Center(
              child: SizedBox(
                width: 190.w,
                child: AppButton(
                  text: "all_services".tr(context),
                  borderRadius: BorderRadius.circular(9.78.r),
                  onPressed: () {
                    navigateTo(context, ServicesScreen());
                  },
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              "the_most_needy_cases".tr(context),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 330.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: state.donations.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final d = state.donations[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: DonationCard(
                      title: d.title,
                      imageAsset: d.displayImage ??
                          'assets/images/png/text-donation.png',
                      raised: (d.collectedValue ?? 0).toDouble(),
                      goal: (d.targetValue ?? 0).toDouble(),
                      initialAmount: (d.displayAmount ?? 0).toDouble(),
                      initialQty: 1,
                      type: d.priceValue,
                      viewpercent: d.viewpercent,
                      multiValues: [
                        d.multi1?.toDouble(),
                        d.multi2?.toDouble(),
                        d.multi3?.toDouble(),
                      ],
                      frequencyOptions: const ["once", "monthly"],
                      initialFrequencyIndex: 0,
                      onDonateWithSelection: (amount, qty, freq) {
                        final token = sl<CacheHelper>()
                            .getDataString(key: AppConstants.token);
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
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              "charity_donation_services".tr(context),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              height: 300.h,
              child: PageView.builder(
                clipBehavior: Clip.none,
                controller: PageController(viewportFraction: 0.86),
                padEnds: false,
                itemCount: state.donationServices.length,
                itemBuilder: (context, i) {
                  final d = state.donationServices[i];
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: DonationServiceCard(
                      title: d.title,
                      imageAsset:
                          d.displayImage ?? 'assets/images/png/cure-main.png',
                      badgeSvg: 'assets/images/png/cure.png',
                      amount: (d.displayAmount ?? 0).toDouble(),
                      initialQty: 1,
                      onDonate: () {
                        final token = sl<CacheHelper>()
                            .getDataString(key: AppConstants.token);
                        if (token == null || token.isEmpty) {
                          showToast(context,
                              message: 'login'.tr(context),
                              state: ToastStates.warning);
                          sl<AuthReturnService>().setPendingAction(() {
                            navigateTo(
                              navigatorKey.currentContext!,
                              AddDonationCartScreen(),
                            );
                          });
                          navigateTo(context, const PhoneConfirmScreen());
                          return;
                        }
                        navigateTo(
                          context,
                          AddDonationCartScreen(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),
            NewsSection(
              headingSmall: "latest_news".tr(context),
              headingBig: "new_albir_society".tr(context),
              items: state.news
                  .map(
                    (news) => NewsItem(
                      imageAsset: news.imageAsset,
                      title: news.title,
                      subtitle: news.subtitle,
                      onTap: () {
                        navigateTo(context, NewsDetailsScreen());
                      },
                    ),
                  )
                  .toList(),
              onAllNews: () {
                navigateTo(context, NewsScreen());
              },
            ),
            SizedBox(height: 30.h),
            PartnersSection(
              smallHeading: "finger_prints".tr(context),
              bigHeading: "a_growing_partnership_community".tr(context),
              logos: state.partners,
              onAllPartners: () {},
            ),
          ],
        ),
      ),
    );
  }
}
