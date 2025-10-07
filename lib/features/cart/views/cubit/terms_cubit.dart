// lib/features/profile/views/add_donation_cart/cubit/terms_cubit.dart
import 'package:bloc/bloc.dart';

import 'terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  TermsCubit() : super(TermsLoading());

  Future<void> init() async {
    emit(TermsLoading());
    await Future.delayed(const Duration(milliseconds: 1200));
    final t = await _fetchTerms();
    emit(TermsLoaded(showPayPanel: false, terms: t));
    await Future.delayed(const Duration(milliseconds: 1200));
    final s = state;
    if (s is TermsLoaded) emit(s.copyWith(showPayPanel: true));
  }

  Future<String> _fetchTerms() async {
    return 'مرحبًا بكم في موقع جمعية البر بجدة (albir.sa). يُرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام الموقع. من خلال استخدامك للموقع، فإنك توافق على هذه الشروط وتلتزم بها بشكل كامل.';
  }
}
