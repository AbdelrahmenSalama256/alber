import 'package:flutter/material.dart';

class InnerShadow extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blur;
  final Offset offset;
  final BorderRadius? borderRadius;

  const InnerShadow({
    super.key,
    required this.child,
    this.color = const Color(0x4D000000),
    this.blur = 8,
    this.offset = const Offset(0, 2),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _InnerShadowPainter(
                color: color,
                blur: blur,
                offset: offset,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  final Color color;
  final double blur;
  final Offset offset;
  final BorderRadius? borderRadius;

  _InnerShadowPainter({
    required this.color,
    required this.blur,
    required this.offset,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = (borderRadius ?? BorderRadius.circular(12)).toRRect(rect);

    final outer = Path()
      ..addRect(Rect.fromLTWH(
          -size.width, -size.height, size.width * 3, size.height * 3))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    final paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(outer, paint);
    canvas.restore();

    final clipPaint = Paint()..blendMode = BlendMode.dstIn;
    final clipPath = Path()..addRRect(rrect);
    canvas.drawPath(clipPath, clipPaint);
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) {
    return color != oldDelegate.color ||
        blur != oldDelegate.blur ||
        offset != oldDelegate.offset ||
        borderRadius != oldDelegate.borderRadius;
  }
}
