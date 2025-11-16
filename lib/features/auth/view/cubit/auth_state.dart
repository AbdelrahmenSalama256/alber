sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthPasswordVisibilityChanged extends AuthState {
  final bool isObscure;
  final String fieldType;
  AuthPasswordVisibilityChanged({required this.isObscure, required this.fieldType});
}

class AuthCreateAccountSuccess extends AuthState {
  final String message;
  final String emailForVerification;
  AuthCreateAccountSuccess({required this.message, required this.emailForVerification});
}

class AuthOtpVerificationLoading extends AuthState {}

class AuthOtpVerificationSuccess extends AuthState {
  final String message;
  AuthOtpVerificationSuccess({required this.message});
}

class AuthLoginSuccess extends AuthState {
  final String message;
  AuthLoginSuccess({required this.message});
}

class AuthForgotPasswordOtpSent extends AuthState {
  final String message;
  final String emailOrPhone;
  AuthForgotPasswordOtpSent({required this.message, required this.emailOrPhone});
}

class AuthResetPasswordSuccess extends AuthState {
  final String message;
  AuthResetPasswordSuccess({required this.message});
}

class AuthAvatarChanged extends AuthState {
  final String imagePath;
  AuthAvatarChanged(this.imagePath);
}
