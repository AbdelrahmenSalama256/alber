import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/notification/local_notification_handler.dart';
import 'package:qafeel/features/auth/data/models/user_registration_model.dart';
import 'package:qafeel/features/auth/data/repo/login_repo.dart';
import 'package:qafeel/features/auth/data/repo/register_repo.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';

import 'auth_state.dart';

class AuthCubit extends AppCubit<AuthState> {
  final LoginRepo loginRepo;
  final RegisterRepo registerRepo;
  final CacheHelper cacheHelper;
  final GlobalCubit globalCubit;

  AuthCubit({
    required this.loginRepo,
    required this.registerRepo,
    required this.cacheHelper,
    required this.globalCubit,
  }) : super(AuthInitial()) {
    usernameController = TextEditingController();
    displayNameController = TextEditingController();
    createAccountEmailController = TextEditingController();
    createAccountPasswordController = TextEditingController();
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    forgotPasswordEmailController = TextEditingController();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  late TextEditingController usernameController;
  late TextEditingController displayNameController;
  late TextEditingController createAccountEmailController;
  late TextEditingController createAccountPasswordController;
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  late TextEditingController forgotPasswordEmailController;
  late TextEditingController otpController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  final formKey = GlobalKey<FormState>();
  XFile? profileImage;

  TextEditingController get phoneController => loginEmailController;
  TextEditingController get nameController => displayNameController;
  TextEditingController get emailController => createAccountEmailController;

  String? selectedGender;

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
    emitSafe(AuthPasswordVisibilityChanged(
        isObscure: _getObscurityStatus(fieldType), fieldType: fieldType));
  }

  void updateProfileImage(XFile image) {
    profileImage = image;
    emitSafe(AuthAvatarChanged(image.path));
  }

  void setGender(String? value) {
    selectedGender = value;
    if (value != null) {
      emitSafe(AuthGenderChanged(value));
    }
  }

  bool _getObscurityStatus(String fieldType) {
    if (fieldType == 'createAccount') return isCreateAccountPasswordObscure;
    if (fieldType == 'login') return isLoginPasswordObscure;
    if (fieldType == 'new') return isNewPasswordObscure;
    if (fieldType == 'confirm') return isConfirmNewPasswordObscure;
    return true;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final identifier = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();
    // if (identifier.isEmpty || !_isValidPhone(identifier)) {
    //   emitSafe(AuthError('invalid_phone'));
    //   return;
    // }
    if (password.isEmpty) {
      emitSafe(AuthError('password_required'));
      return;
    }
    emitSafe(AuthLoading());
    final res = await loginRepo.loginUser(
      identifier: identifier,
      password: password,
    );
    res.fold(
      (err) async {
        if (err == 'account_not_verified') {
          final otpSent = await requestVerificationCode(identifier: identifier);
          if (otpSent) {
            emitSafe(AuthVerificationRequired(identifier));
          }
        } else {
          emitSafe(AuthError(err));
        }
      },
      (contactResponse) async {
        await _cacheSession(contactResponse);
        emitSafe(AuthLoginSuccess(message: 'login_success'));
      },
    );
  }

