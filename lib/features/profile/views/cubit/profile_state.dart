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
  final ProfileUser profile;
  final bool isEditingProfile;

  ProfileLoaded({
    required this.aboutText,
    required this.privacyText,
    required this.termsText,
    required this.donationHistory,
    required this.locations,
    required this.totalAmount,
    required this.totalCount,
    required this.profile,
    this.isEditingProfile = false,
  });

  ProfileLoaded copyWith({
    String? aboutText,
    String? privacyText,
    String? termsText,
    List<Map<String, String>>? donationHistory,
    List<Map<String, String>>? locations,
    String? totalAmount,
    String? totalCount,
    ProfileUser? profile,
    bool? isEditingProfile,
  }) {
    return ProfileLoaded(
      aboutText: aboutText ?? this.aboutText,
      privacyText: privacyText ?? this.privacyText,
      termsText: termsText ?? this.termsText,
      donationHistory: donationHistory ?? this.donationHistory,
      locations: locations ?? this.locations,
      totalAmount: totalAmount ?? this.totalAmount,
      totalCount: totalCount ?? this.totalCount,
      profile: profile ?? this.profile,
      isEditingProfile: isEditingProfile ?? this.isEditingProfile,
    );
  }
}

class ProfileUser {
  final String name;
  final String memberId;
  final String phone;
  final String email;
  final String? avatarPath;

  const ProfileUser({
    required this.name,
    required this.memberId,
    required this.phone,
    required this.email,
    this.avatarPath,
  });

  ProfileUser copyWith({
    String? name,
    String? memberId,
    String? phone,
    String? email,
    String? avatarPath,
  }) {
    return ProfileUser(
      name: name ?? this.name,
      memberId: memberId ?? this.memberId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
