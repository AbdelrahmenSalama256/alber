import 'dart:math';
import 'package:flutter/widgets.dart';

class AppSizer {
  // Set these to your Figma/base design
  static const double designWidth = 390; // e.g., iPhone 12 width
  static const double designHeight = 844; // e.g., iPhone 12 height

  static late MediaQueryData mq;
  static late double width, height, safeWidth, safeHeight;
  static late double _scaleW, _scaleH, scale;
  static bool _initialized = false;

  static void init(BuildContext context) {
    mq = MediaQuery.of(context);
    width = mq.size.width;
    height = mq.size.height;

    // Respect safe areas (status/nav bars)
    final padding = mq.padding;
    safeWidth = width; // usually keep full width
    safeHeight = height - padding.top - padding.bottom;

    _scaleW = safeWidth / designWidth;
    _scaleH = safeHeight / designHeight;
    scale = min(_scaleW, _scaleH);
    _initialized = true;
  }

  static void _ensure() {
    if (!_initialized) {
      throw FlutterError(
        'AppSizer.init(context) was not called. '
        'Call it from MaterialApp.builder or your top screen build.',
      );
    }
  }

  // Optional breakpoints
  static bool get isMobile => width < 600;
  static bool get isTablet => width >= 600 && width < 1024;
  static bool get isDesktop => width >= 1024;
}

// Numeric extensions
extension AppSizerNum on num {
  // Viewport percentages (like CSS 1vw/1vh)
  double get vw {
    AppSizer._ensure();
    return (this / 100.0) * AppSizer.safeWidth;
  }

  double get vh {
    AppSizer._ensure();
    return (this / 100.0) * AppSizer.safeHeight;
  }

  // Scale relative to your design size
  double get sw {
    AppSizer._ensure();
    return this * (AppSizer.safeWidth / AppSizer.designWidth);
  }

  double get sh {
    AppSizer._ensure();
    return this * (AppSizer.safeHeight / AppSizer.designHeight);
  }

  // Uniform scale (good for radius, icons)
  double get r {
    AppSizer._ensure();
    return this * AppSizer.scale;
  }

  // Text scale (Flutter will still apply system textScaleFactor)
  double get sp => r;
}

// Handy context helpers
extension ContextSizeX on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenW => MediaQuery.of(this).size.width;
  double get screenH => MediaQuery.of(this).size.height;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
}

