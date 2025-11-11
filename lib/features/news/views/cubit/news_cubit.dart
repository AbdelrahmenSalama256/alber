import 'dart:async';

import 'package:qafeel/core/cubit/app_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/news/data/repo/news_repo.dart';

import 'news_state.dart';

class NewsCubit extends AppCubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  Future<void> init() async {
    emitSafe(NewsLoading());
    try {
      currentPage = 1;
      isLoadingMore = false;
      final repo = sl<NewsRepo>();
      final res = await repo.fetchPage(1);
      res.fold(
        (err) => emitSafe(NewsError(err)),
        (page) {
          currentPage = page.meta.currentPage;
          hasMore = page.meta.currentPage < page.meta.lastPage;
          emitSafe(NewsLoaded(
              items: page.items, currentPage: currentPage, hasMore: hasMore));
        },
      );
    } catch (e) {
      emitSafe(NewsError(e.toString()));
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
        emitSafe(NewsError(err));
      },
      (page) {
        currentPage = page.meta.currentPage;
        hasMore = currentPage < page.meta.lastPage;
        final merged = [...s.items, ...page.items];
        emitSafe(NewsLoaded(
            items: merged, currentPage: currentPage, hasMore: hasMore));
        isLoadingMore = false;
      },
    );
  }

  Future<void> refresh() async {
    await init();
  }
}
