import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';

class ErrorMessageHandler {
  static String processErrorMessage(
    BuildContext context,
    String errorMessage, {
    int maxLength = 100,
  }) {
    // Check if the error message is too long or contains HTML
    final displayMessage = errorMessage.length > maxLength ||
            errorMessage.contains('<html') ||
            errorMessage.contains('<!DOCTYPE')
        ? 'unexpected_error'.tr(context)
        : errorMessage.tr(context);

    return displayMessage;
  }

  static void showErrorToast(
    BuildContext context,
    String errorMessage, {
    int maxLength = 100,
    Duration duration = const Duration(seconds: 3),
  }) {
    final displayMessage =
        processErrorMessage(context, errorMessage, maxLength: maxLength);

    showToast(
      context,
      message: displayMessage,
      state: ToastStates.error,
      duration: duration,
    );
  }
}
