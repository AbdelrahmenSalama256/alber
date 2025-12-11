import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/features/home/view/widgets/counter_wrapper_main.dart';
import 'package:qafeel/features/home/view/widgets/donation_card.dart';
import 'package:qafeel/features/services/views/service_details_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/skeleton_loader.dart';
import '../../../core/constants/navigation.dart';
import '../../home/view/widgets/custom_top_bar.dart';
import '../../home/view/widgets/donation_confirmation.dart';
import '../../payments/views/nearpay_payment_screen.dart';
import '../view/cubit/sub_services_cubit.dart';
import '../view/cubit/sub_services_state.dart';

class SubServicesScreen extends StatelessWidget {
  final int sectionId;
  final String? sectionTitle;
  final String? imagePath;
  final Color? color;
  const SubServicesScreen({
    super.key,
    required this.sectionId,
    this.sectionTitle,
    this.imagePath,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 1200;

    return CounterWrapperMain(
      child: BlocProvider(
        create: (_) => SubServicesCubit()
          ..load(sectionId: sectionId, sectionTitle: sectionTitle),
        child: CustomScaffold(
          hasShape: false,
          body: BlocBuilder<SubServicesCubit, SubServicesState>(
            builder: (context, state) {
              if (state is SubServicesLoading || state is SubServicesInitial) {
                // 🔄 Use skeleton loader instead of spinner
                return _buildSkeleton(isKiosk);
              }

              if (state is SubServicesError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isKiosk ? 14.sp : 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final s = state as SubServicesLoaded;

              return Column(
                children: [
                  CustomTopBar(
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((s.sectionTitle ?? '').isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: color ?? Colors.transparent,
                                    width: 0.2.w,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.network(
                                    imagePath ?? '',
                                    width: 15.w,
                                    height: 10.h,
                                    errorBuilder: (context, error, stackTrace) {
                                      return SvgPicture.asset(
                                        "assets/images/svg/nav/services.svg",
                                        width: 5.w,
                                        // color: AppColors.orange,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    s.sectionTitle ?? '',
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 3.h,
                          ),

                          /// List of Donation Cards
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  EdgeInsets.only(bottom: isKiosk ? 4.h : 2.h),
                              itemCount: s.items.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: isKiosk ? 3.h : 2.h),
                              itemBuilder: (context, index) {
                                final item = s.items[index];
                                final accent = AppColors.primary;
                                final raised =
                                    (item.collectedValue ?? 0).toDouble();
                                final goal = (item.targetValue ?? 0).toDouble();

                                double selectedAmount =
                                    (item.basicValue ?? 0).toDouble();

                                if ((item.priceValue ?? '').toLowerCase() ==
                                    'multi') {
                                  selectedAmount = (item.multi1 ??
                                          item.multi2 ??
                                          item.multi3 ??
                                          item.basicValue ??
                                          0)
                                      .toDouble();
                                }

                                int quantity = 1;
                                double currentAmount = selectedAmount;

                                return StatefulBuilder(
                                  builder: (context, setStateTile) {
                                    return DonationCard(
                                      heroTag: 'service_${item.id}',
                                      viewpercent: item.viewpercent,
                                      type: item.priceValue ?? "",
                                      title: item.title,
                                      imageAsset: item.img ?? "",
                                      raised: raised,
                                      goal: goal,
                                      initialAmount: selectedAmount,
                                      multiValues: [
                                        item.multi1?.toDouble(),
                                        item.multi2?.toDouble(),
                                        item.multi3?.toDouble(),
                                      ],
                                      initialQty: 1,
                                      accent: accent,

                                      /// When donate clicked
                                      onDonate: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              DonationConfirmationDialog(
                                            serviceName: item.title,
                                            amount: currentAmount.toInt(),
                                            quantity: quantity,
                                            onConfirm: () {
                                              Navigator.pop(context);
                                              navigateTo(
                                                context,
                                                NearpayPaymentScreen(
                                                  title: item.title,
                                                  imageUrl: item.img,
                                                  amount:
                                                      currentAmount.toString(),
                                                  serviceId: item.id,
                                                  quantity: quantity,
                                                ),
                                              );
                                            },
                                            onConfirmWithTotals:
                                                (unit, qty, total) {
                                              debugPrint(
                                                  "Donation confirmed: $unit x $qty = $total");
                                            },
                                          ),
                                        );
                                      },

                                      /// Reactive state handling
                                      onAmountChanged: (newAmount) {
                                        setStateTile(
                                            () => currentAmount = newAmount);
                                      },
                                      onQtyChanged: (newQty) {
                                        setStateTile(() => quantity = newQty);
                                      },

                                      /// Info navigation
                                      onInfoTap: () {
                                        navigateTo(
                                          context,
                                          ServiceDetailsScreen(
                                            sectionId: s.sectionId,
                                            serviceId: item.id,
                                            color: accent.withOpacity(0.3),
                                            heroTag: 'service_${item.id}',
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🦴 Skeleton loader for loading state (same as ServicesScreen)
  Widget _buildSkeleton(bool isKiosk) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
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
                  borderRadius: 1.h,
                ),
                SizedBox(width: 3.w),
                SkeletonLoader(
                  width: 25.w,
                  height: 3.h,
                  borderRadius: 1.h,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              separatorBuilder: (_, __) => SizedBox(height: 3.h),
              itemBuilder: (context, index) {
                return SkeletonLoader(
                  width: double.infinity,
                  height: !isKiosk ? 30.h : 20.h,
                  borderRadius: 2.h,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
