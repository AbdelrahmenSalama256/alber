import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';

import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.text = '',
    this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final radiusSm = sl<GlobalCubit>().radiusSm;
    final radiusXs = sl<GlobalCubit>().radiusXs;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(radiusSm),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusXs),
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (text.isNotEmpty)
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            if (child != null) Expanded(child: child!),
          ],
        ),
      ),
    );
  }
}
