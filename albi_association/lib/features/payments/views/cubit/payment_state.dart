abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentOrderCreated extends PaymentState {
  final String orderId;

  PaymentOrderCreated({required this.orderId});
}

class PaymentSuccess extends PaymentState {
  final String orderId;
  final String? rrn;
  final String message;

  PaymentSuccess({
    required this.orderId,
    this.rrn,
    required this.message,
  });
}

class PaymentFailed extends PaymentState {
  final String error;
  final String? orderId;

  PaymentFailed({required this.error, this.orderId});
}

class PaymentError extends PaymentState {
  final String error;

  PaymentError(this.error);
}
