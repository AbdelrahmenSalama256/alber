import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/data/repo/auth_repo.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/settings/view/cubit/settings_cubit.dart';
import 'package:qafeel/features/settings/view/cubit/settings_state.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/component/widgets/app_button.dart';

class LogoutPopup extends StatefulWidget {
  const LogoutPopup({super.key});

  @override
  State<LogoutPopup> createState() => _LogoutPopupState();
}

class _LogoutPopupState extends State<LogoutPopup> {
  String _versionLabel = '';
  String _branchLabel = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      final build = info.buildNumber;
      final cachedName = sl<CacheHelper>()
              .getDataString(key: AppConstants.selectedBranchName) ??
          '';
      final cachedId =
          sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId) ??
              '';

      setState(() {
        _versionLabel = 'Version $version+$build';
        _branchLabel = cachedName.isNotEmpty
            ? cachedName
            : (cachedId.isNotEmpty ? cachedId : 'Branch: -');
      });
    } catch (_) {
      setState(() {
        _versionLabel = 'Version -';
        _branchLabel = 'Branch: -';
      });
    }
  }

  Future<void> _logout() async {
    if (_loading) return;
    setState(() => _loading = true);
    final res = await sl<AuthRepo>().logout();
    if (!mounted) return;
    res.fold(
      (err) {
        setState(() => _loading = false);
        showToast(context, message: err, state: ToastStates.error);
      },
      (_) async {
        await sl<GlobalCubit>().clearToken();
        if (!mounted) return;
        Navigator.of(context).pop();
        navigateAndFinish(context, const PhoneConfirmScreen());
        showToast(context,
            message: 'logout'.tr(context), state: ToastStates.success);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = 100.w > 1200; // kiosk / desktop detection

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final double verticalSpacing = isLargeScreen ? 2.h : 3.h;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Header title
                Center(
                  child: Text(
                    cubit.last?.aboutAppHead ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing * 2),

                /// Logos section
                Column(
                  children: [
                    Image.asset(
                      'assets/images/png/alber-logo.png',
                      width: 35.w,
                      height: 12.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: verticalSpacing),
                    Image.asset(
                      'assets/images/png/share-logo.png',
                      width: 50.w,
                      height: 12.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                SizedBox(height: verticalSpacing),

                /// Version & Branch
                Text(
                  _versionLabel,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  _branchLabel,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: verticalSpacing),

                /// Contact Information
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    if (state is! SettingsLoaded) {
                      return const SizedBox.shrink();
                    }
                    final data = state.data;
                    final name = data.name ?? data.appname;
                    final phone = data.phone ?? '';
                    final email = data.email ?? '';
                    final address = data.address ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if ((name ?? '').isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Text(
                              name!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        if (phone.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Text(
                              phone,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        if (email.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Text(
                              email,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        if (address.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Text(
                              address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                SizedBox(height: verticalSpacing - 2),

                /// Buttons
                SizedBox(
                  height: isLargeScreen ? 7.h : 6.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'close'.tr(context),
                          onPressed: () => Navigator.pop(context),
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: AppButton(
                          isLoading: _loading,
                          text: 'logout'.tr(context),
                          onPressed: _logout,
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
