import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/news/data/repo/news_repo.dart';

import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  Future<void> init() async {
    emit(NewsLoading());
    try {
      currentPage = 1;
      isLoadingMore = false;
      final repo = sl<NewsRepo>();
      final res = await repo.fetchPage(1);
      res.fold(
        (err) => emit(NewsError(err)),
        (page) {
          currentPage = page.meta.currentPage;
          hasMore = page.meta.currentPage < page.meta.lastPage;
          emit(NewsLoaded(
              items: page.items,
              currentPage: currentPage,
              hasMore: hasMore));
        },
      );
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final s = state;
    if (s is! NewsLoaded || !hasMore || isLoadingMore) return;
    isLoadingMore = true;
    final nextPage = currentPage + 1;
    final repo = sl<NewsRepo>();
    final res = await repo.fetchPage(nextPage);
    res.fold(
      (err) {
        isLoadingMore = false;
        emit(NewsError(err));
      },
      (page) {
        currentPage = page.meta.currentPage;
        hasMore = currentPage < page.meta.lastPage;
        final merged = [...s.items, ...page.items];
        emit(NewsLoaded(items: merged, currentPage: currentPage, hasMore: hasMore));
        isLoadingMore = false;
      },
    );
  }

  Future<void> refresh() async {
    await init();
  }
}
