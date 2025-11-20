import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/component/widgets/profile_image_picker.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/profile/views/cubit/profile_cubit.dart';
import 'package:qafeel/features/profile/views/cubit/profile_state.dart';
import 'package:qafeel/features/profile/views/widgets/profile_field_item.dart';

import '../../../core/constants/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final bool isLoading =
            state is ProfileLoading || state is ProfileInitial;
        final ProfileLoaded? loaded = state is ProfileLoaded ? state : null;
        return CustomScaffold(
          appBar: CustomTopBar(),
          hasShape: false,
          body: isLoading || loaded == null
              ? const Center(child: CircularProgressIndicator())
              : _EditProfileBody(state: loaded),
        );
      },
    );
  }
}

class _EditProfileBody extends StatelessWidget {
  final ProfileLoaded state;

  const _EditProfileBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final user = state.profile;
    final memberId = user.membershipId ?? 'ID-${user.userGuid ?? '0000'}';
    final isEditing = state.isEditingProfile;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/svg/nav/profile2.svg",
                  width: 20.w,
                ),
                SizedBox(width: 20.h),
                Text(
                  "my_profile".tr(context),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            ProfileImagePicker(
              profileImage: state.pendingAvatar,
              initialImage: user.imageUrl,
              onImageSelected: (file) {
                context.read<ProfileCubit>().updateProfileImage(file);
              },
              size: 100,
            ),
            if (state.isUpdatingProfile) ...[
              SizedBox(height: 12.h),
              const LinearProgressIndicator(minHeight: 2),
            ],
            SizedBox(height: 12.h),
            Text(
              user.displayname ?? '',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              user.email ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textGrey,
              ),
            ),
            SizedBox(height: 32.h),
            _buildEditableField(
              context,
              label: "name".tr(context),
              value: user.name,
              svg: "assets/images/svg/person.svg",
              isEditing: isEditing,
              inputType: TextInputType.name,
              onSubmit: (value) =>
                  context.read<ProfileCubit>().updateDisplayName(value),
            ),
            _buildEditableField(
              context,
              label: "membership_id".tr(context),
              value: memberId,
              svg: "assets/images/svg/security.svg",
              isEditing: false,
              inputType: TextInputType.text,
              onSubmit: (value) => context
                  .read<ProfileCubit>()
                  .updateProfileField(memberId: value),
            ),
            _buildContactField(
              context,
              label: "phone".tr(context),
              value: state.pendingPhone ?? user.mobile ?? '',
              svg: "assets/images/svg/mob.svg",
              isVerified: state.isPhoneVerified,
              isEditing: isEditing,
              onEdit: (value) =>
                  context.read<ProfileCubit>().updateProfileField(phone: value),
            ),
            _buildContactField(
              context,
              label: "email".tr(context),
              value: state.pendingEmail ?? user.email ?? '',
              svg: "assets/images/svg/emal.svg",
              isVerified: state.isEmailVerified,
              isEditing: isEditing,
              onEdit: (value) =>
                  context.read<ProfileCubit>().updateProfileField(email: value),
            ),
            SizedBox(height: 30.h),
            AppButton(
              text: isEditing ? "save".tr(context) : "edit_profile".tr(context),
              onPressed: () {
                final cubit = context.read<ProfileCubit>();
                if (isEditing) {
                  cubit.toggleProfileEditing(enabled: false);
                  showToast(context,
                      message: "profile_updated".tr(context),
                      state: ToastStates.success);
                } else {
                  cubit.toggleProfileEditing(enabled: true);
                }
              },
              backgroundColor:
                  isEditing ? AppColors.primary : Colors.transparent,
              prefixIcon: Icon(
                isEditing ? Icons.check_circle_outline : CupertinoIcons.gear,
                size: 26.sp,
                color: isEditing ? Colors.white : AppColors.textSecondary,
              ),
              type: isEditing ? AppButtonType.primary : AppButtonType.outlined,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context, {
    required String label,
    required String value,
    required String svg,
    required bool isEditing,
    required TextInputType inputType,
    required ValueChanged<String> onSubmit,
  }) {
    return ProfileFieldItem(
      title: value,
      svgAsset: svg,
      onTap: isEditing
          ? () {
              _showEditFieldSheet(
                context,
                fieldLabel: label,
                initialValue: value,
                keyboardType: inputType,
                onSubmit: onSubmit,
              );
            }
          : null,
    );
  }

  Widget _buildContactField(
    BuildContext context, {
    required String label,
    required String value,
    required String svg,
    required bool isVerified,
    required bool isEditing,
    required ValueChanged<String> onEdit,
  }) {
    final trimmedValue = value.trim();
    final displayValue = trimmedValue.isEmpty ? '----' : trimmedValue;
    final title = isVerified
        ? displayValue
        : '$displayValue (${"tap_to_verify".tr(context)})';

    VoidCallback? onTap;
    if (!isVerified && trimmedValue.isNotEmpty) {
      onTap = () => _navigateToVerification(context, trimmedValue);
    } else if (isEditing) {
      onTap = () => _showEditFieldSheet(
            context,
            fieldLabel: label,
            initialValue: trimmedValue,
            keyboardType: label.contains('email')
                ? TextInputType.emailAddress
                : TextInputType.phone,
            onSubmit: onEdit,
          );
    }

    return ProfileFieldItem(
      title: title,
      svgAsset: svg,
      onTap: onTap,
    );
  }

  void _navigateToVerification(BuildContext context, String identifier) {
    final trimmed = identifier.trim();
    if (trimmed.isEmpty) return;
    navigateTo(
      context,
      PhoneConfirmScreen(
        requestOtpOnInit: true,
        initialIdentifier: trimmed,
      ),
    );
  }

  Future<void> _showEditFieldSheet(
    BuildContext context, {
    required String fieldLabel,
    required String initialValue,
    required TextInputType keyboardType,
    required ValueChanged<String> onSubmit,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final radiusXl = sl<GlobalCubit>().radiusXl;
    final radiusMd = sl<GlobalCubit>().radiusMd;
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              0,
              16.w,
              bottomInset + 16.h,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radiusXl.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(radiusXl.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: AppColors.textGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        fieldLabel,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        decoration: InputDecoration(
                          hintText: fieldLabel,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radiusMd.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              type: AppButtonType.outlined,
                              text: "cancel".tr(context),
                              onPressed: () => Navigator.of(sheetContext).pop(),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: AppButton(
                              text: "save".tr(context),
                              onPressed: () => Navigator.of(sheetContext)
                                  .pop(controller.text),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      final trimmed = result.trim();
      if (trimmed.isNotEmpty) {
        onSubmit(trimmed);
      }
    }
  }
}
