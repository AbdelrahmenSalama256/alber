import 'package:flutter/material.dart';
import 'package:qafeel/features/home/data/models/donation_model.dart';
import 'package:qafeel/features/news/data/models/news_model.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> sliderImages;
  final List<ServiceModel> services;
  final List<DonationModel> donations;
  final List<DonationModel> donationServices;
  final List<NewsModel> news;
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
    List<ServiceModel>? services,
    List<DonationModel>? donations,
    List<DonationModel>? donationServices,
    List<NewsModel>? news,
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
