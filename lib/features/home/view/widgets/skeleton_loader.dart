import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool isCircular;

  /// NEW → duration for highlight animation
  final Duration duration;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.isCircular = false,
    this.duration = const Duration(milliseconds: 600), // default
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
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _isHighlighted = !_isHighlighted;
        });
        _startAnimation(); // repeat
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.isCircular
        ? BorderRadius.circular(widget.width / 2)
        : widget.borderRadius;

    return AnimatedContainer(
      duration: widget.duration,
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
