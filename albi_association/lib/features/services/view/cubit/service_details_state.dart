import 'package:qafeel/features/services/data/models/service_details.dart';
import 'package:qafeel/features/services/data/models/sub_service.dart';

abstract class ServiceDetailsState {}

class ServiceDetailsInitial extends ServiceDetailsState {}

class ServiceDetailsLoading extends ServiceDetailsState {}

class ServiceDetailsLoaded extends ServiceDetailsState {
  final ServiceDetailsModel details;
  final List<SubService> subServices;
  ServiceDetailsLoaded({required this.details, required this.subServices});
}

class ServiceDetailsError extends ServiceDetailsState {
  final String message;
  ServiceDetailsError(this.message);
}
