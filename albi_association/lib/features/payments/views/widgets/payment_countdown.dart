// features/payment/views/widgets/payment_countdown.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentCountdown extends StatefulWidget {
  final int duration;
  final VoidCallback onComplete;
  final double size;

  const PaymentCountdown({
    super.key,
    required this.duration,
    required this.onComplete,
    required this.size,
  });

  @override
  State<PaymentCountdown> createState() => _PaymentCountdownState();
}

class _PaymentCountdownState extends State<PaymentCountdown> {
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _remainingSeconds--;
        });

        if (_remainingSeconds > 0) {
          _startTimer();
        } else {
          widget.onComplete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xffF1A725), width: 2),
      ),
      child: Center(
        child: Text(
          '$_remainingSeconds',
          style: TextStyle(
            color: Color(0xffF1A725),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
