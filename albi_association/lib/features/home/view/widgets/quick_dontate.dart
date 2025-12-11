import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_colors.dart';

class ExpandableQuickDonateFAB extends StatefulWidget {
  final VoidCallback onQuickDonate;
  const ExpandableQuickDonateFAB({super.key, required this.onQuickDonate});

  @override
  State<ExpandableQuickDonateFAB> createState() =>
      _ExpandableQuickDonateFABState();
}

class _ExpandableQuickDonateFABState extends State<ExpandableQuickDonateFAB> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);
  void _close() => setState(() => _expanded = false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (_expanded)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
            ),
          ),
        PositionedDirectional(
          bottom: 20.h,
          start: 5.w,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: _expanded ? 200.69754028320312.w : 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6.76),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: _expanded ? null : _toggle,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_expanded)
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: _expanded ? 1.0 : 0.0,
                          curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                          child: InkWell(
                            onTap: () {
                              widget.onQuickDonate();
                              _close();
                            },
                            child: Container(
                              constraints: BoxConstraints(minHeight: 40.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.textGrey,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(start: 8.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'quick_donate'.tr(context),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      InkResponse(
                        onTap: _toggle,
                        radius: 24,
                        child: Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
