import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/data/repo/auth_repo.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int? selectedBranchId;
  void setSelectedBranchId(int? id) {
    selectedBranchId = id;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    emit(AuthLoading());
    final res = await sl<AuthRepo>().loginUser(
      phone: phoneController.text.trim(),
    );
    res.fold(
      (l) => emit(AuthError(l)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> otpVerfication() async {
    if (!formKey.currentState!.validate()) return;
    emit(AuthLoading());
    if (selectedBranchId == null) {
      emit(AuthError('please_select_branch'));
      return;
    }
    final res = await sl<AuthRepo>().confirmOtp(
      phone: phoneController.text.trim(),
      code: otpController.text.trim(),
    );
    res.fold(
      (l) => emit(AuthError(l)),
      (payload) async {
        final donor = payload.donor;
        if (donor != null) {
          await sl<GlobalCubit>().setDonor(
            id: donor.id,
            name: donor.name,
            phone: donor.phone,
            membershipNo: donor.membershipNo,
          );
        }
        // token caching handled in repo; just emit success
        emit(AuthSuccess());
      },
    );
  }

  Future<void> resendOtp() async {
    if (phoneController.text.trim().isEmpty) return;
    emit(AuthLoading());
    final res = await sl<AuthRepo>().resendOtp(
      phone: phoneController.text.trim(),
    );
    res.fold(
      (l) => emit(AuthError(l)),
      (_) => emit(AuthSuccess()),
    );
  }

  // Registration removed in this flow
}
