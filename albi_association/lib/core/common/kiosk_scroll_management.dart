import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class KioskScrollBehavior extends MaterialScrollBehavior {
  const KioskScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      };
}
