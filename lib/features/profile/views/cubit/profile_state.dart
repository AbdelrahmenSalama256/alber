import 'package:image_picker/image_picker.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  static const _pendingAvatarSentinel = Object();
  static const _pendingEmailSentinel = Object();
  static const _pendingPhoneSentinel = Object();

  final String aboutText;
  final String privacyText;
  final String termsText;
  final List<Map<String, String>> donationHistory;
  final List<Map<String, String>> locations;
  final String totalAmount;
  final String totalCount;
  final UserModel profile;
  final bool isEditingProfile;
  final bool isUpdatingProfile;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final XFile? pendingAvatar;
  final String? pendingEmail;
  final String? pendingPhone;

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
    this.isUpdatingProfile = false,
    this.isEmailVerified = true,
    this.isPhoneVerified = true,
    this.pendingAvatar,
    this.pendingEmail,
    this.pendingPhone,
  });

  ProfileLoaded copyWith({
    String? aboutText,
    String? privacyText,
    String? termsText,
    List<Map<String, String>>? donationHistory,
    List<Map<String, String>>? locations,
    String? totalAmount,
    String? totalCount,
    UserModel? profile,
    bool? isEditingProfile,
    bool? isUpdatingProfile,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    Object? pendingAvatar = _pendingAvatarSentinel,
    Object? pendingEmail = _pendingEmailSentinel,
    Object? pendingPhone = _pendingPhoneSentinel,
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
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      pendingAvatar: identical(pendingAvatar, _pendingAvatarSentinel)
          ? this.pendingAvatar
          : pendingAvatar as XFile?,
      pendingEmail: identical(pendingEmail, _pendingEmailSentinel)
          ? this.pendingEmail
          : pendingEmail as String?,
      pendingPhone: identical(pendingPhone, _pendingPhoneSentinel)
          ? this.pendingPhone
          : pendingPhone as String?,
    );
  }
}

class ProfileLogoutLoading extends ProfileState {}

class ProfileLogoutSuccess extends ProfileState {
  final String message;
  ProfileLogoutSuccess(this.message);
}

class ProfileLogoutError extends ProfileState {
  final String message;
  ProfileLogoutError(this.message);
}
