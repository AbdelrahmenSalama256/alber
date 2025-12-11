import 'package:flutter/material.dart';
import 'package:qafeel/common/custom_keyboard/custom_keyboard_controller.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomKeyboardView extends StatelessWidget {
  const CustomKeyboardView({
    super.key,
    required this.controller,
    this.widthButton,
    this.heightButton,
    this.maxLength,
  });
  final CustomKeyBoardController controller;
  final double? widthButton, heightButton;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final double btnW = widthButton ?? 16.w;
    final double btnH = heightButton ?? 16.w;
    final double hGap = 6.w;
    final double vGap = 2.h;

    return Column(
      children: [
        SizedBox(height: vGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('3', btnW, btnH),
            SizedBox(width: hGap),
            _buildNumberButton('2', btnW, btnH),
            SizedBox(width: hGap),
            _buildNumberButton('1', btnW, btnH),
          ],
        ),
        SizedBox(height: vGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('6', btnW, btnH),
            SizedBox(width: hGap),
            _buildNumberButton('5', btnW, btnH),
            SizedBox(width: hGap),
            _buildNumberButton('4', btnW, btnH),
          ],
        ),
        SizedBox(height: vGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('9', btnW, btnH),
            SizedBox(width: hGap),
            _buildNumberButton('8', btnW, btnH),
            SizedBox(width: hGap),
            _buildNumberButton('7', btnW, btnH),
          ],
        ),
        SizedBox(height: vGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBackspaceButton(btnW * 0.8, btnH * 0.8),
            SizedBox(width: hGap * 1.5),
            _buildNumberButton('0', btnW, btnH),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String digit, double w, double h) {
    return GestureDetector(
      onTap: () => controller.inputDigit(digit),
      child: Container(
        alignment: Alignment.center,
        width: w,
        height: h,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(digit,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 16.sp,
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(double w, double h) {
    return GestureDetector(
      onTap: controller.backspace,
      child: Container(
        width: w,
        height: h,
        alignment: Alignment.center,
        child: Icon(Icons.backspace, size: 18.sp, color: AppColors.primary),
      ),
    );
  }
}
