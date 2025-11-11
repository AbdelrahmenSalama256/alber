import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';

import 'search_state.dart';

class SearchCubit extends AppCubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final TextEditingController searchC = TextEditingController();
  Timer? _debounce;

  Future<void> init() async {
    emitSafe(SearchLoading());
    await Future.delayed(const Duration(seconds: 2));
    emitSafe(SearchLoaded(results: _sampleData(), query: ""));
  }

  void onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce =
        Timer(const Duration(milliseconds: 400), () => performSearch(q));
  }

  Future<void> performSearch(String q) async {
    final base = _sampleData();

    // 🧠 No loading flicker while typing — only filter and emit
    await Future.delayed(const Duration(milliseconds: 400));
    final filtered = q.isEmpty
        ? base
        : base
            .where((e) => e['title']!.toLowerCase().contains(q.toLowerCase()))
            .toList();
    emitSafe(SearchLoaded(results: filtered, query: q));
  }

  List<Map<String, String>> _sampleData() {
    return [
      {
        "image": "assets/images/png/news.png",
        "title": "جمعية البر بجدة",
        "subtitle": "خبر ١"
      },
      {
        "image": "assets/images/png/news.png",
        "title": "الزكاة والصدقة",
        "subtitle": "خبر ٢"
      },
      {
        "image": "assets/images/png/news.png",
        "title": "مشاريع السقيا",
        "subtitle": "خبر ٣"
      },
      {
        "image": "assets/images/png/news.png",
        "title": "كفالة يتيم",
        "subtitle": "خبر ٤"
      },
      {
        "image": "assets/images/png/news.png",
        "title": "صدقة جارية",
        "subtitle": "خبر ٥"
      },
      {
        "image": "assets/images/png/news.png",
        "title": "حملات اغاثة",
        "subtitle": "خبر ٦"
      },
    ];
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    searchC.dispose();
    return super.close();
  }
}
