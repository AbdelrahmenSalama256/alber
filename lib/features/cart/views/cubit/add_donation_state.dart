abstract class AddDonationState {}

class AddDonationLoading extends AddDonationState {}

class AddDonationLoaded extends AddDonationState {
  final bool showNextButton;
  final String periodicity;
  final int amount;
  final int month;
  final int day;

  AddDonationLoaded({
    required this.showNextButton,
    required this.periodicity,
    required this.amount,
    required this.month,
    required this.day,
  });

  AddDonationLoaded copyWith({
    bool? showNextButton,
    String? periodicity,
    int? amount,
    int? month,
    int? day,
  }) {
    return AddDonationLoaded(
      showNextButton: showNextButton ?? this.showNextButton,
      periodicity: periodicity ?? this.periodicity,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      day: day ?? this.day,
    );
  }
}
