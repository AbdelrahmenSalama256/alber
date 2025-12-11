import 'package:bloc/bloc.dart';

import 'bills_state.dart';

class BillsCubit extends Cubit<BillsState> {
  BillsCubit() : super(BillsInitial());

  Future<void> loadBills() async {
    emit(BillsLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      final data = <BillItem>[
        const BillItem(
          tagText: 'غير مدفوعة',
          code: 'BIR-060278',
          isBill: false,
          isPayed: false,
          dateText: '25 - 08 - 2025',
          timeText: '16:30:00',
          amountText: '1123.00',
        ),
        const BillItem(
          tagText: 'مدفوعة',
          code: 'BIR-060278',
          isBill: true,
          isPayed: true,
          paymentType: 'تحويل بنكي',
          serviceNum: '231',
          dateText: '25 - 08 - 2025',
          timeText: '16:30:00',
          amountText: '1123.00',
        ),
      ];

      emit(BillsLoaded(data));
    } catch (e) {
      emit(BillsError('Failed to load bills'));
    }
  }
}
