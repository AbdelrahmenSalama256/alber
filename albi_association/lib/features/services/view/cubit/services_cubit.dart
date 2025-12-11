import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/services/data/repo/services_repo.dart';
import 'package:qafeel/features/services/data/models/service_models.dart';

import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesInitial());

  Future<void> load({int? branchId}) async {
    emit(ServicesLoading());
    final id = branchId ??
        int.tryParse(sl<CacheHelper>()
                .getDataString(key: AppConstants.selectedBranchId) ??
            '');
    if (id == null) {
      emit(ServicesError('No branch selected'));
      return;
    }
    final repo = sl<ServicesRepo>();
    final res = await repo.fetchSections(branchId: id);
    res.fold(
      (l) => emit(ServicesError(l)),
      (sections) async {
        final items = sections.expand((s) => s.services).toList();
        final colors = await _extractColors(sections);
        emit(ServicesLoaded(
          sections: sections,
          items: items,
          extractedColors: colors,
        ));
      },
    );
  }

  Future<Map<String, Color>> _extractColors(
      List<ServiceSection> sections) async {
    final Map<String, Color> colors = {};

    for (final section in sections) {
      final imageUrl = section.image?.trim().isNotEmpty == true
          ? section.image!.trim()
          : (section.cover ?? '').trim();

      if (imageUrl.isEmpty) continue;
      // Skip SVGs; palette_generator works with raster images
      if (imageUrl.toLowerCase().endsWith('.svg')) continue;

      try {
        final palette = await PaletteGenerator.fromImageProvider(
          NetworkImage(imageUrl),
          maximumColorCount: 10,
        );
        final color = palette.dominantColor?.color ?? Colors.grey;
        colors[imageUrl] = color;
      } catch (_) {
        colors[imageUrl] = Colors.grey;
      }
    }

    return colors;
  }
}
