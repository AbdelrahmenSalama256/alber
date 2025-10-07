import 'dart:async';

import 'package:bloc/bloc.dart';

import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  Future<void> init() async {
    emit(NewsLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      final firstPage = await _fetchPage(1);
      emit(NewsLoaded(items: firstPage, currentPage: 1, hasMore: true));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final s = state;
    if (s is! NewsLoaded || !s.hasMore) return;
    emit(NewsLoading());
    await Future.delayed(const Duration(seconds: 1));
    final nextPage = s.currentPage + 1;
    final data = await _fetchPage(nextPage);
    final merged = [...s.items, ...data];
    emit(NewsLoaded(
        items: merged, currentPage: nextPage, hasMore: nextPage < 3));
  }

  Future<List<Map<String, String>>> _fetchPage(int page) async {
    return List.generate(12, (i) {
      return {
        "imageAsset": "assets/images/png/news.png",
        "title": "جمعية البر بجدة",
        "subtitle": "شهادة “تكامل”",
      };
    });
  }
}
