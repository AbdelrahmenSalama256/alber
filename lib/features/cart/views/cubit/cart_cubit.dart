import 'package:bloc/bloc.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartLoading());

  Future<void> load() async {
    emit(CartLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    final items = await _fetchCartItems();
    final total = items.fold<int>(
        0, (p, e) => p + (e['amount'] as int) * (e['qty'] as int));
    emit(CartLoaded(items: items, total: total, showPayPanel: false));
    await Future.delayed(const Duration(milliseconds: 1800));
    final s = state;
    if (s is CartLoaded) emit(s.copyWith(showPayPanel: true));
  }

  Future<List<Map<String, dynamic>>> _fetchCartItems() async {
    return [
      {
        'imageAsset': "assets/images/png/news.png",
        'tagText': "الزكاة والصدقة",
        'amountText': "3333",
        'bottomTitle': "إطعام مسكين",
        'qty': 1,
        'amount': 1500,
      }
    ];
  }

  void updateQty(int index, int qty) {
    final s = state;
    if (s is CartLoaded) {
      final items = List<Map<String, dynamic>>.from(s.items);
      items[index]['qty'] = qty;
      final total = items.fold<int>(
          0, (p, e) => p + (e['amount'] as int) * (e['qty'] as int));
      emit(s.copyWith(items: items, total: total));
    }
  }
}
