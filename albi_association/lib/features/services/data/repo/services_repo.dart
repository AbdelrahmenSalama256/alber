import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/features/services/data/models/service_models.dart';
import 'package:qafeel/features/services/data/models/sub_service.dart';
import 'package:qafeel/features/services/data/models/service_details.dart';

class ServicesRepo {
  final ApiConsumer api;
  ServicesRepo(this.api);

  Future<Either<String, List<ServiceSection>>> fetchSections({required int branchId}) async {
    try {
      final Response res = await api.get(EndPoints.getAllSection(branchId));
      final body = res.data;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is List) {
          final sections = data
              .whereType<Map<String, dynamic>>()
              .map((e) => ServiceSection.fromJson(e))
              .toList();
          return Right(sections);
        }
      }
      return const Left('Invalid services response');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<SubService>>> fetchSubServices({
    required int secId,
    required int branchId,
    bool quickDonation = false,
  }) async {
    try {
      final Response res = await api.get(
        EndPoints.getSubServices(secId: secId, quickDonation: quickDonation, branchId: branchId),
      );
      final body = res.data;
      List<SubService> items = [];
      if (body is Map<String, dynamic>) {
        // Expected: data.services.data is List
        final data = body['data'];
        dynamic servicesNode;
        if (data is Map<String, dynamic>) {
          servicesNode = data['services'];
        }
        if (servicesNode is Map<String, dynamic>) {
          final list = servicesNode['data'];
          if (list is List) {
            items = list
                .whereType<Map<String, dynamic>>()
                .map((e) => SubService.fromJson(e))
                .toList();
          }
        }
      }
      return Right(items);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ServiceDetailsModel>> fetchServiceDetails({
    required int sectionId,
    required int serviceId,
    required int branchId,
  }) async {
    try {
      final Response res = await api.get(
        EndPoints.getServicesDetails(serviceSectionId: sectionId, serviceId: serviceId, branchId: branchId),
      );
      final body = res.data;
      if (body is Map<String, dynamic>) {
        return Right(ServiceDetailsModel.fromJson(body));
      }
      return const Left('Invalid service details response');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
