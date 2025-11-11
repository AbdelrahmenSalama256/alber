import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';

import 'home_state.dart';

class HomeCubit extends AppCubit<HomeState> {
  final HomeRepo homeRepo = sl<HomeRepo>();
  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    emitSafe(HomeLoading());

    try {
      final res = await homeRepo.fetchHome();

      res.fold(
        (error) => emitSafe(HomeError(error)),
        (data) async {
          final extractedColors = await _extractColors(data.services);
          emitSafe(
            HomeLoaded(
              sliderImages: data.sliderImages,
              services: data.services,
              donations: data.donations,
              donationServices: data.donationServices,
              news: data.news,
              partners: data.partners,
              extractedColors: extractedColors,
              currentSliderIndex: 0,
            ),
          );
        },
      );
    } catch (e) {
      emitSafe(HomeError('Failed to load data: $e'));
    }
  }

  void updateSliderIndex(int index) {
    final state = this.state;
    if (state is HomeLoaded) {
      emitSafe(state.copyWith(currentSliderIndex: index));
    }
  }

  Future<Map<String, Color>> _extractColors(List<ServiceModel> services) async {
    final Map<String, Color> colors = {};

    for (var service in services) {
      final imagePath = service.image;
      try {
        final palette = await PaletteGenerator.fromImageProvider(
          AssetImage(imagePath),
          maximumColorCount: 10,
        );
        final color = palette.dominantColor?.color ?? Colors.grey;
        colors[imagePath] = color;
      } catch (e) {
        colors[imagePath] = Colors.grey;
      }
    }

    return colors;
  }
}
