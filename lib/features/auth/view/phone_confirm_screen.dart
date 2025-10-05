import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/component/widgets/app_text_field.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/utils/validator.dart';
import 'package:qafeel/features/auth/view/otp_validation_screen.dart';
import 'package:qafeel/features/auth/view/register_screen.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../base/view/base_screen.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import 'widgets/social_media_button.dart';

class PhoneConfirmScreen extends StatelessWidget {
  const PhoneConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            navigateReplacWithNav(context, OtpValidationScreen());
            showToast(context,
                message: "phone_confirmed_success".tr(context),
                state: ToastStates.success);
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
              alignment: Alignment.bottomCenter,
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
                            "assets/images/png/alber-inline-logo.png",
                            width: 232.w,
                            height: 64.1.h,
                          ),
                          SizedBox(height: 40.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "login".tr(context),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SvgPicture.asset(
                                "assets/images/svg/person.svg",
                                width: 20.w,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                AppTextField(
                                  enabled: state is AuthLoading ? false : true,
                                  controller: cubit.phoneController,
                                  hintText: "enter_phone".tr(context),
                                  validator: (value) =>
                                      Validators.validatePhone(value, context),
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  isLoading: state is AuthLoading,
                                  text: "confirm_phone".tr(context),
                                  onPressed: () {
                                    cubit.login();
                                  },
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: 232.w,
                                  child: Divider(
                                    color: const Color(0xffCCCCCC),
                                    thickness: 2.h,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  text: "create_account".tr(context),
                                  prefixIcon: Icon(
                                    CupertinoIcons.plus,
                                    size: 20.sp,
                                    color: AppColors.primary,
                                  ),
                                  type: AppButtonType.outlined,
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  text: "guest_login".tr(context),
                                  type: AppButtonType.secondary,
                                  textStyle: TextStyle(
                                    color:
                                        AppColors.textPrimary.withOpacity(0.5),
                                  ),
                                  onPressed: () {
                                    navigateAndFinish(context, BaseScreen());
                                  },
                                ),
                                SizedBox(height: 60.h),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SocialMediaButton(
                                        icon: SvgPicture.asset(
                                          "assets/images/svg/yt.svg",
                                          width: double.infinity,
                                        ),
                                        onPressed: () {},
                                      ),
                                      SocialMediaButton(
                                        icon: SvgPicture.asset(
                                          "assets/images/svg/sc.svg",
                                          width: double.infinity,
                                        ),
                                        onPressed: () {},
                                      ),
                                      SocialMediaButton(
                                        icon: SvgPicture.asset(
                                          "assets/images/svg/ins.svg",
                                          width: double.infinity,
                                        ),
                                        onPressed: () {},
                                      ),
                                      SocialMediaButton(
                                        icon: SvgPicture.asset(
                                          "assets/images/svg/x.svg",
                                          width: double.infinity,
                                        ),
                                        onPressed: () {},
                                      ),
                                      SocialMediaButton(
                                        icon: SvgPicture.asset(
                                          "assets/images/svg/fb.svg",
                                          width: double.infinity,
                                        ),
                                        onPressed: () {},
                                      ),
                                      SocialMediaButton(
                                        icon: SvgPicture.asset(
                                          "assets/images/svg/in.svg",
                                          width: double.infinity,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
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
