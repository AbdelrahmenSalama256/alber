import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/global_cubit.dart';
import '../../../../core/cubit/global_state.dart';
import '../../../../core/services/service_locator.dart';
import '../home_screen.dart';

class CounterWrapperMain extends StatefulWidget {
  final Widget child;

  const CounterWrapperMain({
    super.key,
    required this.child,
  });

  @override
  State<CounterWrapperMain> createState() => _CounterWrapperMainState();
}

class _CounterWrapperMainState extends State<CounterWrapperMain>
    with WidgetsBindingObserver {
  late final GlobalCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<GlobalCubit>();
    WidgetsBinding.instance.addObserver(this);

    // Start timer when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.startInactivityTimer();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop timer when leaving the screen
    _cubit.stopInactivityTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _cubit.resumeTimer();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _cubit.pauseTimer();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _cubit.stopInactivityTimer();
        break;
    }
  }

  void _handleUserInteraction() {
    _cubit.resetInactivityTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalCubit, GlobalState>(
      listener: (context, state) {
        if (state is GlobalAutoNavigateState) {
          _navigateToHome(context);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleUserInteraction,
        onTapDown: (_) => _handleUserInteraction(),
        onPanDown: (_) => _handleUserInteraction(),
        onScaleStart: (_) => _handleUserInteraction(),
        onScaleUpdate: (_) => _handleUserInteraction(),
        child: Listener(
          onPointerDown: (_) => _handleUserInteraction(),
          onPointerMove: (_) => _handleUserInteraction(),
          onPointerHover: (_) => _handleUserInteraction(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                _handleUserInteraction();
              }
              return false;
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (route) => false,
    );
  }
}
