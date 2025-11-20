import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';

import 'home_state.dart';

class HomeCubit extends AppCubit<HomeState> {
  static const Duration _minSkeletonDuration = Duration(milliseconds: 400);
  final HomeRepo homeRepo = sl<HomeRepo>();
  bool _isFetching = false;

  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData({bool forceRefresh = false}) async {
    if (_isFetching) return;
    if (state is HomeLoaded && !forceRefresh) return;
    _isFetching = true;
    emitSafe(HomeLoading());
    final startedAt = DateTime.now();

    try {
      const homeServicesLimit = 6;
      final res = await homeRepo.fetchHome(limit: homeServicesLimit);

      await res.fold<Future<void>>(
        (error) async {
          await _ensureMinimumSkeletonDuration(startedAt);
          emitSafe(HomeError(error));
        },
        (data) async {
          final colorsFuture = _extractColors(data.services);
          await _ensureMinimumSkeletonDuration(startedAt);
          emitSafe(
            HomeLoaded(
              sliderImages: data.sliderImages,
              services: data.services,
              donations: data.donations,
              donationServices: data.donationServices,
              news: data.news,
              partners: data.partners,
              extractedColors: const {},
              currentSliderIndex: 0,
            ),
          );

          final extractedColors = await colorsFuture;
          final latestState = state;
          if (latestState is HomeLoaded) {
            emitSafe(
              latestState.copyWith(extractedColors: extractedColors),
            );
          }
        },
      );
    } catch (e) {
      await _ensureMinimumSkeletonDuration(startedAt);
      emitSafe(HomeError('Failed to load data: $e'));
    } finally {
      _isFetching = false;
    }
  }

  void updateSliderIndex(int index) {
    final state = this.state;
    if (state is HomeLoaded) {
      emitSafe(state.copyWith(currentSliderIndex: index));
    }
  }

  Future<Map<String, Color>> _extractColors(
    List<ServiceModel> services,
  ) async {
    final uniqueImageFutures = <String, Future<Color>>{};

    for (final service in services) {
      final key = service.image.trim();
      if (key.isEmpty) continue;
      uniqueImageFutures.putIfAbsent(key, () => _generateColor(key));
    }

    final resolvedColors = <String, Color>{};
    for (final entry in uniqueImageFutures.entries) {
      resolvedColors[entry.key] = await entry.value;
    }

    final serviceColors = <String, Color>{};
    for (final service in services) {
      final key = service.image.trim();
      final color = resolvedColors[key] ?? Colors.grey.shade400;
      serviceColors[service.id] = color;
      if (key.isNotEmpty) {
        serviceColors[key] = color;
      }
    }
    return serviceColors;
  }

  Future<Color> _generateColor(String imagePath) async {
    final normalizedPath = imagePath.trim();
    if (normalizedPath.isEmpty || normalizedPath.toLowerCase().endsWith('.svg')) {
      return Colors.grey.shade400;
    }

    final ImageProvider provider = normalizedPath.startsWith('http')
        ? NetworkImage(normalizedPath)
        : AssetImage(normalizedPath);

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        provider,
        maximumColorCount: 8,
      );
      final dominant = palette.dominantColor?.color;
      if (dominant == null) return Colors.grey.shade400;
      return dominant;
    } catch (_) {
      return Colors.grey.shade400;
    }
  }

  Future<void> _ensureMinimumSkeletonDuration(DateTime startedAt) async {
    final elapsed = DateTime.now().difference(startedAt);
    if (elapsed < _minSkeletonDuration) {
      await Future.delayed(_minSkeletonDuration - elapsed);
    }
  }
}
