import 'package:flutter/material.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceModel> services;
  final Map<String, Color> extractedColors;
  final bool isColorLoading;

  ServicesLoaded({
    required this.services,
    required this.extractedColors,
    this.isColorLoading = false,
  });

  ServicesLoaded copyWith({
    List<ServiceModel>? services,
    Map<String, Color>? extractedColors,
    bool? isColorLoading,
  }) {
    return ServicesLoaded(
      services: services ?? this.services,
      extractedColors: extractedColors ?? this.extractedColors,
      isColorLoading: isColorLoading ?? this.isColorLoading,
    );
  }
}

class ServicesError extends ServicesState {
  final String message;
  ServicesError(this.message);
}
