import 'package:flutter/material.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';

import 'add_donation_state.dart';

class AddDonationCubit extends AppCubit<AddDonationState> {
  final TextEditingController projectC = TextEditingController();
  final TextEditingController startDateC = TextEditingController();
  final TextEditingController endDateC = TextEditingController();
  final TextEditingController timeC = TextEditingController();

  final int? initialAmount;
  final int? initialQty;

  AddDonationCubit({this.initialAmount, this.initialQty})
      : super(AddDonationLoading());

  Future<void> init() async {
    emitSafe(AddDonationLoaded(
      showNextButton: false,
      periodicity: 'once',
      amount: initialAmount ?? 200,
      month: 1,
      day: 1,
    ));
    await Future.delayed(const Duration(seconds: 2));
    final s = state;
    if (s is AddDonationLoaded) emitSafe(s.copyWith(showNextButton: true));
  }

  void setProject(String v) => projectC.text = v;
  void setStartDate(String v) => startDateC.text = v;
  void setEndDate(String v) => endDateC.text = v;
  void setTime(String v) => timeC.text = v;

  void setAmount(int v) {
    final s = state;
    if (s is AddDonationLoaded) emitSafe(s.copyWith(amount: v));
  }

  void setMonth(int v) {
    final s = state;
    if (s is AddDonationLoaded) emitSafe(s.copyWith(month: v));
  }

  void setDay(int v) {
    final s = state;
    if (s is AddDonationLoaded) emitSafe(s.copyWith(day: v));
  }

  void setPeriodicity(String v) {
    final s = state;
    if (s is AddDonationLoaded) emitSafe(s.copyWith(periodicity: v));
  }

  @override
  Future<void> close() {
    projectC.dispose();
    startDateC.dispose();
    endDateC.dispose();
    timeC.dispose();
    return super.close();
  }
}
