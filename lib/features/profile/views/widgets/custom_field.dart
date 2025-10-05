import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFormFields extends StatefulWidget {
  const CustomFormFields({super.key});

  @override
  State<CustomFormFields> createState() => _CustomFormFieldsState();
}

class _CustomFormFieldsState extends State<CustomFormFields> {
  String? selectedDropdownValue;
  int numericValue = 100;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Remove Scaffold, use Container instead
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Field
            _buildCustomField(
              label: 'نوع الإجازة',
              child: DropdownButtonFormField<String>(
                value: selectedDropdownValue,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                ),
                hint: Text(
                  'اختر نوع الإجازة',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14.sp,
                  ),
                ),
                items: ['إجازة سنوية', 'إجازة مرضية', 'إجازة طارئة']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDropdownValue = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 16.h),

            // Numeric Input Field
            _buildCustomField(
              label: 'عدد الأيام',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    _buildIncrementButton(
                      icon: Icons.remove,
                      onPressed: () {
                        setState(() {
                          if (numericValue > 0) numericValue--;
                        });
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$numericValue',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    _buildIncrementButton(
                      icon: Icons.add,
                      onPressed: () {
                        setState(() {
                          numericValue++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Date Pickers Row
            Row(
              children: [
                Expanded(
                  child: _buildCustomField(
                    label: 'تاريخ البداية',
                    child: _buildDateField(
                      date: startDate,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            startDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildCustomField(
                    label: 'تاريخ النهاية',
                    child: _buildDateField(
                      date: endDate,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            endDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Bottom Number Boxes
            _buildCustomField(
              label: 'التفاصيل',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNumberBox('15'),
                  _buildNumberBox('30'),
                  _buildNumberBox('45'),
                  _buildNumberBox('60'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipPath(
          clipper: PolygonClipper(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            color: const Color(0xFF2D3436),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildIncrementButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border(
            right: icon == Icons.remove
                ? BorderSide(color: Colors.grey.shade300)
                : BorderSide.none,
            left: icon == Icons.add
                ? BorderSide(color: Colors.grey.shade300)
                : BorderSide.none,
          ),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'اختر التاريخ',
              style: TextStyle(
                fontSize: 14.sp,
                color: date != null ? Colors.black : Colors.grey.shade400,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 18.sp,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberBox(String number) {
    return Container(
      width: 70.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class PolygonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left (0,0)
    path.lineTo(size.width, 0); // Top-right
    path.lineTo(size.width, size.height * 0.47); // 47% down on right side
    path.lineTo(size.width, size.height); // Bottom-right
    path.lineTo(size.width * 0.25, size.height); // 25% from left at bottom
    path.lineTo(0, size.height * 0.5); // Middle-left
    path.lineTo(size.width * 0.25, 0); // 25% from left at top
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
