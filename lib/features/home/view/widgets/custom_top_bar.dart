import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/features/profile/views/dontation_cart_screen.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isHome;
  final bool? isCart;
  final bool? isNotification;
  final VoidCallback? onBack;
  const CustomTopBar(
      {super.key,
      this.isHome = false,
      this.onBack,
      this.isCart = false,
      this.isNotification = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70.h,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !isHome!
                ? InkWell(
                    onTap: onBack ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.textGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15.r),
                        border:
                            Border.all(width: 1.w, color: AppColors.primary),
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          size: 25.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                : Image.asset(
                    "assets/images/png/alber-inline-logo.png",
                    width: 140.w,
                    height: 40.h,
                    fit: BoxFit.contain,
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  CupertinoIcons.search,
                  color: const Color(0xffCCCCCC),
                  size: 30.sp,
                ),
                if (!isCart!) ...[
                  SizedBox(width: 16.w),
                  _buildSvgIcon(
                    "assets/images/svg/cart.svg",
                    count: 12,
                    onTap: () {
                      navigateTo(context, DontationCartScreen());
                    },
                  ),
                ],
                SizedBox(width: 16.w),
                _buildSvgIcon(
                  "assets/images/svg/notifications_active.svg",
                  count: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSvgIcon(String assetPath, {int? count, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 28.w,
            height: 28.h,
            color: const Color(0xffCCCCCC),
          ),
          if (count != null)
            PositionedDirectional(
              top: -6.h,
              start: -8.w,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: const BoxDecoration(
                  color: Color(0xff5F5F5F),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
