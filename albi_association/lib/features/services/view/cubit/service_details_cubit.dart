import 'package:bloc/bloc.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/services/data/repo/services_repo.dart';

import 'service_details_state.dart';

class ServiceDetailsCubit extends Cubit<ServiceDetailsState> {
  ServiceDetailsCubit() : super(ServiceDetailsInitial());

  Future<void> load({required int sectionId, required int serviceId, int? branchId}) async {
    emit(ServiceDetailsLoading());
    final id = branchId ?? int.tryParse(sl<CacheHelper>().getDataString(key: AppConstants.selectedBranchId) ?? '');
    if (id == null) {
      emit(ServiceDetailsError('No branch selected'));
      return;
    }
    final repo = sl<ServicesRepo>();
    final detailsRes = await repo.fetchServiceDetails(sectionId: sectionId, serviceId: serviceId, branchId: id);
    final subRes = await repo.fetchSubServices(secId: sectionId, branchId: id);
    detailsRes.fold(
      (l) => emit(ServiceDetailsError(l)),
      (details) {
        subRes.fold(
          (l) => emit(ServiceDetailsLoaded(details: details, subServices: const [])),
          (subs) => emit(ServiceDetailsLoaded(details: details, subServices: subs)),
        );
      },
    );
  }
}

