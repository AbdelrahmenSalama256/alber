import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final TextEditingController cardNumberC = TextEditingController();
  final TextEditingController cardNameC = TextEditingController();
  final TextEditingController expiryC = TextEditingController();
  final TextEditingController cvvC = TextEditingController();
  final TextEditingController pinC = TextEditingController();

  CheckoutCubit() : super(CheckoutLoading());

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 800));
    emit(CheckoutLoaded(
      totalAmount: 1000,
      savedCards: [
        CardItem(
          cardType: "Master Card",
          last4: "3356",
          expiry: "11/23",
          imagePath: "assets/images/png/master_card.png",
        ),
        CardItem(
          cardType: "mada",
          last4: "3356",
          expiry: "11/23",
          imagePath: "assets/images/png/mada.png",
        ),
      ],
      selectedCardIndex: null,
    ));
  }

  void setTotal(int v) {
    final s = state;
    if (s is CheckoutLoaded) emit(s.copyWith(totalAmount: v));
  }

  void selectCard(int? index) {
    final s = state;
    if (s is CheckoutLoaded) emit(s.copyWith(selectedCardIndex: index));
  }

  void addCardFromControllers() {
    final s = state;
    if (s is CheckoutLoaded) {
      final number = cardNumberC.text.trim();
      if (number.isEmpty) return;
      final last4 =
          number.length >= 4 ? number.substring(number.length - 4) : number;
      final item = CardItem(
        cardType:
            cardNameC.text.trim().isEmpty ? "Card" : cardNameC.text.trim(),
        last4: last4,
        expiry: expiryC.text.trim(),
        imagePath: "assets/images/png/master_card.png",
      );
      final list = List<CardItem>.from(s.savedCards)..add(item);
      emit(s.copyWith(savedCards: list));
      clearCardControllers();
    }
  }

  void clearCardControllers() {
    cardNumberC.clear();
    cardNameC.clear();
    expiryC.clear();
    cvvC.clear();
  }

  @override
  Future<void> close() {
    cardNumberC.dispose();
    cardNameC.dispose();
    expiryC.dispose();
    cvvC.dispose();
    pinC.dispose();
    return super.close();
  }
}
