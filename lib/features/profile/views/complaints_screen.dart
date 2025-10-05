import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/component/widgets/app_button.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';

class ContactComplaintsScreen extends StatefulWidget {
  const ContactComplaintsScreen({super.key});
  @override
  State<ContactComplaintsScreen> createState() =>
      _ContactComplaintsScreenState();
}

class _ContactComplaintsScreenState extends State<ContactComplaintsScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String? _topic;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${'complaints'.tr(context)} - ${'contact_us'.tr(context)}",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEDEDED), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Icon(Icons.help_outline,
                        size: 16.sp, color: AppColors.textGrey),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12.r,
                        offset: Offset(0, 6.h))
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'للاستفسار عن مساهماتك معنا أو مقترحاتك وشكاوى أو متابعة وسيلة تواصلنا معك، يسعدنا خدمتك في اتصالك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.6),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'جمعية البر بجدة المملكة العربية السعودية، العطاس 6780 3413 جدة 23521',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          SvgPicture.asset("assets/images/svg/phone.svg",
                              width: 16.w),
                          SizedBox(width: 6.w),
                          Text('920005757',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700)),
                        ]),
                        SizedBox(width: 16.w),
                        Row(children: [
                          SvgPicture.asset("assets/images/svg/mail.svg",
                              width: 16.w),
                          SizedBox(width: 6.w),
                          Text('info@albir.sa',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700)),
                        ]),
                        SizedBox(width: 16.w),
                        Row(children: [
                          SvgPicture.asset("assets/images/svg/map-marker.svg",
                              width: 16.w),
                          SizedBox(width: 6.w),
                          Text('جدة',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              _LabeledInput(
                  controller: _name,
                  label: 'name'.tr(context),
                  hint: 'name'.tr(context)),
              SizedBox(height: 12.h),
              _LabeledInput(
                  controller: _email,
                  label: 'email'.tr(context),
                  hint: 'email'.tr(context),
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 12.h),
              _LabeledInput(
                  controller: _phone,
                  label: 'phone_number'.tr(context),
                  hint: 'phone_number'.tr(context),
                  keyboardType: TextInputType.phone),
              SizedBox(height: 12.h),
              _LabeledInput(
                  controller: _subject,
                  label: 'subject'.tr(context),
                  hint: 'subject'.tr(context)),
              SizedBox(height: 12.h),
              _LabeledDropdown(
                value: _topic,
                label: 'topic'.tr(context),
                hint: 'topic'.tr(context),
                items: const ['شكوى', 'اقتراح', 'استفسار'],
                onChanged: (v) => setState(() => _topic = v),
              ),
              SizedBox(height: 12.h),
              _LabeledInput(
                  controller: _message,
                  label: 'message'.tr(context),
                  hint: 'message'.tr(context),
                  maxLines: 5),
              SizedBox(height: 20.h),
              SizedBox(
                height: 52.h,
                child: AppButton(
                  text: 'send'.tr(context),
                  onPressed: () {},
                  textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeShape extends StatelessWidget {
  final String text;
  final double height;
  final EdgeInsets padding;
  const _BadgeShape(
      {required this.text,
      this.height = 30,
      this.padding = const EdgeInsets.symmetric(horizontal: 14)});
  @override
  Widget build(BuildContext context) {
    final h = height.h;
    return ClipPath(
      clipper: _ConcaveLabelClipper(radius: 12.r, notch: 12.r),
      child: Container(
        height: h,
        padding: EdgeInsets.symmetric(horizontal: padding.horizontal.w / 2),
        alignment: Alignment.center,
        color: AppColors.textGrey,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ConcaveLabelClipper extends CustomClipper<Path> {
  final double radius;
  final double notch;
  const _ConcaveLabelClipper({required this.radius, required this.notch});
  @override
  Path getClip(Size size) {
    final r = radius;
    final n = notch;
    final w = size.width;
    final h = size.height;
    final p = Path();
    p.moveTo(r, 0);
    p.quadraticBezierTo(0, 0, 0, r);
    p.lineTo(0, h - r);
    p.quadraticBezierTo(0, h, r, h);
    p.lineTo(w - r - n, h);
    p.quadraticBezierTo(w - n, h, w - n, h - r);
    p.arcToPoint(
      Offset(w, h - n),
      radius: Radius.circular(n),
      clockwise: false,
    );
    p.lineTo(w, r);
    p.quadraticBezierTo(w, 0, w - r, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant _ConcaveLabelClipper oldClipper) =>
      oldClipper.radius != radius || oldClipper.notch != notch;
}

class _LabeledInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  const _LabeledInput(
      {required this.controller,
      required this.label,
      required this.hint,
      this.maxLines = 1,
      this.keyboardType});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 14.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h))
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: const Color(0xFFB6B6B6),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
            ),
            style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                height: 1.6),
          ),
        ),
        PositionedDirectional(top: 0, end: 0, child: _BadgeShape(text: label)),
      ],
    );
  }
}

class _LabeledDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String label;
  final String hint;
  final ValueChanged<String?> onChanged;
  const _LabeledDropdown(
      {required this.value,
      required this.items,
      required this.label,
      required this.hint,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 14.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h))
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(hint,
                  style: TextStyle(
                      color: const Color(0xFFB6B6B6),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600)),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e,
                            style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700)),
                      ))
                  .toList(),
              onChanged: onChanged,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textGrey),
            ),
          ),
        ),
        PositionedDirectional(top: 0, end: 0, child: _BadgeShape(text: label)),
      ],
    );
  }
}
