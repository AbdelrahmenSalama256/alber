import 'package:dartz/dartz.dart';
import 'package:qafeel/features/home/data/models/donation_model.dart';
import 'package:qafeel/features/home/data/models/home_data_model.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/home/domain/repositories/services_repository.dart';
import 'package:qafeel/features/news/data/models/news_model.dart';

import '../../../../core/cubit/global_cubit.dart';
import '../../../../core/services/service_locator.dart';

class HomeRepo {
  final ServicesRepository servicesRepository;

  HomeRepo(this.servicesRepository);

  Future<Either<String, HomeDataModel>> fetchHome(
      {int page = 1, int limit = 25}) async {
    try {
      final servicesResult =
          await servicesRepository.fetchServices(page: page, limit: limit);

      return servicesResult.fold(
        (error) => Left(error),
        (services) {
          final sliderImages = <String>[
            'assets/images/png/slide1.png',
            'assets/images/png/slide1.png',
            'assets/images/png/slide1.png',
          ];

          final donations = <DonationModel>[
            DonationModel(
              id: 1,
              title: 'Emergency relief fund',
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
              title: 'Monthly food baskets',
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
              title: 'Medical aid fund',
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
              title: 'Housing renovation drive',
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
              title: 'Student sponsorships',
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
              title: 'Community health clinics',
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
              title: 'Albir launches new relief drive',
              subtitle: 'Volunteers are distributing urgent aid packs.',
            ),
            const NewsModel(
              id: 2,
              imageAsset: 'assets/images/png/news.png',
              title: 'Scholarship campaign updates',
              subtitle: 'Dozens of students received new grants this week.',
            ),
            const NewsModel(
              id: 3,
              imageAsset: 'assets/images/png/news.png',
              title: 'Medical convoy reaches rural areas',
              subtitle: 'Mobile clinics provided hundreds of checkups.',
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
        },
      );
    } catch (e) {
      return Left('Failed to load home data: $e');
    }
  }

  Future<Either<String, List<ServiceModel>>> fetchServicesList({
    int page = 1,
    int limit = 25,
  }) async {
    return servicesRepository.fetchServices(page: page, limit: limit);
  }

  Future<Either<String, ServiceModel>> fetchServiceById(String serviceId) {
    return servicesRepository.fetchServiceById(serviceId);
  }
}
