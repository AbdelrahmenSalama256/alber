import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/locale/app_loacl.dart';

import '../../../shared/widgets/qty_stepper.dart';

class CartItem extends StatefulWidget {
  final String imageAsset;
  final String tagText;
  final String amountText;
  final String bottomTitle;
  final int initialQty;
  final ValueChanged<int>? onQtyChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CartItem({
    super.key,
    required this.imageAsset,
    required this.tagText,
    required this.amountText,
    required this.bottomTitle,
    this.initialQty = 1,
    this.onQtyChanged,
    this.onDelete,
    this.onTap,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.initialQty;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 6.w)),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(12.r),
                      bottomStart: Radius.circular(12.r),
                    ),
                    child: Image.asset(
                      widget.imageAsset,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: 100.w, minHeight: 30.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF707070).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Text(
                                widget.tagText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            InkWell(
                              onTap: widget.onDelete,
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                width: 41.297935485839844.w,
                                height: 41.297935485839844.w,
                                decoration: const BoxDecoration(
                                    color: Color(0xffE8E8E7),
                                    shape: BoxShape.circle),
                                child: const Icon(CupertinoIcons.trash,
                                    color: Color(0xffB3B3B3)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "quantity".tr(context),
                          style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 6.h),
                        QtyStepper(
                          qty: _qty,
                          onChanged: (q) {
                            setState(() => _qty = q);
                            widget.onQtyChanged?.call(q);
                          },
                          accent: AppColors.grey,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "donate_amount".tr(context),
                          style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          height: 26.35201644897461.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r)),
                          child: Text(widget.amountText,
                              style: TextStyle(
                                  fontSize: 8.96.sp,
                                  color: AppColors.textGrey,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 175.w,
            right: 0,
            bottom: 0,
            child: Container(
              width: 197.64012145996094.w,
              decoration: BoxDecoration(
                color: const Color(0xFF707070),
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(12.r),
                  topStart: Radius.circular(5.r),
                  bottomEnd: Radius.circular(5.r),
                  bottomStart: Radius.circular(12.r),
                ),
              ),
              child: Center(
                child: Text(
                  widget.bottomTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
