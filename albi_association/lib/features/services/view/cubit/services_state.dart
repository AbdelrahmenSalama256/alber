import 'package:flutter/material.dart';
import 'package:qafeel/features/services/data/models/service_models.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceSection> sections;
  final List<ServiceItem> items;
  final Map<String, Color> extractedColors;

  ServicesLoaded({
    required this.sections,
    required this.items,
    required this.extractedColors,
  });
}

class ServicesError extends ServicesState {
  final String message;
  ServicesError(this.message);
}
