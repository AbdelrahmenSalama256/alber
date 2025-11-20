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
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          final cubit = context.read<AuthCubit>();
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
            navigateTo(
              context,
              PhoneConfirmScreen(
                requestOtpOnInit: true,
                initialIdentifier: cubit.phoneController.text.trim(),
              ),
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
          final isLoading = state is AuthLoading;
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
                                  enabled: !isLoading,
                                  controller: cubit.usernameController,
                                  hintText: "* ${"username".tr(context)}",
                                  validator: (value) =>
                                      Validators.validateRequired(value,
                                          "username".tr(context), context),
                                ),
                                SizedBox(height: 20.h),
                                AppTextField(
                                  enabled: !isLoading,
                                  controller: cubit.nameController,
                                  hintText: "* ${"display_name".tr(context)}",
                                  validator: (value) =>
                                      Validators.validateName(value, context),
                                ),
                                SizedBox(height: 20.h),
                                AppTextField(
                                  enabled: !isLoading,
                                  controller: cubit.emailController,
                                  hintText: "email".tr(context),
                                  validator: (value) =>
                                      Validators.validateEmail(value, context),
                                ),
                                SizedBox(height: 20.h),
                                AppTextField(
                                  enabled: !isLoading,
                                  controller: cubit.phoneController,
                                  hintText: "* ${"phone_hint".tr(context)}",
                                  validator: (value) =>
                                      Validators.validatePhone(value, context),
                                ),
                                SizedBox(height: 20.h),
                                DropdownButtonFormField<String>(
                                  value: cubit.selectedGender,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                        color: const Color(0xFF707070),
                                        width: 0.47.w,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                        color: const Color(0xFF707070),
                                        width: 0.47.w,
                                      ),
                                    ),
                                  ),
                                  hint: Text("select_gender".tr(context)),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'male',
                                      child: Text("male".tr(context)),
                                    ),
                                    DropdownMenuItem(
                                      value: 'female',
                                      child: Text("female".tr(context)),
                                    ),
                                  ],
                                  validator: (value) =>
                                      Validators.validateRequired(
                                          value, "gender".tr(context), context),
                                  onChanged: isLoading
                                      ? null
                                      : (value) => cubit.setGender(value),
                                ),
                                SizedBox(height: 20.h),
                                AppTextField(
                                  enabled: !isLoading,
                                  controller:
                                      cubit.createAccountPasswordController,
                                  hintText: "* ${"password".tr(context)}",
                                  validator: (value) =>
                                      Validators.validatePassword(
                                          value, context),
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                                SizedBox(height: 20.h),
                                AppTextField(
                                  enabled: !isLoading,
                                  controller:
                                      cubit.confirmNewPasswordController,
                                  hintText:
                                      "* ${"confirm_password".tr(context)}",
                                  validator: (value) =>
                                      Validators.validateConfirmPassword(
                                          value,
                                          cubit.createAccountPasswordController
                                              .text,
                                          context),
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  isLoading: isLoading,
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
