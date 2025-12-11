import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class ServiceCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  /// If set, this color overrides the palette-picked color
  final Color? overrideColor;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.overrideColor,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  // ---- Palette handling (random order, looped) ----
  static final List<Color> _basePalette = <Color>[
    _hex('#505050'),
    _hex('#44C2A4'),
    _hex('#25C0F1'),
    _hex('#505050'),
  ];

  static bool _paletteInitialized = false;
  static late List<Color> _shuffledPalette;
  static int _cursor = 0;

  static void _initPaletteOnce() {
    if (_paletteInitialized) return;
    _shuffledPalette = List<Color>.from(_basePalette);
    _shuffledPalette.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    _paletteInitialized = true;
  }

  static Color _hex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final value = int.parse(cleaned, radix: 16);
    return Color(0xFF000000 | value);
  }

  Color? _accent;

  @override
  void initState() {
    super.initState();
    _initPaletteOnce();

    // override wins; else take next color from shuffled list (looping)
    _accent = widget.overrideColor ??
        _shuffledPalette[_cursor % _shuffledPalette.length];
    _cursor++;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _accent ?? Colors.grey;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 42.w, // fits 2 per row comfortably
        height: 28.h, // proportional height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.h),
          border: Border.all(color: borderColor, width: 0.5.w),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Image
            Positioned.fill(
              bottom: 5.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.h),
                child: widget.imagePath.toLowerCase().endsWith('.svg')
                    ? SvgPicture.asset(
                        widget.imagePath,
                        fit: BoxFit.contain,
                        placeholderBuilder: (context) => Center(
                          child: CircularProgressIndicator(
                            color: borderColor.withOpacity(0.6),
                            strokeWidth: 1.5.w,
                          ),
                        ),
                      )
                    : Image.network(
                        widget.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.broken_image_outlined,
                          size: 8.h,
                          color: borderColor.withOpacity(0.5),
                        ),
                        loadingBuilder: (context, child, lp) => lp == null
                            ? child
                            : Center(
                                child: CircularProgressIndicator(
                                  color: borderColor.withOpacity(0.6),
                                  strokeWidth: 1.5.w,
                                ),
                              ),
                      ),
              ),
            ),

            // Title
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                child: Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: borderColor, // same color for text
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
