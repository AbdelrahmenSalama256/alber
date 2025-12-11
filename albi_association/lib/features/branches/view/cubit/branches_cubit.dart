import 'package:bloc/bloc.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/branches/data/repo/branches_repo.dart';

import 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  BranchesCubit() : super(BranchesInitial());

  Future<void> fetchBranches() async {
    emit(BranchesLoading());
    final res = await sl<BranchesRepo>().fetchBranches();
    res.fold(
      (l) => emit(BranchesError(l)),
      (r) => emit(BranchesLoaded(r)),
    );
  }
}

