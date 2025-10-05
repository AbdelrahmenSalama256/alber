import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxLength;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool enabled;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? labelHintWidget;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final AutovalidateMode autovalidateMode;

  const AppTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.labelHintWidget,
    this.focusNode,
    this.hintText,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.autofocus = false,
    this.enabled = true,
    this.contentPadding,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;
  bool _hasFocus = false;
  String? _errorMessage;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11.79.r),
            border: Border.all(
              color: const Color(0xFF707070),
              width: 0.47.w,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            onChanged: (val) {
              if (widget.onChanged != null) widget.onChanged!(val);
              if (widget.validator != null) {
                setState(() {
                  _errorMessage = widget.validator!(val);
                });
              }
            },
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmitted,
            inputFormatters: widget.inputFormatters,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            textDirection: widget.textDirection,
            textAlign: widget.textAlign,
            autovalidateMode: widget.autovalidateMode,
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xff384048),
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xffB1B1B1),
              ),
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: _hasFocus
                    ? const Color(0xff5E6368)
                    : const Color(0xff5E6368),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _hasFocus
                            ? AppColors.primary
                            : const Color(0xff8F95AB).withOpacity(0.7),
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon,
              contentPadding: widget.contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15.r),
              ),
              errorText: null, // منع الـ error جوة البوكس
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 8.w),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
