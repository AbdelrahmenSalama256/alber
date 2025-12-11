import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/component/widgets/app_text_field.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/core/utils/validator.dart';
import 'package:qafeel/features/branches/view/cubit/branches_cubit.dart';
import 'package:qafeel/features/branches/view/cubit/branches_state.dart';
import 'package:qafeel/features/home/view/home_screen.dart';
import 'package:qafeel/features/settings/view/cubit/settings_cubit.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/component/widgets/app_dropdown.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import 'phone_confirm_screen.dart';

class OtpValidationScreen extends StatelessWidget {
  const OtpValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h; // same breakpoint as PhoneConfirmScreen

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => BranchesCubit()..fetchBranches()),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            final hasToken = sl<GlobalCubit>().isAuthenticated;
            showToast(
              context,
              message: "otp_verified_success".tr(context),
              state: ToastStates.success,
            );
            if (hasToken) {
              navigateAndFinish(context, const HomeScreen());
            } else {
              navigateAndFinish(context, const PhoneConfirmScreen());
            }
          } else if (state is AuthError) {
            showToast(
              context,
              message: state.message.tr(context),
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final auth = context.read<AuthCubit>();

          return CustomScaffold(
            hasShape: true,
            body: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isKiosk ? 20.w : 8.w,
                    vertical: isKiosk ? 10.h : 4.h,
                  ),
                  child: Form(
                    key: auth.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- Logo ---
                        Image.asset(
                          "assets/images/png/alber-inline-logo.png",
                          width: isKiosk ? 35.w : 60.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: isKiosk ? 8.h : 5.h),

                        // --- Title Row ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "otp_verification_title".tr(context),
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              "assets/images/svg/security.svg",
                              width: 6.w,
                            ),
                          ],
                        ),

                        SizedBox(height: 5.h),

                        // --- Branch Dropdown ---
                        BlocBuilder<BranchesCubit, BranchesState>(
                          builder: (context, bState) {
                            if (bState is BranchesLoading ||
                                bState is BranchesInitial) {
                              return const LinearProgressIndicator();
                            }
                            if (bState is BranchesError) {
                              return Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Text(
                                  bState.message,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              );
                            }

                            final items = (bState as BranchesLoaded).items;

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.w),
                              child: AppDropdownField<int>(
                                labelText: "select_branch".tr(context),
                                value: auth.selectedBranchId,
                                items: items
                                    .map(
                                      (e) => DropdownMenuItem<int>(
                                        value: e.id,
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontFamily: context
                                                        .read<GlobalCubit>()
                                                        .language ==
                                                    "ar"
                                                ? 'arabic'
                                                : "english",
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  auth.setSelectedBranchId(v);
                                  if (v != null) {
                                    final name =
                                        items.firstWhere((e) => e.id == v).name;
                                    sl<GlobalCubit>()
                                        .setSelectedBranch(id: v, name: name);
                                    context
                                        .read<SettingsCubit>()
                                        .init(branchId: v);
                                  }
                                },
                                validator: (v) => v == null
                                    ? "select_branch".tr(context)
                                    : null,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 3.h),

                        // --- OTP Field ---
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: AppTextField(
                            enabled: state is! AuthLoading,
                            controller: auth.otpController,
                            keyboardType: TextInputType.number,
                            hintText: "enter_otp".tr(context),
                            validator: (value) =>
                                Validators.validateOtp(value, context),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // --- Continue Button ---
                        SizedBox(
                          width: 40.w,
                          height: 6.h,
                          child: AppButton(
                            isLoading: state is AuthLoading,
                            text: "continue".tr(context),
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (auth.formKey.currentState!.validate() &&
                                  auth.otpController.text.isNotEmpty) {
                                auth.otpVerfication();
                              } else {
                                showToast(
                                  context,
                                  message: "please_enter_valid_otp".tr(context),
                                  state: ToastStates.warning,
                                );
                              }
                            },
                          ),
                        ),

                        SizedBox(height: isKiosk ? 5.h : 3.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
