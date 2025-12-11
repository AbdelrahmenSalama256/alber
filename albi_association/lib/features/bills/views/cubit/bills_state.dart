class BillItem {
  final String tagText;
  final String code;
  final String dateText;
  final String timeText;
  final String amountText;
  final bool isBill;
  final bool isPayed;
  final String? paymentType;
  final String? serviceNum;

  const BillItem({
    required this.tagText,
    required this.code,
    required this.dateText,
    required this.timeText,
    required this.amountText,
    required this.isBill,
    required this.isPayed,
    this.paymentType,
    this.serviceNum,
  });
}

abstract class BillsState {}

class BillsInitial extends BillsState {}

class BillsLoading extends BillsState {}

class BillsLoaded extends BillsState {
  final List<BillItem> bills;
  BillsLoaded(this.bills);
}

class BillsError extends BillsState {
  final String message;
  BillsError(this.message);
}
