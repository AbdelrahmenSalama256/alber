import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/component/widgets/app_text_field.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../profile/views/widgets/custom_field.dart';
import './cubit/checkout_cubit.dart';

class AddNewCreditCard extends StatelessWidget {
  const AddNewCreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.read<CheckoutCubit>();
    return CustomScaffold(
      hasShape: false,
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle,
                    color: AppColors.textSecondary, size: 20.sp),
                SizedBox(width: 10.w),
                Text(
                  "add_new_card".tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            CustomFieldWithSvgLabel(
              label: "card_number".tr(context),
              svgAssetPath: "assets/images/svg/label.svg",
              fieldWidget: AppTextField(
                controller: c.cardNumberC,
                hintText: "card_number_hint".tr(context),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            CustomFieldWithSvgLabel(
              label: "card_name".tr(context),
              svgAssetPath: "assets/images/svg/label.svg",
              fieldWidget: AppTextField(
                controller: c.cardNameC,
                hintText: "card_name_hint".tr(context),
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomFieldWithSvgLabel(
                    label: "expiry_date".tr(context),
                    svgAssetPath: "assets/images/svg/label.svg",
                    fieldWidget: AppTextField(
                      controller: c.expiryC,
                      hintText: "expiry_hint".tr(context),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: CustomFieldWithSvgLabel(
                    label: "cvv".tr(context),
                    svgAssetPath: "assets/images/svg/label.svg",
                    fieldWidget: AppTextField(
                      controller: c.cvvC,
                      hintText: "cvv_hint".tr(context),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            AppButton(
              text: "save".tr(context),
              onPressed: () {
                context.read<CheckoutCubit>().addCardFromControllers();
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
