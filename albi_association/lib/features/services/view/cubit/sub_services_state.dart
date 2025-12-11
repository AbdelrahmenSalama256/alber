import 'package:qafeel/features/services/data/models/sub_service.dart';

abstract class SubServicesState {}

class SubServicesInitial extends SubServicesState {}

class SubServicesLoading extends SubServicesState {}

class SubServicesLoaded extends SubServicesState {
  final int sectionId;
  final String? sectionTitle;
  final List<SubService> items;
  SubServicesLoaded({required this.sectionId, this.sectionTitle, required this.items});
}

class SubServicesError extends SubServicesState {
  final String message;
  SubServicesError(this.message);
}