  Future<void> otpVerfication() async {
    if (!formKey.currentState!.validate()) {
      emitSafe(AuthError('invalid_otp'));
      return;
    }
    final otp = otpController.text.trim();
    if (!_isValidOtp(otp)) {
      emitSafe(AuthError('invalid_otp'));
      return;
    }
    emitSafe(AuthOtpVerificationLoading());
    final identifier = loginEmailController.text.trim().isEmpty
        ? usernameController.text.trim()
        : loginEmailController.text.trim();
    if (identifier.isEmpty) {
      emitSafe(AuthError('invalid_phone'));
      return;
    }
    final res = await loginRepo.verifyLoginOtp(
      identifier: identifier,
      code: otp,
    );
    res.fold(
      (err) => emitSafe(AuthError(err)),
      (contactResponse) async {
        await _cacheSession(contactResponse);
        emitSafe(AuthSuccess());
      },
    );
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      emitSafe(AuthError('validation_error'));
      return;
    }
    final username = usernameController.text.trim();
    final displayName = displayNameController.text.trim();
    final email = createAccountEmailController.text.trim();
    final mobile = loginEmailController.text.trim();
    final pass = createAccountPasswordController.text.trim();
    final confirm = confirmNewPasswordController.text.trim();
    if (displayName.length < 2) {
      emitSafe(AuthError('name_length'));
      return;
    }
    if (username.isEmpty) {
      emitSafe(AuthError('validation_error'));
      return;
    }
    if (!_isValidEmail(email)) {
      emitSafe(AuthError('invalid_email'));
      return;
    }
    if (!_isValidPhone(mobile)) {
      emitSafe(AuthError('invalid_phone'));
      return;
    }
    if (pass.length < 8) {
      emitSafe(AuthError('password_too_short'));
      return;
    }
    if (pass != confirm) {
      emitSafe(AuthError('passwords_not_match'));
      return;
    }
    if (selectedGender == null) {
      emitSafe(AuthError('validation_error'));
      return;
    }
    emitSafe(AuthLoading());
    final user = UserRegistrationModel(
      username: username,
      email: email,
      password: createAccountPasswordController.text.trim().isEmpty
          ? '12345678'
          : createAccountPasswordController.text.trim(),
      passwordConfirmation: confirmNewPasswordController.text.trim().isEmpty
          ? '12345678'
          : confirmNewPasswordController.text.trim(),
      name: displayName,
      mobile: mobile,
      image: profileImage,
      gender: selectedGender ?? 'unspecified',
    );
    final res = await registerRepo.registerUser(user);
    res.fold(
      (err) => emitSafe(AuthError(err)),
      (data) async {
        emitSafe(AuthCreateAccountSuccess(
            message: data['message']?.toString() ?? 'Registration successful',
            emailForVerification: user.email));
      },
    );
  }

  Future<bool> requestVerificationCode({String? identifier}) async {
    final target = (identifier ?? loginEmailController.text).trim();
    if (target.isNotEmpty) {
      loginEmailController.text = target;
    }
    if (target.isEmpty) {
      emitSafe(AuthError('invalid_phone'));
      return false;
    }
    final isPhone = _isValidPhone(target);
    final isEmail = _isValidEmail(target);
    if (!isPhone && !isEmail) {
      emitSafe(
          AuthError(target.contains('@') ? 'invalid_email' : 'invalid_phone'));
      return false;
    }
    emitSafe(AuthOtpRequestInProgress());
    final res = await registerRepo.requestRegisterOtp(target);
    var success = false;
    res.fold(
      (err) => emitSafe(AuthError(err)),
      (result) async {
        final code = result.previewCode;
        if (code != null && code.isNotEmpty) {
          await Clipboard.setData(ClipboardData(text: code));
          LocalNotificationService.showPlainNotification(
            title: 'Verification Code',
            body: 'Your verification code is $code',
          );
        }
        emitSafe(AuthOtpRequested(message: result.message));
        success = true;
      },
    );
    return success;
  }

  Future<void> sendForgotPasswordCode() async {
    if (!formKey.currentState!.validate()) {
      emitSafe(AuthError('validation_error'));
      return;
    }
    emitSafe(AuthLoading());
    final res = await loginRepo.sendForgotPasswordCode(
      forgotPasswordEmailController.text.trim(),
    );
    res.fold(
      (err) => emitSafe(AuthError(err)),
      (msg) => emitSafe(AuthForgotPasswordOtpSent(
          message: msg, emailOrPhone: forgotPasswordEmailController.text)),
    );
  }

  Future<void> attemptResetPassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      emitSafe(AuthError('validation_error'));
      return;
    }
    final newPass = newPasswordController.text.trim();
    final confirm = confirmNewPasswordController.text.trim();
    if (newPass.length < 8) {
      emitSafe(AuthError('password_too_short'));
      return;
    }
    if (newPass != confirm) {
      emitSafe(AuthError('passwords_not_match'));
      return;
    }
    emitSafe(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    emitSafe(AuthResetPasswordSuccess(message: 'auth_password_reset_success'));
  }

  Future<void> _cacheSession(ContactResponse contactResponse) async {
    final token = contactResponse.data.token;
    if (token != null && token.isNotEmpty) {
      await cacheHelper.setData(AppConstants.token, token);
      PrintUtil.success('Token cached: $token');
    }
    final payload = jsonEncode(contactResponse.toJson());
    await cacheHelper.setData(AppConstants.userProfile, payload);
    globalCubit.updateCachedProfileFromJson(contactResponse.data.user.toJson());
    await globalCubit.refreshProfile();
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    displayNameController.dispose();
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
