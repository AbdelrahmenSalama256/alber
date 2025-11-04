import 'package:dartz/dartz.dart';
import 'package:qafeel/core/database/api/dio_consumer.dart';
import 'package:qafeel/features/home/data/models/donation_model.dart';
import 'package:qafeel/features/home/data/models/home_data_model.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/news/data/models/news_model.dart';

import '../../../../core/cubit/global_cubit.dart';
import '../../../../core/services/service_locator.dart';

class HomeRepo {
  final DioConsumer api;

  HomeRepo(this.api);

  Future<Either<String, HomeDataModel>> fetchHome() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final sliderImages = <String>[
        'assets/images/png/slide1.png',
        'assets/images/png/slide1.png',
        'assets/images/png/slide1.png',
      ];

      final services = <ServiceModel>[
        ServiceModel(
            id: 1,
            image: 'assets/images/png/service1.png',
            title: 'كفالة يتيم'),
        ServiceModel(
            id: 2,
            image: 'assets/images/png/service2.png',
            title: 'صدقة جارية'),
        ServiceModel(
            id: 3, image: 'assets/images/png/service1.png', title: 'خدمة ٣'),
        ServiceModel(
            id: 4, image: 'assets/images/png/service2.png', title: 'خدمة ٤'),
        ServiceModel(
            id: 5, image: 'assets/images/png/service1.png', title: 'خدمة ٥'),
        ServiceModel(
            id: 6, image: 'assets/images/png/service2.png', title: 'خدمة ٦'),
      ];

      final donations = <DonationModel>[
        DonationModel(
          id: 1,
          title: 'دعم ذوي الاحتياجات الخاصة',
          img: 'assets/images/png/text-donation.png',
          priceValue: 'fixed',
          basicValue: 100,
          targetValue: 300000,
          collectedValue: 200000,
          percent: 66.6,
          viewpercent: 1,
        ),
        DonationModel(
          id: 2,
          title: 'إيواء المحتاجين',
          img: 'assets/images/png/text-donation.png',
          priceValue: 'variable',
          basicValue: 50,
          targetValue: 300000,
          collectedValue: 120000,
          percent: 40,
          viewpercent: 1,
        ),
        DonationModel(
          id: 3,
          title: 'كفالة طالب علم',
          img: 'assets/images/png/text-donation.png',
          priceValue: 'multi',
          basicValue: 25,
          multi1: 100,
          multi2: 200,
          multi3: 300,
          targetValue: 150000,
          collectedValue: 55000,
          percent: 36.6,
          viewpercent: 1,
        ),
      ];

      final donationServices = <DonationModel>[
        DonationModel(
          id: 4,
          title: 'دعم ذوي الاحتياجات الخاصة',
          img: 'assets/images/png/cure-main.png',
          priceValue: 'fixed',
          basicValue: 950,
          targetValue: 300000,
          collectedValue: 200000,
          percent: 66.6,
          viewpercent: 1,
        ),
        DonationModel(
          id: 5,
          title: 'إيواء المحتاجين',
          img: 'assets/images/png/cure-main.png',
          priceValue: 'fixed',
          basicValue: 500,
          targetValue: 300000,
          collectedValue: 120000,
          percent: 40,
          viewpercent: 1,
        ),
        DonationModel(
          id: 6,
          title: 'كفالة طالب علم',
          img: 'assets/images/png/cure-main.png',
          priceValue: 'fixed',
          basicValue: 250,
          targetValue: 150000,
          collectedValue: 55000,
          percent: 36.6,
          viewpercent: 1,
        ),
      ];

      final news = <NewsModel>[
        const NewsModel(
          id: 1,
          imageAsset: 'assets/images/png/news.png',
          title: 'جمعية البر بجدة',
          subtitle: 'شهادة "تكامل"',
        ),
        const NewsModel(
          id: 2,
          imageAsset: 'assets/images/png/news.png',
          title: 'جمعية البر بجدة',
          subtitle: 'شهادة "تكامل"',
        ),
        const NewsModel(
          id: 3,
          imageAsset: 'assets/images/png/news.png',
          title: 'جمعية البر بجدة',
          subtitle: 'شهادة "تكامل"',
        ),
      ];

      final partners = <String>[
        sl<GlobalCubit>().AppLogoInline,
        sl<GlobalCubit>().AppLogoInline,
        sl<GlobalCubit>().AppLogoInline,
      ];

      final data = HomeDataModel(
        sliderImages: sliderImages,
        services: services,
        donations: donations,
        donationServices: donationServices,
        news: news,
        partners: partners,
      );

      return Right(data);
    } catch (e) {
      return Left('Failed to load home data: $e');
    }
  }
}
