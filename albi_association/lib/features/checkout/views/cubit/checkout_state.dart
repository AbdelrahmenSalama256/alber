abstract class CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final int totalAmount;
  final List<CardItem> savedCards;
  final int? selectedCardIndex;

  CheckoutLoaded({
    required this.totalAmount,
    required this.savedCards,
    required this.selectedCardIndex,
  });

  CheckoutLoaded copyWith({
    int? totalAmount,
    List<CardItem>? savedCards,
    int? selectedCardIndex,
  }) {
    return CheckoutLoaded(
      totalAmount: totalAmount ?? this.totalAmount,
      savedCards: savedCards ?? this.savedCards,
      selectedCardIndex: selectedCardIndex,
    );
  }
}

class CardItem {
  final String cardType;
  final String last4;
  final String expiry;
  final String imagePath;

  CardItem({
    required this.cardType,
    required this.last4,
    required this.expiry,
    required this.imagePath,
  });
}
