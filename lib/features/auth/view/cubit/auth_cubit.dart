import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthSuccess());
  }

  Future<void> otpVerfication() async {
    if (!formKey.currentState!.validate()) return;
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthSuccess());
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthSuccess());
  }
}
