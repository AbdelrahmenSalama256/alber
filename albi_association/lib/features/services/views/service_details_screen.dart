import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/counter_wrapper_main.dart';
import 'package:qafeel/features/home/view/widgets/donation_card.dart';
import 'package:qafeel/features/services/view/cubit/service_details_cubit.dart';
import 'package:qafeel/features/services/view/cubit/service_details_state.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/skeleton_loader.dart';
import '../../home/view/widgets/custom_top_bar.dart';
import '../../home/view/widgets/donation_confirmation.dart';
import '../../payments/views/nearpay_payment_screen.dart';
import '../data/models/service_details.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Color? color;
  final int sectionId;
  final int serviceId;
  final String? heroTag;

  const ServiceDetailsScreen({
    super.key,
    this.color,
    required this.sectionId,
    required this.serviceId,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    return CounterWrapperMain(
      child: BlocProvider(
        create: (_) => ServiceDetailsCubit()
          ..load(sectionId: sectionId, serviceId: serviceId),
        child: CustomScaffold(
          hasShape: false,
          body: BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
            builder: (context, state) {
              if (state is ServiceDetailsLoading ||
                  state is ServiceDetailsInitial) {
                // ✅ Skeleton Loader instead of spinner
                return _buildSkeleton(isKiosk);
              }

              if (state is ServiceDetailsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: !isKiosk ? 14.sp : 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }

              if (state is ServiceDetailsLoaded) {
                final s = state;
                final accent = color ?? AppColors.primary;
                final raised = (s.details.collectedValue ?? 0).toDouble();
                final goal = (s.details.targetValue ?? 0).toDouble();
                double selectedAmount = (s.details.basicValue ?? 0).toDouble();

                if ((s.details.priceValue ?? '').toLowerCase() == 'multi') {
                  selectedAmount = (s.details.multi1 ??
                          s.details.multi2 ??
                          s.details.multi3 ??
                          s.details.basicValue ??
                          0)
                      .toDouble();
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroSection(
                        context,
                        s.details.displayImage,
                        s.details.title,
                        isKiosk,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: !isKiosk ? 6.h : 24.h),
                            _buildDescriptionSection(
                              context,
                              s.details.description ?? "",
                              isKiosk,
                            ),
                            SizedBox(height: !isKiosk ? 8.h : 32.h),
                            _buildDonationCard(
                              context,
                              s.details,
                              accent,
                              raised,
                              goal,
                              selectedAmount,
                              isKiosk,
                            ),
                            SizedBox(height: !isKiosk ? 10.h : 40.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // 🦴 Skeleton Loader (Hero + Description + Card placeholders)
  Widget _buildSkeleton(bool isKiosk) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hero section skeleton
          SkeletonLoader(
            width: double.infinity,
            height: !isKiosk ? 60.h : 250.h,
            borderRadius: 2.h,
          ),
          SizedBox(height: 4.h),

          // Title placeholder
          SkeletonLoader(
            width: 40.w,
            height: 3.h,
            borderRadius: 1.h,
          ),
          SizedBox(height: 3.h),

          // Description block skeleton
          SkeletonLoader(
            width: double.infinity,
            height: !isKiosk ? 20.h : 15.h,
            borderRadius: 2.h,
          ),
          SizedBox(height: 4.h),

          // DonationCard skeleton
          SkeletonLoader(
            width: double.infinity,
            height: !isKiosk ? 35.h : 25.h,
            borderRadius: 2.h,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
      BuildContext context, String? imageUrl, String title, bool isKiosk) {
    return Stack(
      children: [
        /// Background Image (Hero)
        Hero(
          tag: heroTag ?? '',
          child: Container(
            width: double.infinity,
            height: !isKiosk ? 60.h : 250.h,
            color: AppColors.primary.withOpacity(0.1),
            child: _buildHeroImage(imageUrl),
          ),
        ),

        /// Gradient Overlay
        IgnorePointer(
          ignoring: true,
          child: Container(
            width: double.infinity,
            height: !isKiosk ? 60.h : 250.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        /// Transparent Top Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: CustomTopBar(
              onBack: () {
                PrintUtil.debug('🔙 Back pressed from ServiceDetailsScreen');
                Navigator.pop(context);
              },
            ),
          ),
        ),

        /// Title Text
        PositionedDirectional(
          bottom: !isKiosk ? 5.h : 24.h,
          start: !isKiosk ? 10.w : 20.w,
          end: !isKiosk ? 10.w : 20.w,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: !isKiosk ? 20.sp : 24.sp,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(String? imageUrl) {
    final validUrl = _validateImageUrl(imageUrl);
    if (validUrl == null) {
      return Center(
        child: Icon(
          Icons.category_rounded,
          size: 80,
          color: AppColors.primary.withOpacity(0.3),
        ),
      );
    }
    final isSvg = validUrl.toLowerCase().endsWith('.svg');
    return isSvg
        ? SvgPicture.network(
            validUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholderBuilder: (_) => _buildImagePlaceholder(),
          )
        : Image.network(
            validUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return _buildImageLoading();
            },
          );
  }

  Widget _buildDescriptionSection(
      BuildContext context, String description, bool isKiosk) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'about_service'.tr(context),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: !isKiosk ? 18.sp : 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: !isKiosk ? 2.h : 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(!isKiosk ? 2.h : 16),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Text(
            description,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              fontSize: !isKiosk ? 13.sp : 15.sp,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationCard(
    BuildContext context,
    ServiceDetailsModel details,
    Color accent,
    double raised,
    double goal,
    double selectedAmount,
    bool isKiosk,
  ) {
    int quantity = 1;
    double currentAmount = selectedAmount;

    return StatefulBuilder(
      builder: (context, setStateTile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'donate_now'.tr(context),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: !isKiosk ? 18.sp : 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: !isKiosk ? 3.h : 16.h),
            DonationCard(
              onDonate: () {
                showDialog(
                  context: context,
                  builder: (_) => DonationConfirmationDialog(
                    serviceName: details.title,
                    amount: currentAmount.toInt(),
                    quantity: quantity,
                    onConfirm: () {
                      Navigator.pop(context);
                      navigateTo(
                        context,
                        NearpayPaymentScreen(
                          title: details.title,
                          imageUrl: details.displayImage,
                          amount: currentAmount.toString(),
                          serviceId: serviceId,
                          quantity: quantity,
                        ),
                      );
                    },
                  ),
                );
              },
              viewpercent: details.viewpercent ?? 0,
              type: details.priceValue ?? "variable",
              title: details.title,
              imageAsset: details.displayImage ?? "",
              raised: raised,
              goal: goal,
              initialAmount: selectedAmount,
              multiValues: [
                details.multi1?.toDouble(),
                details.multi2?.toDouble(),
                details.multi3?.toDouble(),
              ],
              initialQty: 1,
              onAmountChanged: (newAmount) =>
                  setStateTile(() => currentAmount = newAmount),
              onQtyChanged: (newQty) => setStateTile(() => quantity = newQty),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImagePlaceholder() => Container(
        color: AppColors.primary.withOpacity(0.1),
        child: Center(
          child: Icon(Icons.image_rounded,
              size: 60, color: AppColors.primary.withOpacity(0.3)),
        ),
      );

  Widget _buildImageLoading() => Container(
        color: AppColors.primary.withOpacity(0.1),
        child: Center(
          child: CircularProgressIndicator(
              strokeWidth: 2.w, color: AppColors.primary),
        ),
      );

  String? _validateImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.contains('No translation') || url.contains('null')) return null;
    return url;
  }
}
