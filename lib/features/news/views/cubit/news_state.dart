abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Map<String, String>> items;
  final int currentPage;
  final bool hasMore;

  NewsLoaded({
    required this.items,
    required this.currentPage,
    required this.hasMore,
  });

  NewsLoaded copyWith({
    List<Map<String, String>>? items,
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
