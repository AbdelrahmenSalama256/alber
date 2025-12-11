abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String aboutText;
  final String privacyText;
  final String termsText;
  final List<Map<String, String>> donationHistory;
  final List<Map<String, String>> locations;
  final String totalAmount;
  final String totalCount;

  ProfileLoaded({
    required this.aboutText,
    required this.privacyText,
    required this.termsText,
    required this.donationHistory,
    required this.locations,
    required this.totalAmount,
    required this.totalCount,
  });

  ProfileLoaded copyWith({
    String? aboutText,
    String? privacyText,
    String? termsText,
    List<Map<String, String>>? donationHistory,
    List<Map<String, String>>? locations,
    String? totalAmount,
    String? totalCount,
  }) {
    return ProfileLoaded(
      aboutText: aboutText ?? this.aboutText,
      privacyText: privacyText ?? this.privacyText,
      termsText: termsText ?? this.termsText,
      donationHistory: donationHistory ?? this.donationHistory,
      locations: locations ?? this.locations,
      totalAmount: totalAmount ?? this.totalAmount,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
