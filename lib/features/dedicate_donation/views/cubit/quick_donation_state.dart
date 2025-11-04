abstract class QuickDonationState {
  const QuickDonationState();
}

class QuickDonationLoading extends QuickDonationState {}

class QuickDonationLoaded extends QuickDonationState {
  final List<Map<String, dynamic>> donationItems;
  const QuickDonationLoaded({required this.donationItems});
}
