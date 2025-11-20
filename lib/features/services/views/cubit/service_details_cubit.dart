import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';

import 'service_details_state.dart';

class ServiceDetailsCubit extends Cubit<ServiceDetailsState> {
  final HomeRepo homeRepo;

  ServiceDetailsCubit({
    required this.homeRepo,
    ServiceModel? initialService,
  }) : super(ServiceDetailsState(service: initialService));

  Future<void> loadService(String? serviceId) async {
    if (serviceId == null || serviceId.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        error: 'service_not_found',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    final result = await homeRepo.fetchServiceById(serviceId);
    result.fold(
      (error) => emit(state.copyWith(isLoading: false, error: error)),
      (service) =>
          emit(ServiceDetailsState(isLoading: false, service: service)),
    );
  }
}
