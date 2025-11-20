import 'package:dartz/dartz.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';

abstract class ServicesRepository {
  Future<Either<String, List<ServiceModel>>> fetchServices({
    int page = 1,
    int limit = 25,
  });

  Future<Either<String, ServiceModel>> fetchServiceById(String serviceId);
}
