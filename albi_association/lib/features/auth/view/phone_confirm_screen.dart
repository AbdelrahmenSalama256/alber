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
import 'package:qafeel/features/auth/view/otp_validation_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../core/component/widgets/app_button.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class PhoneConfirmScreen extends StatelessWidget {
  const PhoneConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h; // wide screens = kiosk layout

    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            final phone = context.read<AuthCubit>().phoneController.text.trim();
            sl<GlobalCubit>().setLoginPhone(phone);
            navigateReplacWithNav(context, const OtpValidationScreen());
            showToast(
              context,
              message: "phone_confirmed_success".tr(context),
              state: ToastStates.success,
            );
          } else if (state is AuthError) {
            showToast(
              context,
              message: state.message.tr(context),
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

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
                    key: cubit.formKey,
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
                              "login".tr(context),
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              "assets/images/svg/person.svg",
                              width: 6.w,
                            ),
                          ],
                        ),

                        SizedBox(height: 5.h),

                        // --- Input Field ---
                        AppTextField(
                          enabled: state is! AuthLoading,
                          controller: cubit.phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: "enter_phone".tr(context),
                          validator: (value) =>
                              Validators.validatePhone(value, context),
                          // contentPadding: EdgeInsets.symmetric(
                          //   horizontal: 4.w,
                          //   vertical: isKiosk ? 3.h : 2.h,
                          // ),
                        ),

                        SizedBox(height: 3.h),

                        // --- Confirm Button ---
                        SizedBox(
                          width: 40.w,
                          height: 6.h,
                          child: AppButton(
                            isLoading: state is AuthLoading,
                            text: "confirm_phone".tr(context),
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (cubit.formKey.currentState!.validate() &&
                                  cubit.phoneController.text.isNotEmpty) {
                                cubit.login();
                              } else {
                                showToast(
                                  context,
                                  message:
                                      "please_enter_valid_phone".tr(context),
                                  state: ToastStates.warning,
                                );
                              }
                            },
                          ),
                        ),

                        SizedBox(height: isKiosk ? 5.h : 3.h),

                        // --- Divider ---
                        // SizedBox(
                        //   width: isKiosk ? 40.w : 60.w,
                        //   child: Divider(
                        //     color: const Color(0xffCCCCCC),
                        //     thickness: 0.3.h,
                        //   ),
                        // ),
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
