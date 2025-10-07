import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../cart/views/dontation_cart_screen.dart';
import '../../profile/views/widgets/custom_field.dart';
import './cubit/checkout_cubit.dart';
import './cubit/checkout_state.dart';
import 'add_new_credit_card.dart';
import 'payed_success_screen.dart';
import 'widgets/credit_card_view.dart';

class PayConfirmationScreen extends StatelessWidget {
  const PayConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasShape: false,
      appBar: const CustomTopBar(),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          if (state is! CheckoutLoaded) return const SizedBox();
          final c = context.read<CheckoutCubit>();
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.73, sigmaY: 5.73),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "you_are_paying".tr(context),
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "${state.totalAmount}",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              SvgPicture.asset(
                                "assets/images/svg/currancy.svg",
                                width: 20.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ...List.generate(state.savedCards.length, (i) {
                  final card = state.savedCards[i];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: GestureDetector(
                      onTap: () => context.read<CheckoutCubit>().selectCard(i),
                      child: CreditCardView(
                        cardType: card.cardType,
                        cardNumber: card.last4,
                        expiryDate: card.expiry,
                        imagePath: card.imagePath,
                        isVisible: state.selectedCardIndex == i,
                      ),
                    ),
                  );
                }),
                SizedBox(height: 10.h),
                DashedRRect(
                  radius: 14.r,
                  strokeWidth: 1.5,
                  dashWidth: 6,
                  dashGap: 4,
                  color: AppColors.primary,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: () {
                      navigateTo(
                        context,
                        BlocProvider.value(
                          value: context.read<CheckoutCubit>(),
                          child: const AddNewCreditCard(),
                        ),
                      );
                    },
                    child: Container(
                      constraints: BoxConstraints(minHeight: 84.h),
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.textGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.add_circled_solid,
                            color: AppColors.textGrey,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "add_new_card".tr(context),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                BlurredInputField(
                  title: "card_pin".tr(context),
                  hintText: "pin_hint".tr(context),
                  controller: c.pinC,
                ),
                SizedBox(height: 30.h),
                AppButton(
                  text: "confirm_payment".tr(context),
                  onPressed: () {
                    navigateTo(
                      context,
                      BlocProvider.value(
                        value: context.read<CheckoutCubit>(),
                        child: const PayedSuccessScreen(),
                      ),
                    );
                  },
                  backgroundColor: AppColors.textSecondary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
