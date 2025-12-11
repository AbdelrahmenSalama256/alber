import 'package:flutter/widgets.dart';

class EnsureVisibleWhenFocused extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double alignment;

  const EnsureVisibleWhenFocused({
    super.key,
    required this.focusNode,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOut,
    this.alignment = 0.3,
  });

  @override
  State<EnsureVisibleWhenFocused> createState() => _EnsureVisibleWhenFocusedState();
}

class _EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant EnsureVisibleWhenFocused oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (!mounted) return;
    if (widget.focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final ctx = _key.currentContext;
        if (ctx == null) return;
        try {
          await Scrollable.ensureVisible(
            ctx,
            alignment: widget.alignment,
            duration: widget.duration,
            curve: widget.curve,
          );
        } catch (_) {
          // Ignore if no scrollable ancestor.
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}

