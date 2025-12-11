import 'package:flutter/material.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool isExpanded;

  const AppDropdownField({
    super.key,
    this.labelText,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.isExpanded = true,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  bool _hasFocus = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h;

    // --- shared sizing logic with AppTextField ---
    final borderColor = AppColors.primary.withOpacity(0.5);
    final borderW = 0.3.w;
    final borderR = 1.5.h;
    final fieldHeight = 6.h;
    final fontSize = 15.sp;
    final labelSize = 15.sp;
    final hintSize = 15.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FocusScope(
          onFocusChange: (focus) => setState(() => _hasFocus = focus),
          child: Container(
            height: fieldHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderR),
              border: Border.all(
                color: _hasFocus ? AppColors.primary : borderColor,
                width: borderW,
              ),
              boxShadow: [
                if (_hasFocus)
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: DropdownButtonFormField<T>(
              isExpanded: widget.isExpanded,
              value: widget.value,
              items: widget.items,
              onChanged: widget.enabled
                  ? (v) {
                      widget.onChanged?.call(v);
                      if (widget.validator != null) {
                        setState(() => _errorMessage = widget.validator!(v));
                      }
                    }
                  : null,
              validator: widget.validator,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  fontSize: labelSize,
                  color: const Color(0xff5E6368),
                  fontWeight: FontWeight.w500,
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: hintSize,
                  color: const Color(0xffB1B1B1),
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.5.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderR),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderR),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderR),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: fontSize,
                color: const Color(0xff384048),
                fontWeight: FontWeight.w500,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
                size: isKiosk ? 22.sp : 18.sp,
              ),
            ),
          ),
        ),
        if (_errorMessage != null && _errorMessage!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 1.w),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
