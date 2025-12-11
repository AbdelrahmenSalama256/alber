import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/settings/view/cubit/settings_cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../home/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // initialize video
    _videoController =
        VideoPlayerController.asset('assets/images/animations/intro.mp4')
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });

    _videoController.setLooping(false);
    _videoController.setVolume(0); // mute if needed

    // listen for video end
    _videoController.addListener(() {
      if (_videoController.value.isInitialized &&
          !_videoController.value.isPlaying &&
          _videoController.value.position >= _videoController.value.duration &&
          !_navigated) {
        _goNext();
      }
    });
  }

  void _goNext() {
    _navigated = true;
    final isAuthed = sl<GlobalCubit>().isAuthenticated;
    // Try to start settings fetch if a branch is already cached
    final cachedId =
        sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId);
    final branchId = int.tryParse(cachedId ?? '');
    if (branchId != null) {
      context.read<SettingsCubit>().init(branchId: branchId);
    }
    final next = isAuthed ? HomeScreen() : const PhoneConfirmScreen();
    navigateAndFinish(context, next);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Show the splash video
          if (_videoController.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
        ],
      ),
    );
  }
}
