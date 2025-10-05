import 'package:flutter/material.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> sliderImages;
  final List<Map<String, dynamic>> services;
  final List<Map<String, dynamic>> donations;
  final List<Map<String, dynamic>> donationServices;
  final List<Map<String, dynamic>> news;
  final List<String> partners;
  final Map<String, Color> extractedColors;
  final int currentSliderIndex;

  HomeLoaded({
    required this.sliderImages,
    required this.services,
    required this.donations,
    required this.donationServices,
    required this.news,
    required this.partners,
    required this.extractedColors,
    required this.currentSliderIndex,
  });

  HomeLoaded copyWith({
    List<String>? sliderImages,
    List<Map<String, dynamic>>? services,
    List<Map<String, dynamic>>? donations,
    List<Map<String, dynamic>>? donationServices,
    List<Map<String, dynamic>>? news,
    List<String>? partners,
    Map<String, Color>? extractedColors,
    int? currentSliderIndex,
  }) {
    return HomeLoaded(
      sliderImages: sliderImages ?? this.sliderImages,
      services: services ?? this.services,
      donations: donations ?? this.donations,
      donationServices: donationServices ?? this.donationServices,
      news: news ?? this.news,
      partners: partners ?? this.partners,
      extractedColors: extractedColors ?? this.extractedColors,
      currentSliderIndex: currentSliderIndex ?? this.currentSliderIndex,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
