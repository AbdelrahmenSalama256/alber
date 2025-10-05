import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    try {
      await Future.delayed(const Duration(seconds: 4));

      final sliderImages = await _fetchSliderImages();
      final services = await _fetchServices();
      final donations = await _fetchDonations();
      final donationServices = await _fetchDonationServices();
      final news = await _fetchNews();
      final partners = await _fetchPartners();

      final extractedColors = await _extractColors(services);

      emit(HomeLoaded(
        sliderImages: sliderImages,
        services: services,
        donations: donations,
        donationServices: donationServices,
        news: news,
        partners: partners,
        extractedColors: extractedColors,
        currentSliderIndex: 0,
      ));
    } catch (e) {
      emit(HomeError('Failed to load data: $e'));
    }
  }

  void updateSliderIndex(int index) {
    final state = this.state;
    if (state is HomeLoaded) {
      emit(state.copyWith(currentSliderIndex: index));
    }
  }

  Future<Map<String, Color>> _extractColors(
      List<Map<String, dynamic>> services) async {
    final Map<String, Color> colors = {};

    for (var service in services) {
      final imagePath = service['image'];
      try {
        final palette = await PaletteGenerator.fromImageProvider(
          AssetImage(imagePath),
          maximumColorCount: 10,
        );
        final color = palette.dominantColor?.color ?? Colors.grey;
        colors[imagePath] = color;
      } catch (e) {
        colors[imagePath] = Colors.grey;
      }
    }

    return colors;
  }

  Future<List<String>> _fetchSliderImages() async {
    return [
      'assets/images/png/slide1.png',
      'assets/images/png/slide1.png',
      'assets/images/png/slide1.png',
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchServices() async {
    return [
      {'image': 'assets/images/png/service1.png', 'title': 'كفالة يتيم'},
      {'image': 'assets/images/png/service2.png', 'title': 'صدقة جارية'},
      {'image': 'assets/images/png/service1.png', 'title': 'خدمة ٣'},
      {'image': 'assets/images/png/service2.png', 'title': 'خدمة ٤'},
      {'image': 'assets/images/png/service1.png', 'title': 'خدمة ٥'},
      {'image': 'assets/images/png/service2.png', 'title': 'خدمة ٦'},
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchDonations() async {
    return [
      {
        'title': 'دعم ذوي الاحتياجات الخاصة',
        'image': 'assets/images/png/text-donation.png',
        'raised': 200000.0,
        'goal': 300000.0,
        'amount': 950.0,
        'qty': 1,
      },
      {
        'title': 'إيواء المحتاجين',
        'image': 'assets/images/png/text-donation.png',
        'raised': 120000.0,
        'goal': 300000.0,
        'amount': 500.0,
        'qty': 1,
      },
      {
        'title': 'كفالة طالب علم',
        'image': 'assets/images/png/text-donation.png',
        'raised': 55000.0,
        'goal': 150000.0,
        'amount': 250.0,
        'qty': 1,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchDonationServices() async {
    return [
      {
        'title': 'دعم ذوي الاحتياجات الخاصة',
        'image': 'assets/images/png/cure-main.png',
        'raised': 200000.0,
        'goal': 300000.0,
        'amount': 950.0,
        'qty': 1,
      },
      {
        'title': 'إيواء المحتاجين',
        'image': 'assets/images/png/cure-main.png',
        'raised': 120000.0,
        'goal': 300000.0,
        'amount': 500.0,
        'qty': 1,
      },
      {
        'title': 'كفالة طالب علم',
        'image': 'assets/images/png/cure-main.png',
        'raised': 55000.0,
        'goal': 150000.0,
        'amount': 250.0,
        'qty': 1,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchNews() async {
    return [
      {
        'imageAsset': "assets/images/png/news.png",
        'title': "جمعية البر بجدة",
        'subtitle': "شهادة \"تكامل\"",
      },
      {
        'imageAsset': "assets/images/png/news.png",
        'title': "جمعية البر بجدة",
        'subtitle': "شهادة \"تكامل\"",
      },
      {
        'imageAsset': "assets/images/png/news.png",
        'title': "جمعية البر بجدة",
        'subtitle': "شهادة \"تكامل\"",
      },
    ];
  }

  Future<List<String>> _fetchPartners() async {
    return [
      "assets/images/png/alber-inline-logo.png",
      "assets/images/png/alber-inline-logo.png",
      "assets/images/png/alber-inline-logo.png",
    ];
  }
}
