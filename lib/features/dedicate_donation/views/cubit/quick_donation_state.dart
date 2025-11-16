abstract class QuickDonationState {
  const QuickDonationState();
}

class QuickDonationLoading extends QuickDonationState {}

class QuickDonationLoaded extends QuickDonationState {
  final List<QuickDonationItem> donationItems;
  const QuickDonationLoaded({required this.donationItems});
}

class QuickDonationItem {
  final String id;
  final String title;
  final String imageAsset;
  final double raised;
  final double goal;
  final double minAmount;
  final int minQty;
  final double selectedAmount;
  final int selectedQty;

  const QuickDonationItem({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.raised,
    required this.goal,
    required this.minAmount,
    required this.minQty,
    required this.selectedAmount,
    required this.selectedQty,
  });

  QuickDonationItem copyWith({
    double? selectedAmount,
    int? selectedQty,
  }) {
    return QuickDonationItem(
      id: id,
      title: title,
      imageAsset: imageAsset,
      raised: raised,
      goal: goal,
      minAmount: minAmount,
      minQty: minQty,
      selectedAmount: selectedAmount ?? this.selectedAmount,
      selectedQty: selectedQty ?? this.selectedQty,
    );
  }
}
