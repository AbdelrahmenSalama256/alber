// lib/features/profile/views/add_donation_cart/cubit/terms_state.dart
abstract class TermsState {}

class TermsLoading extends TermsState {}

class TermsLoaded extends TermsState {
  final bool showPayPanel;
  final String terms;
  TermsLoaded({required this.showPayPanel, required this.terms});

  TermsLoaded copyWith({bool? showPayPanel, String? terms}) => TermsLoaded(
      showPayPanel: showPayPanel ?? this.showPayPanel,
      terms: terms ?? this.terms);
}
