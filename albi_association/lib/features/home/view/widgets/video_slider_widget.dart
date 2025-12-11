import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/features/home/data/model/home_slider_model.dart';
import 'package:video_player/video_player.dart';

class VideoSliderWidget extends StatefulWidget {
  final List<HomeSliderModel> sliders;
  final int currentIndex;
  final ValueChanged<int>? onPageChanged;

  const VideoSliderWidget({
    super.key,
    required this.sliders,
    required this.currentIndex,
    this.onPageChanged,
  });

  @override
  State<VideoSliderWidget> createState() => _VideoSliderWidgetState();
}

class _VideoSliderWidgetState extends State<VideoSliderWidget> {
  final Map<int, VideoPlayerController> _videoControllers = {};
  final bool _autoPlay = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  Future<void> _initializeVideo(int index, String url) async {
    if (_videoControllers.containsKey(index)) return;
    try {
      final controller = VideoPlayerController.network(url);
      _videoControllers[index] = controller;
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(0);
      if (mounted) setState(() {});
      if (index == _currentIndex) controller.play();
    } catch (e) {
      debugPrint('Error initializing video $url: $e');
    }
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    // Pause all
    for (final c in _videoControllers.values) {
      if (c.value.isInitialized) c.pause();
    }
    // Play current if exists
    final current = _videoControllers[index];
    if (current != null && current.value.isInitialized) {
      current.play();
    }
    setState(() => _currentIndex = index);
    widget.onPageChanged?.call(index);
  }

  @override
  void dispose() {
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sliders.isEmpty) {
      return Container(color: Colors.black);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent, // ensures gestures pass through
      child: CarouselSlider.builder(
        itemCount: widget.sliders.length,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1,
          enlargeCenterPage: false,
          enableInfiniteScroll: widget.sliders.length > 1,
          autoPlay: _autoPlay && widget.sliders.length > 1,
          autoPlayInterval: const Duration(seconds: 7),
          onPageChanged: _onPageChanged,
        ),
        itemBuilder: (context, index, realIndex) {
          final slider = widget.sliders[index];
          final isVideo = slider.isVideo;
          final url = slider.img;

          if (isVideo) {
            _initializeVideo(index, url);
            final controller = _videoControllers[index];
            if (controller == null || !controller.value.isInitialized) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            return SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            );
          } else {
            return Image.network(
              url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child:
                    Icon(Icons.broken_image, color: Colors.white54, size: 60),
              ),
            );
          }
        },
      ),
    );
  }
}
