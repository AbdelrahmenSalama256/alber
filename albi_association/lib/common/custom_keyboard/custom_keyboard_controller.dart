import 'package:flutter/material.dart';

/// Lightweight controller to drive the on-screen numeric keyboard.
/// Attach a target TextEditingController and optionally a maxLength.
class CustomKeyBoardController {
  TextEditingController? _target;
  int? _maxLength;

  void attach(TextEditingController controller, {int? maxLength}) {
    _target = controller;
    _maxLength = maxLength;
  }

  TextEditingController get target => _target ??= TextEditingController();

  void backspace() {
    final t = _target;
    if (t == null) return;
    if (t.text.isNotEmpty) {
      t.text = t.text.substring(0, t.text.length - 1);
      t.selection = TextSelection.fromPosition(TextPosition(offset: t.text.length));
    }
  }

  void inputDigit(String digit) {
    final t = _target;
    if (t == null) return;
    if (_maxLength == null || t.text.length < _maxLength!) {
      t.text += digit;
      t.selection = TextSelection.fromPosition(TextPosition(offset: t.text.length));
    }
  }
}
