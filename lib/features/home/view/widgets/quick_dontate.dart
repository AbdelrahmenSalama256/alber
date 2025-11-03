import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/locale/app_loacl.dart';

import '../../../../core/constants/app_colors.dart';

class ExpandableQuickDonateFAB extends StatefulWidget {
  final VoidCallback onQuickDonate;
  final VoidCallback onDedicateDonation;
  final VoidCallback onVolunteerProjects;

  const ExpandableQuickDonateFAB({
    super.key,
    required this.onQuickDonate,
    required this.onDedicateDonation,
    required this.onVolunteerProjects,
  });

  @override
  State<ExpandableQuickDonateFAB> createState() =>
      _ExpandableQuickDonateFABState();
}

class _ExpandableQuickDonateFABState extends State<ExpandableQuickDonateFAB>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<Offset> _slideAnimation3;
  TextDirection? _lastDirection;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _configureDirectionalAnimations(TextDirection.ltr);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dir = Directionality.of(context);
    if (_lastDirection != dir) {
      _configureDirectionalAnimations(dir);
    }
  }

  void _configureDirectionalAnimations(TextDirection dir) {
    final begin = Offset(dir == TextDirection.rtl ? 0.5 : -0.5, 0.0);
    _slideAnimation1 = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation2 = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation3 = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
    _lastDirection = dir;
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _close() {
    if (_expanded) {
      setState(() {
        _expanded = false;
        _animationController.reverse();
      });
    }
  }

  void _handleOptionTap(VoidCallback onTap) {
    _close();
    Future.delayed(const Duration(milliseconds: 150), onTap);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background overlay
        if (_expanded)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

        // Options panel - positioned like a smart sidebar
        AnimatedPositionedDirectional(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: _expanded ? 270.h : 20.h,
          start: _expanded ? 10.w : -200.w,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20.r,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOptionItem(
                      animation: _slideAnimation1,
                      icon: Icons.flash_on,
                      label: 'quick_donate'.tr(context),
                      onTap: () => _handleOptionTap(widget.onQuickDonate),
                    ),
                    _buildDivider(),
                    _buildOptionItem(
                      animation: _slideAnimation2,
                      icon: Icons.card_giftcard,
                      label: 'dedicate_donation'.tr(context),
                      onTap: () => _handleOptionTap(widget.onDedicateDonation),
                    ),
                    _buildDivider(),
                    _buildOptionItem(
                      animation: _slideAnimation3,
                      icon: Icons.volunteer_activism,
                      label: 'volunteer_projects'.tr(context),
                      onTap: () => _handleOptionTap(widget.onVolunteerProjects),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Main FAB Button
        PositionedDirectional(
          bottom: 200.h,
          start: 10.w,
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _expanded ? 50.w : 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 15.r,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _expanded
                    ? Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.sp,
                      )
                    : Icon(
                        CupertinoIcons.plus,
                        color: Colors.white,
                        size: 24.sp,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 0.5,
      color: Colors.grey[300],
      indent: 16.w,
      endIndent: 16.w,
    );
  }

  Widget _buildOptionItem({
    required Animation<Offset> animation,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SlideTransition(
      position: animation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 25.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    size: 18.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
