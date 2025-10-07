abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Map<String, dynamic>> items;
  final int total;
  final bool showPayPanel;

  CartLoaded({
    required this.items,
    required this.total,
    required this.showPayPanel,
  });

  CartLoaded copyWith({
    List<Map<String, dynamic>>? items,
    int? total,
    bool? showPayPanel,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      total: total ?? this.total,
      showPayPanel: showPayPanel ?? this.showPayPanel,
    );
  }
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
