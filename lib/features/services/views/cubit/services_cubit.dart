import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';

import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final HomeRepo homeRepo;
  bool _isFetching = false;

  ServicesCubit(this.homeRepo) : super(ServicesInitial());

  Future<void> fetchServices({int page = 1}) async {
    if (_isFetching) return;
    _isFetching = true;
    emit(ServicesLoading());

    try {
      final result = await homeRepo.fetchServicesList(page: page);
      await result.fold(
        (error) async => emit(ServicesError(error)),
        (services) async {
          emit(
            ServicesLoaded(
              services: services,
              extractedColors: const {},
              isColorLoading: true,
            ),
          );

          final colors = await _extractColors(services);
          final currentState = state;
          if (currentState is ServicesLoaded) {
            emit(
              currentState.copyWith(
                extractedColors: colors,
                isColorLoading: false,
              ),
            );
          }
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<Map<String, Color>> _extractColors(
      List<ServiceModel> services) async {
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
    if (imagePath.isEmpty || imagePath.toLowerCase().endsWith('.svg')) {
      return Colors.grey.shade400;
    }

    final ImageProvider provider = imagePath.startsWith('http')
        ? NetworkImage(imagePath)
        : AssetImage(imagePath);

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        provider,
        maximumColorCount: 8,
      );
      return palette.dominantColor?.color ?? Colors.grey.shade400;
    } catch (_) {
      return Colors.grey.shade400;
    }
  }
}
