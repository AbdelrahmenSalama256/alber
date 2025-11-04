import 'package:flutter/widgets.dart';

class AuthReturnService {
  VoidCallback? _pendingAction;

  bool get hasPending => _pendingAction != null;

  void setPendingAction(VoidCallback action) {
    _pendingAction = action;
  }

  void runPending() {
    final cb = _pendingAction;
    _pendingAction = null;
    if (cb != null) cb();
  }

  void clear() {
    _pendingAction = null;
  }
}

