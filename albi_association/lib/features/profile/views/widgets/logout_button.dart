import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onLogout;
  const LogoutButton({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onLogout,
      child: Container(
        width: 316.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            bottom: BorderSide(
              color: AppColors.primary,
              width: 1.03.w,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/svg/logout.svg",
              width: 25.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "logout".tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textPrimary.withOpacity(0.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
