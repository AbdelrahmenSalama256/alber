import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/view/widgets/skeleton_loader.dart';
import './cubit/profile_cubit.dart';
import './cubit/profile_state.dart';
import 'widgets/custom_field.dart';

class ContactComplaintsScreen extends StatelessWidget {
  const ContactComplaintsScreen({super.key});

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
                          width: 220.w,
                          height: 22.h,
                          borderRadius: BorderRadius.circular(8)),
                      SizedBox(height: 20.h),
                      SkeletonLoader(
                          width: double.infinity,
                          height: 120.h,
                          borderRadius: BorderRadius.circular(16)),
                      SizedBox(height: 30.h),
                      ...List.generate(
                          6,
                          (i) => Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: SkeletonLoader(
                                    width: double.infinity,
                                    height: 60.h,
                                    borderRadius: BorderRadius.circular(12)),
                              )),
                      SizedBox(height: 16.h),
                      SkeletonLoader(
                          width: double.infinity,
                          height: 52.h,
                          borderRadius: BorderRadius.circular(12)),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              );
            }
            final cubit = context.read<ProfileCubit>();
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
                            "assets/images/svg/circle-question.svg",
                            width: 20.w),
                        SizedBox(width: 15.w),
                        Text(
                          "complaints_call_us".tr(context),
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: Offset(0, 6.h)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('لا تتردد في الإتصال  بنا.',
                                  style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.6)),
                              SizedBox(height: 8.h),
                              Text(
                                  'فأنت محط اهتمامنا خذ مساحة لآرءائك أو شكواك و اكتب مايجول في خاطرك وشاركنا اهتماماتك و مقترحاتك في أي مجال',
                                  style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/svg/map-marker.svg",
                                      width: 16.w,
                                      color: AppColors.orange),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                        'جمعية البر بجدة الادارة العامة، الزهراء، 3413 6780 البترجي،، جدة 23521',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    Icon(CupertinoIcons.envelope_open,
                                        size: 16.w, color: AppColors.orange),
                                    SizedBox(width: 6.w),
                                    Text('info@albir.sa',
                                        style: TextStyle(
                                            color: AppColors.textGrey,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600)),
                                  ]),
                                  SizedBox(width: 16.w),
                                  Row(children: [
                                    Icon(CupertinoIcons.phone,
                                        size: 16.w, color: AppColors.orange),
                                    SizedBox(width: 6.w),
                                    Text('920005757',
                                        style: TextStyle(
                                            color: AppColors.textGrey,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600)),
                                  ]),
                                  SizedBox(width: 16.w),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    CustomFieldWithSvgLabel(
                      label: 'name'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                          controller: cubit.nameC,
                          hintText: 'name'.tr(context)),
                    ),
                    SizedBox(height: 12.h),
                    CustomFieldWithSvgLabel(
                      label: 'email'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                          controller: cubit.emailC,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'email'.tr(context)),
                    ),
                    SizedBox(height: 12.h),
                    CustomFieldWithSvgLabel(
                      label: 'phone_number'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                          controller: cubit.phoneC,
                          keyboardType: TextInputType.phone,
                          hintText: 'phone_number'.tr(context)),
                    ),
                    SizedBox(height: 12.h),
                    CustomFieldWithSvgLabel(
                      label: 'subject'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                          controller: cubit.subjectC,
                          hintText: 'subject'.tr(context)),
                    ),
                    SizedBox(height: 12.h),
                    CustomFieldWithSvgLabel(
                      label: 'topic'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: DropdownButtonFormField<String>(
                        value: cubit.topic,
                        items: <String>['شكوى', 'اقتراح', 'استفسار']
                            .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e,
                                    style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700))))
                            .toList(),
                        onChanged: context.read<ProfileCubit>().setTopic,
                        dropdownColor: AppColors.white,
                        isExpanded: true,
                        hint: Text('topic'.tr(context),
                            style: TextStyle(
                                color: const Color(0xFFB6B6B6),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600)),
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textGrey),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CustomFieldWithSvgLabel(
                      label: 'message'.tr(context),
                      svgAssetPath: "assets/images/svg/label.svg",
                      fieldWidget: AppTextField(
                          controller: cubit.messageC,
                          hintText: 'message'.tr(context),
                          maxLines: 5),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 52.h,
                      child: AppButton(
                        text: 'send'.tr(context),
                        onPressed: () {},
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 24.h),
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
