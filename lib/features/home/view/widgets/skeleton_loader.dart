import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool isCircular;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.isCircular = false,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> {
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isHighlighted = !_isHighlighted;
        });
        _startAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.isCircular
        ? BorderRadius.circular(widget.width / 2)
        : widget.borderRadius;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color:
            _isHighlighted ? const Color(0xFFF0F0F0) : const Color(0xFFE0E0E0),
        borderRadius: radius,
      ),
    );
  }
}
