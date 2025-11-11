import 'package:flutter/material.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';

import 'dedicate_donation_state.dart';

class DedicateDonationCubit extends AppCubit<DedicateDonationState> {
  DedicateDonationCubit() : super(DedicateDonationLoading());

  final TextEditingController recipientNameC = TextEditingController();
  final TextEditingController recipientPhoneC = TextEditingController();
  final TextEditingController customAmountC = TextEditingController();

  Future<void> init() async {
    emitSafe(DedicateDonationLoading());
    await Future.delayed(const Duration(seconds: 2));
    final types = [
      {"title": "تبرع بالمال", "icon": "assets/images/svg/testdonation.svg"},
      {"title": "تبرع بالدم", "icon": "assets/images/svg/testdonation.svg"},
      {"title": "تبرع بالطعام", "icon": "assets/images/svg/testdonation.svg"},
      {"title": "تبرع بالملابس", "icon": "assets/images/svg/testdonation.svg"},
      {"title": "تبرع بالأدوية", "icon": "assets/images/svg/testdonation.svg"},
      {"title": "تبرع بالماء", "icon": "assets/images/svg/testdonation.svg"},
    ];
    emitSafe(DedicateDonationLoaded(
      donationTypes: types,
      selectedTypeIndex: -1,
      selectedFieldIndex: -1,
      showNextButton: false,
      recipientNameC: recipientNameC,
      recipientPhoneC: recipientPhoneC,
      customAmountC: customAmountC,
      showAmountToRecipient: false,
      sendCardToMyPhone: false,
    ));
    await Future.delayed(const Duration(seconds: 3));
    final s = state;
    if (s is DedicateDonationLoaded) {
      emitSafe(s.copyWith(showNextButton: true));
    }
  }

  void selectType(int i) {
    final s = state;
    if (s is DedicateDonationLoaded) emitSafe(s.copyWith(selectedTypeIndex: i));
  }

  void selectField(int i) {
    final s = state;
    if (s is DedicateDonationLoaded) {
      emitSafe(s.copyWith(selectedFieldIndex: i));
    }
  }

  void toggleShowAmount(bool v) {
    final s = state;
    if (s is DedicateDonationLoaded) {
      emitSafe(s.copyWith(showAmountToRecipient: v));
    }
  }

  void toggleSendToMyPhone(bool v) {
    final s = state;
    if (s is DedicateDonationLoaded) emitSafe(s.copyWith(sendCardToMyPhone: v));
  }

  @override
  Future<void> close() {
    recipientNameC.dispose();
    recipientPhoneC.dispose();
    customAmountC.dispose();
    return super.close();
  }
}
