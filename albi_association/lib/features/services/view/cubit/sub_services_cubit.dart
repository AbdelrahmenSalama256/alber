import 'package:bloc/bloc.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/services/data/repo/services_repo.dart';
import 'sub_services_state.dart';

class SubServicesCubit extends Cubit<SubServicesState> {
  SubServicesCubit() : super(SubServicesInitial());

  Future<void> load({required int sectionId, String? sectionTitle}) async {
    emit(SubServicesLoading());
    final id = int.tryParse(sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId) ?? '');
    if (id == null) {
      emit(SubServicesError('No branch selected'));
      return;
    }
    final repo = sl<ServicesRepo>();
    final res = await repo.fetchSubServices(secId: sectionId, branchId: id);
    res.fold(
      (l) => emit(SubServicesError(l)),
      (r) => emit(SubServicesLoaded(sectionId: sectionId, sectionTitle: sectionTitle, items: r)),
    );
  }
}

