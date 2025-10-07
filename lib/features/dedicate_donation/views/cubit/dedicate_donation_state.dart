import 'package:flutter/material.dart';

abstract class DedicateDonationState {}

class DedicateDonationLoading extends DedicateDonationState {}

class DedicateDonationLoaded extends DedicateDonationState {
  final List<Map<String, String>> donationTypes;
  final int selectedTypeIndex;
  final int selectedFieldIndex;
  final bool showNextButton;
  final TextEditingController recipientNameC;
  final TextEditingController recipientPhoneC;
  final TextEditingController customAmountC;
  final bool showAmountToRecipient;
  final bool sendCardToMyPhone;

  DedicateDonationLoaded({
    required this.donationTypes,
    required this.selectedTypeIndex,
    required this.selectedFieldIndex,
    required this.showNextButton,
    required this.recipientNameC,
    required this.recipientPhoneC,
    required this.customAmountC,
    required this.showAmountToRecipient,
    required this.sendCardToMyPhone,
  });

  DedicateDonationLoaded copyWith({
    List<Map<String, String>>? donationTypes,
    int? selectedTypeIndex,
    int? selectedFieldIndex,
    bool? showNextButton,
    TextEditingController? recipientNameC,
    TextEditingController? recipientPhoneC,
    TextEditingController? customAmountC,
    bool? showAmountToRecipient,
    bool? sendCardToMyPhone,
  }) {
    return DedicateDonationLoaded(
      donationTypes: donationTypes ?? this.donationTypes,
      selectedTypeIndex: selectedTypeIndex ?? this.selectedTypeIndex,
      selectedFieldIndex: selectedFieldIndex ?? this.selectedFieldIndex,
      showNextButton: showNextButton ?? this.showNextButton,
      recipientNameC: recipientNameC ?? this.recipientNameC,
      recipientPhoneC: recipientPhoneC ?? this.recipientPhoneC,
      customAmountC: customAmountC ?? this.customAmountC,
      showAmountToRecipient:
          showAmountToRecipient ?? this.showAmountToRecipient,
      sendCardToMyPhone: sendCardToMyPhone ?? this.sendCardToMyPhone,
    );
  }
}
