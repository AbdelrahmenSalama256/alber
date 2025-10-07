import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'add_donation_state.dart';

class AddDonationCubit extends Cubit<AddDonationState> {
  final TextEditingController projectC = TextEditingController();
  final TextEditingController startDateC = TextEditingController();
  final TextEditingController endDateC = TextEditingController();
  final TextEditingController timeC = TextEditingController();

  AddDonationCubit() : super(AddDonationLoading());

  Future<void> init() async {
    emit(AddDonationLoaded(
        showNextButton: false,
        periodicity: 'شهري',
        amount: 200,
        month: 1,
        day: 1));
    await Future.delayed(const Duration(milliseconds: 1800));
    final s = state;
    if (s is AddDonationLoaded) emit(s.copyWith(showNextButton: true));
  }

  void setProject(String v) => projectC.text = v;
  void setStartDate(String v) => startDateC.text = v;
  void setEndDate(String v) => endDateC.text = v;
  void setTime(String v) => timeC.text = v;

  void setAmount(int v) {
    final s = state;
    if (s is AddDonationLoaded) emit(s.copyWith(amount: v));
  }

  void setMonth(int v) {
    final s = state;
    if (s is AddDonationLoaded) emit(s.copyWith(month: v));
  }

  void setDay(int v) {
    final s = state;
    if (s is AddDonationLoaded) emit(s.copyWith(day: v));
  }

  void setPeriodicity(String v) {
    final s = state;
    if (s is AddDonationLoaded) emit(s.copyWith(periodicity: v));
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
