import 'package:qafeel/core/cubit/app_cubit.dart';

import 'terms_state.dart';

class TermsCubit extends AppCubit<TermsState> {
  TermsCubit() : super(TermsLoading());

  Future<void> init() async {
    emitSafe(TermsLoading());
    await Future.delayed(const Duration(seconds: 2));
    final t = await _fetchTerms();
    emitSafe(TermsLoaded(showPayPanel: false, terms: t));
    await Future.delayed(const Duration(seconds: 2));
    final s = state;
    if (s is TermsLoaded) emitSafe(s.copyWith(showPayPanel: true));
  }

  Future<String> _fetchTerms() async {
    return 'مرحبًا بكم في موقع جمعية البر بجدة (albir.sa). يُرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام الموقع. من خلال استخدامك للموقع، فإنك توافق على هذه الشروط وتلتزم بها بشكل كامل.';
  }
}
