import 'package:qafeel/features/home/data/models/service_model.dart';

class ServiceDetailsState {
  static const _omit = Object();

  final bool isLoading;
  final ServiceModel? service;
  final String? error;

  const ServiceDetailsState({
    this.isLoading = false,
    this.service,
    this.error,
  });

  ServiceDetailsState copyWith({
    bool? isLoading,
    ServiceModel? service,
    Object? error = _omit,
  }) {
    return ServiceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      service: service ?? this.service,
      error: identical(error, _omit) ? this.error : error as String?,
    );
  }
}
