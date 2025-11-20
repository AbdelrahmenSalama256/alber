import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/component/widgets/app_text_field.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/services/auth_return.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/core/utils/validator.dart';
import 'package:qafeel/features/base/view/base_screen.dart';

import '../../../core/component/widgets/app_button.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class OtpValidationScreen extends StatelessWidget {
  final String? identifier;
  const OtpValidationScreen({super.key, this.identifier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AuthCubit>();
        cubit.loginEmailController.text = identifier?.trim() ?? '';
        return cubit;
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            showToast(context,
                message: "otp_verified_success".tr(context),
                state: ToastStates.success);
            final ret = sl<AuthReturnService>();
            if (ret.hasPending) {
              navigateAndFinish(context, BaseScreen());
              Future.microtask(() => ret.runPending());
            } else {
              if (context.read<GlobalCubit>().currentNavIndex != 2) {
                context.read<GlobalCubit>().changeBottomNavIndex(2);
                navigateAndFinish(context, BaseScreen());
              } else {
                navigateAndFinish(context, BaseScreen());
              }
              navigateAndFinish(context, BaseScreen());
            }
          } else if (state is AuthError) {
            showToast(context,
                message: state.message.tr(context), state: ToastStates.error);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          return CustomScaffold(
            hasShape: true,
            body: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            sl<GlobalCubit>().AppLogoInline,
                            width: 232.w,
                            height: 64.1.h,
                          ),
                          SizedBox(height: 40.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "otp_verification_title".tr(context),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SvgPicture.asset(
                                "assets/images/svg/security.svg",
                                width: 20.w,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: AppTextField(
                                    keyboardType: TextInputType.number,
                                    enabled:
                                        state is! AuthOtpVerificationLoading,
                                    controller: cubit.otpController,
                                    hintText: "enter_otp".tr(context),
                                    validator: (value) =>
                                        Validators.validateOtp(value, context),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  isLoading:
                                      state is AuthOtpVerificationLoading,
                                  text: "continue".tr(context),
                                  onPressed: () {
                                    cubit.otpVerfication();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
