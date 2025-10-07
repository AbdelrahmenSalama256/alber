abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Map<String, String>> results;
  final String query;
  SearchLoaded({required this.results, required this.query});

  SearchLoaded copyWith({
    List<Map<String, String>>? results,
    String? query,
  }) {
    return SearchLoaded(
      results: results ?? this.results,
      query: query ?? this.query,
    );
  }
}
