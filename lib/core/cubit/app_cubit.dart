import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

/// Base cubit that provides safe emitting and tracked subscriptions.
///
/// - emitSafe: no-ops if the cubit is already closed.
/// - track: register a StreamSubscription to be cancelled on close.
abstract class AppCubit<S> extends Cubit<S> {
  AppCubit(S initialState) : super(initialState);

  final List<StreamSubscription<dynamic>> _subs =
      <StreamSubscription<dynamic>>[];

  @protected
  void emitSafe(S state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      emit(state);
    }
  }

  @protected
  void track(StreamSubscription<dynamic> sub) {
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    for (final s in _subs) {
      try {
        await s.cancel();
      } catch (_) {}
    }
    _subs.clear();
    return super.close();
  }
}
