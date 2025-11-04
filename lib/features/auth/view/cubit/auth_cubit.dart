import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/data/models/user_registration_model.dart';
import 'package:qafeel/features/auth/data/repo/login_repo.dart';
import 'package:qafeel/features/auth/data/repo/register_repo.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    usernameController = TextEditingController();
    createAccountEmailController = TextEditingController();
    createAccountPasswordController = TextEditingController();
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    forgotPasswordEmailController = TextEditingController();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  // Controllers (aligned with sample)
  late TextEditingController usernameController;
  late TextEditingController createAccountEmailController;
  late TextEditingController createAccountPasswordController;
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  late TextEditingController forgotPasswordEmailController;
  late TextEditingController otpController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  final formKey = GlobalKey<FormState>();

  // Keep backwards compatibility with existing screens
  TextEditingController get phoneController => loginEmailController;
  TextEditingController get nameController => usernameController;
  TextEditingController get emailController => createAccountEmailController;

  bool isCreateAccountPasswordObscure = true;
  bool isLoginPasswordObscure = true;
  bool isNewPasswordObscure = true;
  bool isConfirmNewPasswordObscure = true;

  void togglePasswordVisibility(String fieldType) {
    if (fieldType == 'createAccount') {
      isCreateAccountPasswordObscure = !isCreateAccountPasswordObscure;
    } else if (fieldType == 'login') {
      isLoginPasswordObscure = !isLoginPasswordObscure;
    } else if (fieldType == 'new') {
      isNewPasswordObscure = !isNewPasswordObscure;
    } else if (fieldType == 'confirm') {
      isConfirmNewPasswordObscure = !isConfirmNewPasswordObscure;
    }
    emit(AuthPasswordVisibilityChanged(
        isObscure: _getObscurityStatus(fieldType), fieldType: fieldType));
  }

  bool _getObscurityStatus(String fieldType) {
    if (fieldType == 'createAccount') return isCreateAccountPasswordObscure;
    if (fieldType == 'login') return isLoginPasswordObscure;
    if (fieldType == 'new') return isNewPasswordObscure;
    if (fieldType == 'confirm') return isConfirmNewPasswordObscure;
    return true;
  }

  // Screen API - matches existing screens
  Future<void> login() async {
    // Form validation (UI errors) + toast/error state
    if (!formKey.currentState!.validate()) {
      emit(AuthError('invalid_phone'));
      return;
    }
    final phone = loginEmailController.text.trim();
    if (!_isValidPhone(phone)) {
      emit(AuthError('invalid_phone'));
      return;
    }
    emit(AuthLoading());
    // In your real flow this should request OTP
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AuthSuccess());
  }

  Future<void> otpVerfication() async {
    if (!formKey.currentState!.validate()) {
      emit(AuthError('invalid_otp'));
      return;
    }
    final otp = otpController.text.trim();
    if (!_isValidOtp(otp)) {
      emit(AuthError('invalid_otp'));
      return;
    }
    emit(AuthOtpVerificationLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate calling login and storing user profile
    final loginRepo = sl<LoginRepo>();
    final res = await loginRepo.loginUser(
      username: loginEmailController.text.trim().isEmpty
          ? usernameController.text.trim()
          : loginEmailController.text.trim(),
      password: loginPasswordController.text.trim(),
    );
    res.fold(
      (err) => emit(AuthError(err)),
      (contactResponse) async {
        await _cacheSession(contactResponse);
        emit(AuthSuccess());
      },
    );
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      emit(AuthError('validation_error'));
      return;
    }
    // Extra guard validations
    final username = usernameController.text.trim();
    final email = createAccountEmailController.text.trim();
    final mobile = loginEmailController.text.trim();
    final pass = createAccountPasswordController.text.trim();
    final confirm = confirmNewPasswordController.text.trim();
    if (username.length < 2) {
      emit(AuthError('name_length'));
      return;
    }
    if (!_isValidEmail(email)) {
      emit(AuthError('invalid_email'));
      return;
    }
    if (!_isValidPhone(mobile)) {
      emit(AuthError('invalid_phone'));
      return;
    }
    if (pass.length < 8) {
      emit(AuthError('password_too_short'));
      return;
    }
    if (pass != confirm) {
      emit(AuthError('passwords_not_match'));
      return;
    }
    emit(AuthLoading());
    final repo = sl<RegisterRepo>();
    final user = UserRegistrationModel(
      username: usernameController.text.trim(),
      email: createAccountEmailController.text.trim(),
      password: createAccountPasswordController.text.trim().isEmpty
          ? '12345678'
          : createAccountPasswordController.text.trim(),
      passwordConfirmation:
          confirmNewPasswordController.text.trim().isEmpty
              ? '12345678'
              : confirmNewPasswordController.text.trim(),
      name: usernameController.text.trim(),
      mobile: loginEmailController.text.trim(),
    );
    final res = await repo.registerUser(user);
    res.fold(
      (err) => emit(AuthError(err)),
      (data) async {
        emit(AuthCreateAccountSuccess(
            message: data['message']?.toString() ?? 'Registration successful',
            emailForVerification: user.email));
      },
    );
  }

  Future<void> sendForgotPasswordCode() async {
    if (!formKey.currentState!.validate()) {
      emit(AuthError('validation_error'));
      return;
    }
    emit(AuthLoading());
    final repo = sl<LoginRepo>();
    final res = await repo.sendForgotPasswordCode(
      forgotPasswordEmailController.text.trim(),
    );
    res.fold(
      (err) => emit(AuthError(err)),
      (msg) => emit(AuthForgotPasswordOtpSent(
          message: msg, emailOrPhone: forgotPasswordEmailController.text)),
    );
  }

  Future<void> attemptResetPassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      emit(AuthError('validation_error'));
      return;
    }
    final newPass = newPasswordController.text.trim();
    final confirm = confirmNewPasswordController.text.trim();
    if (newPass.length < 8) {
      emit(AuthError('password_too_short'));
      return;
    }
    if (newPass != confirm) {
      emit(AuthError('passwords_not_match'));
      return;
    }
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    emit(AuthResetPasswordSuccess(message: 'auth_password_reset_success'));
  }

  Future<void> _cacheSession(ContactResponse contactResponse) async {
    final token = contactResponse.data.token;
    if (token != null && token.isNotEmpty) {
      await sl<CacheHelper>().setData(AppConstants.token, token);
      PrintUtil.success('Token cached: $token');
    }
    await sl<CacheHelper>().setData(
      AppConstants.userProfile,
      contactResponse.toJson().toString(),
    );
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    createAccountEmailController.dispose();
    createAccountPasswordController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    return super.close();
  }

  bool _isValidEmail(String v) {
    final re = RegExp(r'^[\w\.-]+@([\w\-]+\.)+[A-Za-z]{2,}$');
    return re.hasMatch(v);
  }

  bool _isValidPhone(String v) {
    final re = RegExp(r'^\+?[0-9]{10,15}$');
    return re.hasMatch(v);
  }

  bool _isValidOtp(String v) {
    final re = RegExp(r'^\d{4}$');
    return re.hasMatch(v);
  }
}
