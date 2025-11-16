import 'dart:async';

import 'package:qafeel/core/cubit/app_cubit.dart';

import 'quick_donation_state.dart';

class QuickDonationCubit extends AppCubit<QuickDonationState> {
  QuickDonationCubit() : super(QuickDonationLoading());

  Future<void> init() async {
    emitSafe(QuickDonationLoading());
    await Future.delayed(const Duration(seconds: 2));
    emitSafe(QuickDonationLoaded(donationItems: _buildDefaultItems()));
  }

  void updateSelection(String id, {double? amount, int? qty}) {
    final current = state;
    if (current is! QuickDonationLoaded) return;
    final updated = current.donationItems.map((item) {
      if (item.id != id) return item;
      return item.copyWith(
        selectedAmount: amount ?? item.selectedAmount,
        selectedQty: qty ?? item.selectedQty,
      );
    }).toList();
    emitSafe(QuickDonationLoaded(donationItems: updated));
  }

  List<QuickDonationItem> _buildDefaultItems() {
    return const [
      QuickDonationItem(
        id: 'quick_donation_0',
        title: 'General Relief Fund',
        imageAsset: 'assets/images/png/cure-main.png',
        raised: 5000.0,
        goal: 10000.0,
        minAmount: 100.0,
        minQty: 1,
        selectedAmount: 100.0,
        selectedQty: 1,
      ),
      QuickDonationItem(
        id: 'quick_donation_1',
        title: 'Education Support',
        imageAsset: 'assets/images/png/cure-main.png',
        raised: 7500.0,
        goal: 15000.0,
        minAmount: 150.0,
        minQty: 1,
        selectedAmount: 150.0,
        selectedQty: 1,
      ),
      QuickDonationItem(
        id: 'quick_donation_2',
        title: 'Medical Aid Campaign',
        imageAsset: 'assets/images/donation3.jpg',
        raised: 3000.0,
        goal: 8000.0,
        minAmount: 80.0,
        minQty: 1,
        selectedAmount: 80.0,
        selectedQty: 1,
      ),
      QuickDonationItem(
        id: 'quick_donation_3',
        title: 'Food Basket Program',
        imageAsset: 'assets/images/png/cure-main.png',
        raised: 12000.0,
        goal: 20000.0,
        minAmount: 200.0,
        minQty: 1,
        selectedAmount: 200.0,
        selectedQty: 1,
      ),
    ];
  }
}
