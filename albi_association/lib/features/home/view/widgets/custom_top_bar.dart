import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/features/home/view/widgets/logout_popup.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/cubit/global_state.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isHome;
  final VoidCallback? onBack;

  const CustomTopBar({
    super.key,
    this.isHome = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = context.read<GlobalCubit>().language == "ar";

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: 13.h,
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT: back (only when !home). On home keep spacer to keep layout balanced.
            if (!(isHome ?? false))
              InkWell(
                onTap: onBack ?? () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(2.h),
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(1.h),
                    border: Border.all(width: 0.3.w, color: AppColors.primary),
                  ),
                  child: Icon(
                    isRtl
                        ? CupertinoIcons.chevron_forward
                        : CupertinoIcons.chevron_back,
                    size: 5.w,
                    color: AppColors.primary,
                  ),
                ),
              )
            else
              SizedBox(width: 8.w),

            // CENTER:
            // - Default mode (!home): show logo centered
            // - Home: show nothing (keeps it empty as requested)
            Expanded(
              child: Center(
                child: (isHome ?? false)
                    ? const SizedBox.shrink()
                    : Image.asset(
                        "assets/images/png/alber-inline-logo.png",
                        width: 40.w,
                        fit: BoxFit.contain,
                      ),
              ),
            ),

            // RIGHT:
            // - Home: ONLY info button
            // - Default: countdown chip
            if (isHome ?? false)
              InkWell(
                onTap: () async => await customPopup(context),
                borderRadius: BorderRadius.circular(2.h),
                child: Icon(
                  CupertinoIcons.info_circle,
                  color: const Color(0xFFE0E0E0),
                  size: 7.w,
                ),
              )
            else
              _CountdownChip(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(13.h);

  Future<void> customPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
          // keep the dialog standard; set a translucent theme/dialog if needed
          // contentPadding:
          //     EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3.h),
          ),
          child: const LogoutPopup(),
        );
      },
    );
  }
}

class _CountdownChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        const total = 9000;
        int remaining = total;
        if (state is InactivityTimerUpdateState) {
          remaining = state.remainingSeconds.clamp(0, total);
        }
        final p = remaining / total;
        final color = (p > 0.5)
            ? Color.lerp(Colors.orange, Colors.green, (p - 0.5) * 2)!
            : Color.lerp(Colors.red, Colors.orange, p * 2)!;

        final locale = Localizations.localeOf(context).toString();
        final fmt = NumberFormat.decimalPattern(locale);
        final mm = fmt.format(remaining ~/ 60);
        final ss = fmt.format(remaining % 60);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.h),
            border: Border.all(color: color, width: 0.4.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 5.w,
                height: 5.w,
                child: Lottie.asset(
                  'assets/images/animations/clock.json',
                  animate: true,
                  repeat: true,
                  reverse: true,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '$mm:$ss',
                style: TextStyle(
                    color: color, fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
