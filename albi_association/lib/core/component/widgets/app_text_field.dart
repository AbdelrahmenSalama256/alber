import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

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
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final AutovalidateMode autovalidateMode;

  /// 🔹 Custom Border Options
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;

  const AppTextField({
    super.key,
    required this.controller,
    this.labelText,
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
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.focusNode,
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
      final hasFocus = _focusNode.hasFocus;
      setState(() => _hasFocus = hasFocus);
      if (hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          try {
            Scrollable.ensureVisible(
              context,
              alignment: 0.3,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
            );
          } catch (_) {}
        });
      }
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  List<TextInputFormatter> _getInputFormatters() {
    final formatters = <TextInputFormatter>[];
    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }
    if (widget.keyboardType == TextInputType.phone ||
        widget.keyboardType == TextInputType.number) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9+()\s]')));
    }
    return formatters;
  }

  @override
  Widget build(BuildContext context) {
    final bool isKiosk = 100.w > 80.h; // detect large / landscape screens

    // --- Adaptive metrics ---
    final borderColor =
        widget.borderColor ?? AppColors.primary.withOpacity(0.5);
    final borderW = widget.borderWidth ?? (0.3.w);
    final borderR = widget.borderRadius ?? (1.5.h);
    final fieldHeight = isKiosk ? 9.h : 6.h;
    final fontSize = 15.sp;
    final hintSize = 15.sp;
    final labelSize = 15.sp;
    final iconSize = isKiosk ? 22.sp : 18.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: fieldHeight,
          clipBehavior: Clip.hardEdge,
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
              widget.onChanged?.call(val);
              if (widget.validator != null) {
                setState(() => _errorMessage = widget.validator!(val));
              }
            },
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmitted,
            inputFormatters: _getInputFormatters(),
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            textDirection: widget.textDirection,
            textAlign: widget.textAlign,
            autovalidateMode: widget.autovalidateMode,
            style: TextStyle(
              fontSize: fontSize,
              color: const Color(0xff384048),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: hintSize,
                color: const Color(0xffB1B1B1),
                fontWeight: FontWeight.w600,
              ),
              labelText: widget.labelText,
              labelStyle: TextStyle(
                fontSize: labelSize,
                color: const Color(0xff5E6368),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: IconTheme(
                        data: IconThemeData(
                            size: iconSize, color: AppColors.primary),
                        child: widget.prefixIcon!,
                      ),
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _hasFocus
                            ? AppColors.primary
                            : const Color(0xff8F95AB).withOpacity(0.7),
                        size: iconSize,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    )
                  : widget.suffixIcon,
              contentPadding: widget.contentPadding ??
                  EdgeInsets.symmetric(
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
              counterText: '',
            ),
          ),
        ),

        // --- Error text ---
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
