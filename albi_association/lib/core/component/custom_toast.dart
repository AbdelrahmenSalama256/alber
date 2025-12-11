import 'package:flutter/material.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

/// 🔹 Universal toast entry point
void showToast(
  BuildContext context, {
  required String message,
  required ToastStates state,
  Duration duration = const Duration(seconds: 3),
  ToastStyle style = ToastStyle.minimal,
}) {
  // Remove current
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  final bool isKiosk = 100.w > 80.h; // detect large screens

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: _buildToastContent(message, state, style, isKiosk),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: isKiosk ? 20.w : 8.w,
        vertical: isKiosk ? 4.h : 2.h,
      ),
    ),
  );
}

/// 🔹 Factory builder for toast styles
Widget _buildToastContent(
    String message, ToastStates state, ToastStyle style, bool isKiosk) {
  switch (style) {
    case ToastStyle.furniture:
      return _FurnitureToast(message: message, state: state, isKiosk: isKiosk);
    case ToastStyle.home:
      return _HomeToast(message: message, state: state, isKiosk: isKiosk);
    case ToastStyle.room:
      return _RoomToast(message: message, state: state, isKiosk: isKiosk);
    case ToastStyle.minimal:
      return _MinimalToast(message: message, state: state, isKiosk: isKiosk);
  }
}

enum ToastStates { success, error, warning, info, delivery, orderPlaced }

enum ToastStyle { furniture, home, room, minimal }

/// ==========================================================
/// 🪑 Furniture Toast (Animated, 3D style)
/// ==========================================================
class _FurnitureToast extends StatefulWidget {
  final String message;
  final ToastStates state;
  final bool isKiosk;

  const _FurnitureToast({
    required this.message,
    required this.state,
    required this.isKiosk,
  });

  @override
  State<_FurnitureToast> createState() => _FurnitureToastState();
}

class _FurnitureToastState extends State<_FurnitureToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this)
      ..forward();

    _slide = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _scale = Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double pad = widget.isKiosk ? 3.h : 2.h;
    final double iconSize = widget.isKiosk ? 24.sp : 18.sp;
    final double radius = widget.isKiosk ? 3.h : 2.h;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, _slide.value * 8.h),
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              padding: EdgeInsets.all(pad),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getToastColor(widget.state),
                    _getToastColor(widget.state).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(
                    color: _getToastColor(widget.state).withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: widget.isKiosk ? 10.w : 8.w,
                    height: widget.isKiosk ? 10.w : 8.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    child: Icon(
                      _getFurnitureIcon(widget.state),
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getToastTitle(context, widget.state),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.message,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ==========================================================
/// 🏠 Home Toast
/// ==========================================================
class _HomeToast extends StatelessWidget {
  final String message;
  final ToastStates state;
  final bool isKiosk;

  const _HomeToast({
    required this.message,
    required this.state,
    required this.isKiosk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isKiosk ? 3.h : 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isKiosk ? 3.h : 2.h),
        border: Border.all(
            color: _getToastColor(state).withOpacity(0.3), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: _getToastColor(state).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.home_outlined,
              color: _getToastColor(state), size: isKiosk ? 26.sp : 18.sp),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getToastTitle(context, state),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: _getToastColor(state),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================================================
/// 🛋 Room Toast
/// ==========================================================
class _RoomToast extends StatelessWidget {
  final String message;
  final ToastStates state;
  final bool isKiosk;

  const _RoomToast({
    required this.message,
    required this.state,
    required this.isKiosk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isKiosk ? 3.h : 2.h),
      decoration: BoxDecoration(
        color: _getToastColor(state).withOpacity(0.1),
        borderRadius: BorderRadius.circular(isKiosk ? 2.h : 1.5.h),
        border: Border.all(
            color: _getToastColor(state).withOpacity(0.3), width: 1.w),
      ),
      child: Row(
        children: [
          Icon(_getRoomIcon(state),
              color: _getToastColor(state), size: isKiosk ? 24.sp : 18.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _getToastColor(state),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================================================
/// 🔹 Minimal Toast (clean style)
/// ==========================================================
class _MinimalToast extends StatelessWidget {
  final String message;
  final ToastStates state;
  final bool isKiosk;

  const _MinimalToast({
    required this.message,
    required this.state,
    required this.isKiosk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isKiosk ? 4.w : 3.w,
        vertical: isKiosk ? 2.h : 1.2.h,
      ),
      decoration: BoxDecoration(
        color: _getToastColor(state),
        borderRadius: BorderRadius.circular(isKiosk ? 2.h : 1.5.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getSimpleIcon(state), color: Colors.white, size: 22.sp),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================================================
/// 🧠 Helper methods
/// ==========================================================
Color _getToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return AppColors.primary;
    case ToastStates.error:
      return AppColors.red;
    case ToastStates.warning:
      return Colors.amber;
    case ToastStates.info:
      return Colors.blue;
    case ToastStates.delivery:
      return Colors.green;
    case ToastStates.orderPlaced:
      return Colors.purple;
  }
}

IconData _getFurnitureIcon(ToastStates state) => {
      ToastStates.success: Icons.chair_outlined,
      ToastStates.error: Icons.error_outline,
      ToastStates.warning: Icons.warning_amber_outlined,
      ToastStates.delivery: Icons.local_shipping_outlined,
      ToastStates.orderPlaced: Icons.shopping_bag_outlined,
      ToastStates.info: Icons.home_outlined,
    }[state]!;

IconData _getRoomIcon(ToastStates state) => {
      ToastStates.success: Icons.meeting_room_outlined,
      ToastStates.error: Icons.door_front_door_outlined,
      ToastStates.warning: Icons.kitchen_outlined,
      ToastStates.delivery: Icons.garage_outlined,
      ToastStates.orderPlaced: Icons.home_outlined,
      ToastStates.info: Icons.home_outlined,
    }[state]!;

IconData _getSimpleIcon(ToastStates state) => {
      ToastStates.success: Icons.check_circle_outline,
      ToastStates.error: Icons.error_outline,
      ToastStates.warning: Icons.warning_amber_rounded,
      ToastStates.delivery: Icons.local_shipping_outlined,
      ToastStates.info: Icons.info_outline,
      ToastStates.orderPlaced: Icons.task_alt_rounded,
    }[state]!;

String _getToastTitle(BuildContext context, ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return 'toast_perfect'.tr(context);
    case ToastStates.error:
      return 'toast_oops'.tr(context);
    case ToastStates.warning:
      return 'toast_heads_up'.tr(context);
    case ToastStates.delivery:
      return 'toast_on_the_way'.tr(context);
    case ToastStates.orderPlaced:
      return 'toast_order_placed'.tr(context);
    case ToastStates.info:
      return 'toast_info'.tr(context);
  }
}

/// ==========================================================
/// 🔹 Extension for shorthand usage
/// ==========================================================
extension FurnitureToastExtension on BuildContext {
  void showFurnitureToast(
    String message, {
    ToastStates state = ToastStates.success,
    ToastStyle style = ToastStyle.furniture,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      this,
      message: message,
      state: state,
      style: style,
      duration: duration,
    );
  }
}
