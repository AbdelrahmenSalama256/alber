import 'dart:async';

import 'package:bloc/bloc.dart';

import 'quick_donation_state.dart';

class QuickDonationCubit extends Cubit<QuickDonationState> {
  QuickDonationCubit() : super(QuickDonationLoading());

  Future<void> init() async {
    emit(QuickDonationLoading());
    await Future.delayed(const Duration(seconds: 2)); // simulate network delay

    final donationItems = [
      {
        'title': 'دعم ذوي الاحتياجات الخاصة',
        'imageAsset': 'assets/images/png/cure-main.png',
        'raised': 5000.0,
        'goal': 10000.0,
        'amount': 100.0,
        'qty': 1,
      },
      {
        'title': 'كفالة يتيم',
        'imageAsset': 'assets/images/png/cure-main.png',
        'raised': 7500.0,
        'goal': 15000.0,
        'amount': 150.0,
        'qty': 1,
      },
      {
        'title': 'مشاريع السقيا',
        'imageAsset': 'assets/images/donation3.jpg',
        'raised': 3000.0,
        'goal': 8000.0,
        'amount': 80.0,
        'qty': 1,
      },
      {
        'title': 'صدقة جارية',
        'imageAsset': 'assets/images/png/cure-main.png',
        'raised': 12000.0,
        'goal': 20000.0,
        'amount': 200.0,
        'qty': 1,
      },
    ];

    emit(QuickDonationLoaded(donationItems: donationItems));
  }
}
