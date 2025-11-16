import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/component/widgets/app_text_field.dart';
import 'package:qafeel/core/component/widgets/profile_image_picker.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/utils/validator.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/navigation.dart';
import '../../../core/cubit/global_cubit.dart';
import '../../../core/services/service_locator.dart';
import '../../base/view/base_screen.dart';
import '../view/phone_confirm_screen.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            showToast(
              context,
              message: "register_success".tr(context),
              state: ToastStates.success,
            );
            navigateAndFinish(context, BaseScreen());
          } else if (state is AuthCreateAccountSuccess) {
            showToast(
              context,
              message: "register_success".tr(context),
              state: ToastStates.success,
            );
            navigateTo(context, const PhoneConfirmScreen());
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
                                "new_account".tr(context),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SvgPicture.asset(
                                "assets/images/svg/register_add.svg",
                                width: 20.w,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          ProfileImagePicker(
                            profileImage: cubit.profileImage,
                            onImageSelected: cubit.updateProfileImage,
                            size: 110,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "upload_profile_image".tr(context),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                AppTextField(
                                  enabled: state is AuthLoading ? false : true,
                                  controller: cubit.nameController,
                                  hintText: "* ${"name".tr(context)}",
                                  validator: (value) =>
                                      Validators.validateName(value, context),
                                ),
                                SizedBox(height: 20.h),
                                AppTextField(
                                  enabled: state is AuthLoading ? false : true,
                                  controller: cubit.emailController,
                                  hintText: "email".tr(context),
                                  validator: (value) =>
                                      Validators.validateEmail(value, context),
                                ),
                                SizedBox(height: 20.h),
                                AppTextField(
                                  enabled: state is AuthLoading ? false : true,
                                  controller: cubit.phoneController,
                                  hintText: "* ${"phone_hint".tr(context)}",
                                  validator: (value) =>
                                      Validators.validatePhone(value, context),
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  isLoading: state is AuthLoading,
                                  text: "register".tr(context),
                                  onPressed: () {
                                    cubit.register();
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
