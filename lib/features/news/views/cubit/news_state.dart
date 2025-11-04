import 'package:qafeel/features/news/data/models/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> items;
  final int currentPage;
  final bool hasMore;

  NewsLoaded({
    required this.items,
    required this.currentPage,
    required this.hasMore,
  });

  NewsLoaded copyWith({
    List<NewsModel>? items,
    int? currentPage,
    bool? hasMore,
  }) {
    return NewsLoaded(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
