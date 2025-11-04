import 'package:qafeel/features/home/data/models/donation_model.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/news/data/models/news_model.dart';

class HomeDataModel {
  final List<String> sliderImages;
  final List<ServiceModel> services;
  final List<DonationModel> donations;
  final List<DonationModel> donationServices;
  final List<NewsModel> news;
  final List<String> partners;

  const HomeDataModel({
    required this.sliderImages,
    required this.services,
    required this.donations,
    required this.donationServices,
    required this.news,
    required this.partners,
  });
}
